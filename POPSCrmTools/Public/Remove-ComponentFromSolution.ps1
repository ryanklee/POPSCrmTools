Function Remove-ComponentFromSolution {
    Param
    (
        [string]$SolutionName,
        [array]$Component,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn
    )

    Write-Verbose ("Removing {0} from {1}" -f $component.Length, $solutionName)
    foreach ($component in $Component){
        $request = [Microsoft.Crm.Sdk.Messages.RemoveSolutionComponentRequest]::new()
        $request.ComponentId = $component.objectid
        $request.ComponentType = $component.componenttype
        $request.SolutionUniqueName = $SolutionName

        try {
            Write-Verbose ("Removing {0} from {1}" -f $request.ComponentId, $request.SolutionUniqueName) 
            $conn.Execute($request) | Out-Null
        }
        catch {
            $err = $_.Exception.Message
            ("{0} {1}" -f $request, $err) | Out-File -Append errorlog.txt 
            throw $err
        }
    }
}