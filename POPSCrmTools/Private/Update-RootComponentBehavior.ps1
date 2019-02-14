Function Update-RootComponentBehavior {
    Param
    (
        [SolutionComponent[]]$Component,
        [string]$SolutionName,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )
    Write-Verbose "Updating RootComponentBehaviors to not include all subcomponents..."
    $entities = $Component | Where-Object -Property ComponentType -EQ 1
    $badRootComponents = $entities | Where-Object -Property rootcomponentbehavior -EQ 0 
    $updatedRootComponents = @()
    $metadata = Get-CrmEntityAllMetadata -Conn $Conn -EntityFilters Attributes | MetadataToHash

    Foreach ($component in $badRootComponents){
		$entityName = $metadata[$component.ObjectId].LogicalName;
        Write-Verbose ('Updating component behavior for {0}:{1}' -f $component.ObjectId, $entityName);        
        Remove-CrmEntityFromSolution -EntityName $entityName -Conn $conn -SolutionName $SolutionName
        Add-CrmEntityToSolution -EntityName $entityName -EntityMetadata $metadata[$component.ObjectId] -Conn $conn -SolutionName $SolutionName -IncludeSubComponentSet 'Custom'
        $updatedRootComponents += $Component
    }

    Write-Output $updatedRootComponents
}