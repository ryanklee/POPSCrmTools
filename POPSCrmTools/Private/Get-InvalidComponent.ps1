Function Get-InvalidComponent {
    Param
    (
        [SolutionComponent[]]$AllComponent,
        [SolutionComponent[]]$ValidComponent
    )

    Write-Verbose "Identifying invalid entities..."
    if ($ValidComponent) {
        $invalid = Compare-Object $ValidComponent $AllComponent |
            Where-Object SideIndicator -eq '=>' |
            ForEach-Object InputObject
        Write-Output $invalid
    } else {
       Write-Output $AllComponent
    }
}