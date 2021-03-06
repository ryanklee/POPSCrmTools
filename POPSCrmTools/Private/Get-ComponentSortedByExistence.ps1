
Function Get-ComponentSortedByExistence { 
    Param
    (
        [SolutionComponent[]]$Component,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$TargetConn
    )

    $Components = $Component

    Write-Verbose 'Testing source components exist in target crm...'
    [SolutionComponent[]]$existing = @()
    [SolutionComponent[]]$nonexisting = @()
    foreach ($comp in $Components){
        if (Test-CrmSolutionComponentExists -SolutionComponent $comp -Conn $Conn){

            $existing += $comp
        } else {
            $nonexisting += $comp
        }
    }

    $Exist = @{"True" = $existing; "False" = $nonexisting}
    Write-Output $Exist 
}
