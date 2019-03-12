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
        [SolutionComponent]$SolutionComponent,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    $ObjectId = $SolutionComponent.ObjectId
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
        $result = Get-CrmRecordsByFetch -Conn $Conn -Fetch $query -ErrorAction Stop -WarningAction SilentlyContinue
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