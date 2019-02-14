Function New-CrmSolutionFromSourceConfig {
    <#
        .SYNOPSIS
            Generates config file for 'New-CrmSolutionFromSource'
         
        .DESCRIPTION
            Generates config file for 'New-CrmSolutionFromSource'. Assumes
            that all publisher info and solution name are the same for source
            and target.
        
        .OUTPUTS
            Psd1 config file of name specified in parameter.
    #>
    Param
    (
        # FileName for config
        [Parameter(Mandatory=$true)]
        [string]$FileName,
        # Name of the Dynamics Crm org containing source Solution
        [Parameter(Mandatory=$true)]
        [string]$SourceOrg,
        # Name of the Dynamics Crm org to contain target Solution
        [Parameter(Mandatory=$true)]
        [string]$TargetOrg,
        # UniqueName of source Solution and for target solution
        [Parameter(Mandatory=$true)]
        [string]$SolutionName,
        # Change any rootcomponentbehaviors of 0 to 1. Default is False.
        [Parameter(Mandatory=$true)]
        [bool]$FixRootComponentBehavior,
        # UniqueName of Publisher
        [Parameter(Mandatory=$true)]
        [string]$PubName,
        # DisplayName of Publisher
        [Parameter(Mandatory=$true)]
        [string]$PubDisplayName,
        # Prefix for publisher
        [Parameter(Mandatory=$true)]
        [string]$PubPrefix
    )
    
    $config = @"
    @{
    SourceOrg = '$SourceOrg'
    TargetOrg = '$TargetOrg'
    SolutionName = '$SolutionName'
    FixRootComponentBehavior = '$FixRootComponentBehavior'
    Publisher = @{
        Name = '$PubName'
        DisplayName = '$PubDisplayName'
        Prefix = '$PubPrefix'
    }
}
"@ 

    Out-File -FilePath "$fileName.psd1" -InputObject $config
}