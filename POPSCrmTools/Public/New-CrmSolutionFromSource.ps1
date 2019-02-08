Function New-CrmSolutionFromSource {
    <#
        .SYNOPSIS
            Builds a Solution in a Dynamics Crm org based on a source solution
            in another org.
    
        .DESCRIPTION
            Builds a Solution in a Dynamics Crm org based on a source solution
            in another org.

            Necessary parameters read from config file. File can be generated
            using the '-GenerateConfig' switch -- this will prompt you for 
            the required paramatere -- or via the 'New-CrmSolutionFromSourceConfig' cmdlet.

            If Solution does not already exist on target, it will be created. If publisher
            does not already exist on target, it will be created. All publisher info and 
            solution name are assumed to be the same on source and target.

            WARNING: If the target Solution exists and contains SolutionComponents, any
            SolutionComponents not in source Solution will either (a) be removed from
            the target Solution if they exist in other Solutions on the target org, or
            (b) deleted if they exist in target solution only and nowhere else.

            If specified in config, entities with rootcomponentbehaviors of 0 will be
            changed to 1.

            This effectively Syncs the two solutions, cleaning 'rogue' SolutionComponents from
            the target org.

        .OUTPUTS
            -Solution on target Dynamics Crm Org.

            -'Errorlog.txt', if errors encountered.

            -'BuildCrmSolutionLog.json', contains useful information about SolutionComponents
             manipulated by the cmdlet. This includes those Added, Skipped, and comparison results.
    #>
    [cmdletbinding()]
    Param 
    (
        [Parameter(ParameterSetName='Cred')]
        [pscredential]$Credential,
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [string]$UserName,
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [securestring]$Password,
        [Parameter(Mandatory=$true)]
        [string]$ConfigFilePath,
        [switch]$GenerateConfig = $false
    )
    
    if ($GenerateConfig){
        New-CrmSolutionFromSourceConfig -FileName $ConfigFilePath
    }

    try {
        $config = Import-PowerShellDataFile $PWD/$ConfigFilePath
    } catch {
        $err = $_.Exception.Message
        $err | Out-File errorlog.txt -Append
        throw $err
    }

    $sourceOrg                  = $config.SourceOrg  
    $targetOrg                  = $config.TargetOrg
    $fixRootComponentBehavior   = $config.FixRootComponentBehavior
    $solutionName               = $config.SolutionName
    $publisher                  = $config.Publisher
    
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
        New-CrmSolution -SolutionName $solutionName -Publisher $publisher -Conn $targetConn
        $log["TemplateCreaded"] = $true 
    }   

    if ($fixRootComponentBehavior){
        [SolutionComponent[]]$components["PreUpdateSource"] = Get-CrmSolutionComponent -Conn $sourceConn -SolutionName $solutionName
        $components["RootComponentBehaviorUpdated"] = Update-RootComponentBehavior -Component $components.PreUpdateSource -SolutionName $solutionName -Conn $sourceConn
    }

    [SolutionComponent[]]$components["Source"] = Get-CrmSolutionComponent -Conn $sourceConn -SolutionName $solutionName
    [SolutionComponent[]]$components["Target"] = Get-CrmSolutionComponent -Conn $targetConn -SolutionName $solutionName
    
    if ($components.Source -and
        $components.Target) {
        [SolutionComponent[]]$components["SourceOnly"] = Get-CrmSolutionComponentComparison -ReferenceComponent $components.Source -DifferenceComponent $components.Target
        [SolutionComponent[]]$components["TargetOnly"] = Get-CrmSolutionComponentComparison -ReferenceComponent $components.Target -DifferenceComponent $components.Source
    }
    
    if ($components.SourceOnly) { 
        $components["Manifest"] = Compare-ComponentsWithTargetOrg -Component $components.SourceOnly -Conn $targetConn
    } else {
        $components["Manifest"] = Compare-ComponentsWithTargetOrg -Component $components.Source -Conn $targetConn
    }
    
    Write-ManifestOut -Manifest $components.Manifest
    
    if ($components.Manifest.Add) {
        Add-Component -Conn $targetConn -Component $components.Manifest.Add -SolutionName $solutionName
    }
    
    $log["Timestamp"] = (Get-Date -Format o)
    $log["Config"] = $config
    $log["Components"] = $components
    ConvertTo-Json -InputObject $log -Depth 10 | Out-File -FilePath "BuildCrmSolutionLog.json"
    Write-Verbose "Data log saved to BuildSolutionLog.json"
    if (Test-Path 'errorlog.txt') {
        Write-Verbose 'Errors logged to errorlog.txt'
    } else {
        Write-Verbose 'No errors logged.'
    }
}

