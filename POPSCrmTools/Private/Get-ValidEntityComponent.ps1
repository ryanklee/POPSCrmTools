Function Get-ValidEntityComponent {
    Param
    (
        [SolutionComponent[]]$AllEntityComponent,
        [SolutionComponent[]]$ExistingComponent
    )
    Write-Verbose "Identifying valid entities..."
    $validEntities = $AllEntityComponent | 
        Where-Object -Filter {($_.rootcomponentbehavior -ne 0)} |
        Where-Object -Filter {($ExistingComponent | Select-Object -ExpandProperty ObjectId) -contains $_.objectid}

    Write-Output $validEntities
}