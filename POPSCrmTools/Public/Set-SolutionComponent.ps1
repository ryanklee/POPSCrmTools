Function Set-SolutionComponent {
    [cmdletbinding()]
    Param
    (
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