Function Get-CrmSolutionComponentComparison {
    
    Param
    (
        [SolutionComponent[]]$ReferenceComponent,
        [SolutionComponent[]]$DifferenceComponent
    )

    $relativeComplement = Compare-Object $ReferenceComponent $DifferenceComponent -Property ObjectId, RootComponentBehavior -PassThru | 
        Where-Object SideIndicator -eq '<='
        
    Write-Output $relativeComplement    
}