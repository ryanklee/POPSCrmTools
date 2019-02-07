Function Set-SolutionComponent {
    <#
        .SYNOPSIS
            Builds a SolutionComponent object from a single fetch record entry.

        .DESCRIPTION
            Builds an object of type SolutionComponent. All properties of the object are set according to
            the provided fetchxml entry. The fetch result should contain all SolutionComponent attributes. 

        .OUTPUTS
            Object of type SolutionComponent.
        
        .EXAMPLE
            Set-SolutionComponent -Record $crmrecord
    #>
    [cmdletbinding()]
    Param
    (
        #Single record entry from fetch for SolutionComponent.
        [PSCustomObject]$Record
    )

    $component = [SolutionComponent]::New()

    $component.ComponentType = $record.componenttype_Property.Value.Value
    $component.CreatedOn = $record.createdon
    $component.IsMetaData = $record.ismetadata
    $component.ModifiedOn = $record.modifiedon
    $component.ObjectId = $record.objectid
    $component.RootComponentBehavior = $record.rootcomponentbehavior_Property.Value.Value 
    $component.SolutionComponentId = $record.solutioncomponentid
    Write-Output $component
}