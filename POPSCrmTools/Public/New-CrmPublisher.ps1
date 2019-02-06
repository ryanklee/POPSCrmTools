Function New-CrmPublisher {
    [cmdletbinding()]
    Param
    (
        [hashtable]$Publisher,
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