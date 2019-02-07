
Function Get-ComponentSortedOnExistence { 
    Param
    (
        [SolutionComponent[]]$Component,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    Write-Verbose 'Testing source components exist in target crm...'
    [SolutionComponent[]]$existing = @();
    [SolutionComponent[]]$nonexisting = @()
    foreach ($component in $Component){
        if (Test-CrmSolutionComponentExists $component.ObjectId $Conn){
            $existing += $component
        } else {
            $nonexisting += $component
        }
    }

    $Exist = @{"True" = $existing; "False" = $nonexisting}
    Write-Output $Exist 
}
