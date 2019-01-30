Function Get-CrmPublisherId {
    Param 
    (
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn,
        [string]$PublisherName
    )

        $query = @"
        <fetch>
            <entity name="publisher" >
                <attribute name="publisherid" />
                <filter>
                <condition attribute="uniquename" operator="eq" value="$PublisherName" />
                </filter>
            </entity>
        </fetch>
"@

    try {
        $result = Get-CrmRecordsByFetch -Conn $conn -Fetch $query -AllRows -ErrorAction Stop -WarningAction SilentlyContinue
    }
    catch {
        $err = $_.Exception.Message
        throw $err
    }

    if ($result.CrmRecords.Count -gt 0) {
        Write-Output $result.CrmRecords.publisherid   
    }
}