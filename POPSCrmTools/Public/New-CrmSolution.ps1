Function New-CrmSolution {
    <#
        .SYNOPSIS
            Creates a new solution on a Dynamics crm org.
    #>
    [cmdletbinding()]
    Param 
    (
        # UniqueName of solution
        [string]$SolutionName,
        # Publisher info
        # Requires entries: 'uniquename', 'friendlyname', 'publisherid', 'version'
        [hashtable]$Publisher,
        # Dynamics crm connection
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    $publisherId = Get-CrmPublisherId -PublisherName $publisher.Name -conn $conn
    if (-Not $publisherId) { 
        $publisherId = New-CrmPublisher -Publisher $publisher -conn $conn
    } 

    $publisherLookup = New-CrmEntityReference -Id $publisherId -EntityLogicalName publisher

    $fields = @{'uniquename' = $solutionName; 
                'friendlyname' = $solutionName;
                'publisherid' = $publisherLookup; 
                'version' = '1.0.0.0'}

    try {
        Write-Verbose 'Creating template target solution...'
        New-CrmRecord -EntityLogicalName solution -Field $fields -conn $conn -ErrorAction Stop | Out-Null 
        Write-Verbose 'Template target solution created...'
    }
    catch {
        $err = $_.Exception.Message
        $err | Out-File -Append errorlog.txt
        throw $err 
    } 
}