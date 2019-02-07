Function Test-CrmSolutionExists {
    <#
        .SYNOPSIS
            Tests whether a solution exists on a Dynamics Crm Org.

        .OUTPUTS
            'True' if the solution exists. 'False' if the solution does not exist.
    #>
    [cmdletbinding()]
    Param
    (
        # Dynamics 365 Crm Connection
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn,
        # Unique Name of Solution
        [string]$SolutionName
    )

    $query = @"
    <fetch>
    <entity name="solution" >
      <filter>
        <condition attribute="uniquename" operator="eq" value="$solutionName" />
      </filter>
    </entity>
  </fetch>
"@
    try {
        $result = Get-CrmRecordsByFetch -Conn $conn -Fetch $query -AllRows -ErrorAction Stop -WarningAction SilentlyContinue
    }
    catch { 
        $err = $Exception.Message
        throw $err
    }

    $orgName = $conn.ConnectedOrgUniqueName 

    if ($result.CrmRecords.count -eq 1) {
        Write-Verbose "Solution $solutionName exists on $orgName..."
        Write-Output $true
    } else {
        Write-Verbose "Solution $solutionName does not exist..."
        Write-Output $false
    }
}