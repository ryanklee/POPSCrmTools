Function Remove-Component{
    Param
    (
        [SolutionComponent[]]$Component,
        [string]$solutionName,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    Write-Verbose 'Testing target only components for existence in other solutions...'
    [SolutionComponent[]]$remove = $Component | Where-Object -Filter {-Not (Test-IsSingleSolutionComponent $_.objectid $conn)}
    [SolutionComponent[]]$delete = Compare-CrmSolutionComponent $component $remove 
    
    $removal = @{}

    if ($remove) {
        Remove-CrmComponentFromSolution -Component ($remove + $delete) -SolutionName $solutionName -Conn $conn
        $removal["Removed"] = $remove + $delete
    }

    <# if ($delete) {
        Remove-SolutionComponentFromCrm -Component $delete -Conn $conn 
        $removal["Deleted"] = $delete
    } #>
    
    Write-Output $Removal
}