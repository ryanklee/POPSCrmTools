Function Test-CrmSolutionComponentExists { 
    <#
        .SYNOPSIS
            Tests whether a SolutionComponent exists in any solution on a Dynamics Crm Org. Includes default solution.

        .OUTPUTS
            'True' if the SolutionComponent exists. 'False' if the SolutionComponent does not exist.
    #>
    [cmdletbinding()]
    Param
    (
        # ObjectId of SolutionComponent
        [parameter(Position = 0)]
        [guid]$ObjectId,
        # Dynamics 365 Crm Connection
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