Function Get-CrmSolutionComponentComparison {
    <#
        .SYNOPSIS
        # Gets a list of components unique to ReferenceComponent.

        .DESCRIPTION
        # Gets a list of components unique to ReferenceComponent. Compares only on the ObjectId and RootComponentBehavior
        # properties.

        .OUTPUTS
        # Array of containing objects of type SolutionComponent. Objects include SideIndicator properties from 
        # being processed by Compare-Object
    #>
    [cmdletbinding()]
    Param
    (
        [SolutionComponent[]]$ReferenceComponent,
        [SolutionComponent[]]$DifferenceComponent
    )

    $relativeComplement = Compare-Object $ReferenceComponent $DifferenceComponent -Property ObjectId, RootComponentBehavior -PassThru | 
        Where-Object SideIndicator -eq '<='
        
    Write-Output $relativeComplement    
}