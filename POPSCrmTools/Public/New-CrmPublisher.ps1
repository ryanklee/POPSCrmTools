Function New-CrmPublisher {
    <#
        .SYNOPSIS
            Creates a new Publisher record on a Dynamics crm org.
    #>
    [cmdletbinding()]
    Param
    (
        # Publisher record info
        # Required entries: 'uniquename', 'friendlyname', 'customizationprefix'
        [hashtable]$Publisher,
        # Dynamics crm connection
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn
    )

    $fields = @{'uniquename' = $publisher.Name; 
                'friendlyname' = $publisher.DisplayName;
                'customizationprefix' = $publisher.Prefix}

    try {
        $result = New-CrmRecord -EntityLogicalName publisher -Field $fields -conn $conn -ErrorAction Stop
        Write-Output $result
    }
    catch {
        throw $_.Exception.Message 
    } 
}