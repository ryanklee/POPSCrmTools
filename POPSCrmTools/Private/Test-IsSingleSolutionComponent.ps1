Function Test-IsSingleSolutionComponent {
    Param
    (
        [parameter(Position = 0)]
        [guid]$ObjectId,
        [parameter(Position = 1)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn
    )

    $query = @"
        <fetch>
            <entity name="solutioncomponent" >
                <attribute name="solutionidname" />
                <filter>
                <condition attribute="objectid" operator="eq" value="$objectId" />
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

    if ($result.CrmRecords.Count -eq 1) {
        Write-Output $true
    } else {
        Write-Output $false
    }
}