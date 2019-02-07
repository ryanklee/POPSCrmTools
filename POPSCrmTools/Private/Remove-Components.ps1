Function Remove-Components{
    Param
    (
        [SolutionComponent[]]$Component,
        [string]$solutionName,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    [SolutionComponent[]]$remove = $Component | Where-Object -Filter {-Not (Test-IsSingleSolutionComponent $_.objectid $conn)} 
    [SolutionComponent[]]$delete = $Component | Where-Object -Filter {(Test-IsSingleSolutionComponent $_.objectid $conn)} 
    $removal = @{}

    if ($remove) {
        Remove-CrmComponentFromSolution -Component $remove -SolutionName $solutionName -Conn $conn
        $removal["Removed"] = $remove
    }

    if ($delete) {
        Remove-ComponentFromCrm -Component $delete -Conn $conn 
        $removal["Deleted"] = $delete
    }
    
    Write-Output $Removal
}