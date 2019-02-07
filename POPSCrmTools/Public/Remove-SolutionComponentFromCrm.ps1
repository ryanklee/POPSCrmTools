Function Remove-SolutionComponentFromCrm {
    <#
        .SYNOPSIS
            Deletes SolutionComponents from a Dynamics Crm org.

        .EXAMPLE
            Remove-SolutionComponentFromCrm -Object
    #>
    [cmdletbinding()]
    Param
    (
        # ObjectIds of SolutionComponents to delete.
        [array]$ObjectId,
        # Dynamics Crm org connection that contains the SolutionComponent(s)
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    Write-Verbose ("Deleting {0} from {1}" -f $component.Length, $Conn.ConnectedOrgUniqueName)
    foreach($id in $objectId){
        try {
            Write-Verbose ("Deleting {0} from {1}" -f $ObjectId, $Conn.ConnectedOrgUniqueName)
            $conn.Delete('solutioncomponent', $id) | Out-Null
            Write-Verbose 'Deleted...'
        }
        catch {
            $err = $_.Exception.Message
            $err | Out-File -Append errorlog.txt
            throw $err
        }
    }
}