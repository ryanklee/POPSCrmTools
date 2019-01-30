Function Add-Component {
    Param
    (
        [hashtable]$Component,
        [string]$solutionName,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn
    )

    $total = $component.Entities.Count + $component.Nonentities.Count 
    Write-Verbose ("Adding {0} components to target solution..." -f $total)
    if ($Component.Entities) {
        Add-ComponentToSolution -Component $Component.Entities -SolutionName $solutionName -conn $conn
    }
    
    if ($Component.Nonentities) {
        Add-ComponentToSolution -Component $Component.Nonentities -SolutionName $solutionName -conn $conn
    }
    Write-Verbose 'Done adding components...'
}