Function Get-CrmSolutionComponent {
    [cmdletbinding()]
    Param
    (
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn,
        [string]$solutionName
    )

    $query = @"
        <fetch>
            <entity name="solutioncomponent" >
                <all-attributes/> 
                <filter>
                    <condition attribute="solutionidname" operator="eq" value="$solutionName" />
                </filter>
            </entity>
        </fetch>
"@

    $orgName = $conn.ConnectedOrgUniqueName

    try {
        Write-Verbose ("Getting components from {0} on {1}..." -f $solutionName, $conn.ConnectedOrgUniqueName)
        $result = Get-CrmRecordsByFetch -Conn $conn -Fetch $query -AllRows -ErrorAction Stop -WarningAction SilentlyContinue
        Write-Verbose ("{0} components found" -f $result.CrmRecords.Count)     
    }
    catch { 
        $err = $_.Exception.Message
        throw $err
    }
    [SolutionComponent[]]$components = @()
    foreach ($record in $result.CrmRecords){
        $Components += (Set-SolutionComponent -Record $record)
    }
    Write-Output $Components  
}