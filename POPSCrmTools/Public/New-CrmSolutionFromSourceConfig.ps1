Function New-CrmSolutionFromSourceConfig {
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$FileName,
        [Parameter(Mandatory=$true)]
        [string]$SourceOrg,
        [Parameter(Mandatory=$true)]
        [string]$TargetOrg,
        [Parameter(Mandatory=$true)]
        [string]$SolutionName,
        [Parameter(Mandatory=$true)]
        [bool]$FixRootComponentBehavior,
        [Parameter(Mandatory=$true)]
        [string]$PubName,
        [Parameter(Mandatory=$true)]
        [string]$PubDisplayName,
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