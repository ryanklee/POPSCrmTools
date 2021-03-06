Function Sync-CrmSolutionFromSource {
    <#
        .SYNOPSIS
            Builds a Solution in a Dynamics Crm org based on a source solution
            in another org.
    
        .DESCRIPTION
            Builds a Solution in a Dynamics Crm org based on a source solution
            in another org.

            Necessary parameters read from config file. File can be generated
            using the '-GenerateConfig' switch -- this will prompt you for 
            the required parameters -- or via the 'New-CrmSolutionFromSourceConfig' cmdlet.

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
        #Credentials for Source environment
        [Parameter(ParameterSetName='Cred')]
        [pscredential]$SourceCredential,

        #Credentials for Target environment
        [Parameter(ParameterSetName='Cred')]
        [pscredential]$TargetCredential,

        #Username for Source environment
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [string]$SourceUsername,

        #Password for Source environment
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [securestring]$SourcePassword,

        #Username for Target environment
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [string]$TargetUsername,

        #Password for Target environment
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [securestring]$TargetPassword,

        #Path to existing config file
        [Parameter(Mandatory=$true)]
        [string]$ConfigFilePath
    )

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
    
    if ($PSBoundParameters.ContainsKey('SourcePassword')){
        $sourceConn = Get-CrmConnection -Username $SourceUsername -Password $SourcePassword -Url "https://$sourceOrg.crm.dynamics.com" 
        $targetConn = Get-CrmConnection -Username $TargetUsername -Password $TargetPassword -Url "https://$targetOrg.crm.dynamics.com"
    } else {
        $sourceConn = Get-CrmConnection -Cred $SourceCredential -Url "https://$sourceOrg.crm.dynamics.com" 
        $targetConn = Get-CrmConnection -Cred $TargetCredential -Url "https://$targetOrg.crm.dynamics.com"
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
        $components["PreUpdateSource"] = Get-CrmSolutionComponent -Conn $sourceConn -SolutionName $solutionName
        $components["RootComponentBehaviorUpdated"] = Update-RootComponentBehavior -Component $components.PreUpdateSource -SolutionName $solutionName -Conn $sourceConn 
    }

    $components["Source"] = @{"Original" = Get-CrmSolutionComponent -Conn $sourceConn -SolutionName $solutionName} 
    $components["Target"] = @{"Original" = Get-CrmSolutionComponent -Conn $targetConn -SolutionName $solutionName}

    Write-Verbose 'Pulling down metadata...'
    $metadata = @{
        "Source" = Get-CrmEntityAllMetadata -Conn $sourceConn -EntityFilters All | MetadataToHash;
        "Target" = Get-CrmEntityAllMetadata -Conn $targetConn -EntityFilters All | MetadataToHash
    }
    Write-Verbose 'Updating source components against metadata...'
    $components.Source["Updated"] = Update-ComponentAgainstMetadata -SolutionComponent $components.Source.Original -MetadataSource $metadata.source -MetadataTarget $metadata.target -SourceConn $sourceConn -TargetConn $targetConn

    if ($components.Source.Updated -and 
        $components.Target.Original) {
        [SolutionComponent[]]$components.Source["SourceOnly"] = Compare-CrmSolutionComponent -ReferenceComponent $components.Source.Updated -DifferenceComponent $components.Target.Original
        [SolutionComponent[]]$components.Target["TargetOnly"] = Compare-CrmSolutionComponent -ReferenceComponent $components.Target.Original -DifferenceComponent $components.Source.Updated
    }

    if ($components.Source.SourceOnly) { 
        $components["Manifest"] = Compare-ComponentsWithTargetOrg -Component $components.Source.SourceOnly -Metadata $metadata -SourceConn $SourceConn -TargetConn $targetConn
    } else {
        $components["Manifest"] = Compare-ComponentsWithTargetOrg -Component $components.Source.Updated -Metadata $metadata -SourceConn $SourceConn -TargetConn $targetConn
    }
    
    # $components.Manifest["Removals"] = $components.Target.TargetOnly

    Write-ManifestOut -Manifest $components.Manifest
    
    <# if ($components.Manifest.Removals){
        Remove-Component -Component $components.Manifest.Removals -Conn $targetConn -SolutionName $solutionName | Out-Null
    } #>

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

