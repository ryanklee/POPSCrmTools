Function Test-CrmComponentExists { 
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
                <condition attribute="objectid" operator="eq" value="$ObjectId" />
                </filter>
            </entity>
        </fetch>
"@

    try {
        $result = Get-CrmRecordsByFetch -Conn $conn -Fetch $query -ErrorAction Stop -WarningAction SilentlyContinue
    }
    catch { 
        $err = $_.Exception.Message
        throw $err
    }   

    if ($result.CrmRecords.count -eq 0) {
       Write-Output $false
    } else {
       Write-Output $true  
    }
}