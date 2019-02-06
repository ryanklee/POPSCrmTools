Function Remove-ComponentFromCrm {
    [cmdletbinding()]
    Param
    (
        [array]$ObjectId,
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