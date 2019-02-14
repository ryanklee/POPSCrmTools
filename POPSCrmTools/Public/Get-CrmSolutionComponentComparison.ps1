Function Get-CrmSolutionComponentComparison {
    <#
        .SYNOPSIS
        # Gets a list of components unique to ReferenceComponent.

        .DESCRIPTION
        # Gets a list of components unique to ReferenceComponent. Compares only on the ObjectId and RootComponentBehavior
        # properties.

        .OUTPUTS
        # Array containing objects of type SolutionComponent. Objects include SideIndicator properties added by Compare-Object
    #>
    [cmdletbinding()]
    Param
    (
        # Equivalent to Compare-Object ReferenceObject
        [SolutionComponent[]]$ReferenceComponent,
        # Equivalent to Compare-Object DifferenceObject
        [SolutionComponent[]]$DifferenceComponent
    )

    $relativeComplement = Compare-Object $ReferenceComponent $DifferenceComponent -Property ObjectId, RootComponentBehavior -PassThru | 
        Where-Object SideIndicator -eq '<='
        
    Write-Output $relativeComplement    
}