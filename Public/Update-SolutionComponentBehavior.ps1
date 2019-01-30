Function Update-SolutionComponentBehavior {
    Param
    (
        [SolutionComponent[]]$Component,
        [String]$SolutionName,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn
    )

    foreach($component in $Component){
        $request = [Microsoft.Crm.Sdk.Messages.UpdateOptionValueRequest]::new()
        $request.DisplayName = ""
    }
    
    
    
    try {
        Write-Verbose ("Adding {0} " -f $request.ComponentId)
        $conn.Execute($request) | Out-Null
    } 
    catch {
        $err = $_.Exception.Message
        $err | Out-File -Append 'errolog.txt'
        throw $err
    }
}