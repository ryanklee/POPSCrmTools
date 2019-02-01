Function New-CrmSolutionFromSource {
    [cmdletbinding()]
    Param 
    (
        [Parameter(ParameterSetName='Cred')]
        [pscredential]$Credential,
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [string]$UserName,
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [securestring]$Password,
        [string]$ConfigFilePath
    )
        
    $config = Import-PowerShellDataFile $PWD/$ConfigFilePath
    $sourceOrg = $config.SourceOrg  
    $targetOrg = $config.TargetOrg
    $solutionName = $config.SolutionName
    $publisher  = $config.Publisher
    $components = @{}
    $log = @{}
    
    
    if ($PSBoundParameters.ContainsKey('Password')){
        $sourceConn = Get-CrmConnection -UserName $UserName -Password $Password -Url "https://$sourceOrg.crm.dynamics.com" 
        $targetConn = Get-CrmConnection -UserName $UserName -Password $Password -Url "https://$targetOrg.crm.dynamics.com"
    } else {
        $sourceConn = Get-CrmConnection -Cred $credential -Url "https://$sourceOrg.crm.dynamics.com" 
        $targetConn = Get-CrmConnection -Cred $credential -Url "https://$targetOrg.crm.dynamics.com"
    }

    $sourceSolutionExists = Test-CrmSolutionExists -Conn $sourceConn -SolutionName $solutionName
	$targetSolutionExists = Test-CrmSolutionExists -Conn $targetConn -SolutionName $solutionName    
    
    if (-Not $sourceSolutionExists) {
        $err = "Source solution does not exist"
        $err | Out-File -Append 'errorlog.txt'
        throw $err 
    }    
    
    if (-Not $targetSolutionExists) {
        New-CrmTemplateSolution -SolutionName $solutionName -Publisher $publisher -Conn $targetConn
        $log["TemplateCreaded"] = $true 
    }   

    [SolutionComponent[]]$components["Source"] = Get-CrmSolutionComponent -Conn $sourceConn -SolutionName $solutionName
    [SolutionComponent[]]$components["Target"] = Get-CrmSolutionComponent -Conn $targetConn -SolutionName $solutionName
    
    if ($components.Source -and
        $components.Target) {
        [SolutionComponent[]]$components["SourceOnly"] = Get-CrmSolutionComponentComparison -ReferenceComponent $components.Source -DifferenceComponent $components.Target
        [SolutionComponent[]]$components["TargetOnly"] = Get-CrmSolutionComponentComparison -ReferenceComponent $components.Target -DifferenceComponent $components.Source
    }
    
    if ($components.SourceOnly) { 
        $components["Manifest"] = Compare-ComponentsWithTargetOrg -Components $components.SourceOnly -Conn $targetConn
    } else {
        $components["Manifest"] = Compare-ComponentsWithTargetOrg -Components $components.Source -Conn $targetConn
    }
    
    Write-ManifestOut -Manifest $components.Manifest
    
    if ($components.Manifest.Add) {
        Add-Component -Conn $targetConn -Component $components.Manifest.Add -SolutionName $solutionName
    }

    Write-Verbose 'Post-Run Cleanup...'
    [SolutionComponent[]]$components["PostRunSource"] = Get-CrmSolutionComponent -Conn $sourceConn -SolutionName $solutionName
    [SolutionComponent[]]$components["PostRunTarget"] = Get-CrmSolutionComponent -Conn $targetConn -SolutionName $solutionName

    if ($components.PostRunTarget -and
        $components.PostRunSource){
        [SolutionComponent[]]$components["PostRunTargetOnly"] = Get-CrmSolutionComponentComparison -ReferenceComponent $components.PostRunTarget -DifferenceComponent $components.PostRunSource
    }

    if ($components.PostRunTargetOnly) {
        $components["PostRunRemovals"] = Remove-Components -Component $components.PostRunTargetOnly -Conn $targetConn -SolutionName $solutionName
    } 
    
    $log["Timestamp"] = (Get-Date -Format o)
    $log["Config"] = $config
    $log["Components"] = $components
    ConvertTo-Json -InputObject $log -Depth 10 | Out-File -FilePath "BuildCrmSolutionLog.json"
    if (Test-Path 'errorlog.txt') {Write-Verbose 'Errors logged in errorlog.txt'}
}

