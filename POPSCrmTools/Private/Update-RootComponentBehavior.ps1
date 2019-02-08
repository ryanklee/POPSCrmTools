
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
    $metadata = Get-CrmEntityAllMetadata -Conn $Conn | Select-Object -Property MetadataId, LogicalName | MetadataToHash

    Foreach ($component in $badRootComponents){
        Write-Verbose ('Updating component behavior for {0}' -f $component.ObjectId)
        $entityName = $metadata[$component.ObjectId].LogicalName
        Remove-CrmEntityFromSolution -EntityName $entityName -Conn $conn -SolutionName $SolutionName
        Add-CrmEntityToSolution -EntityName $entityName -Conn $conn -SolutionName $SolutionName
        $updatedRootComponents += $Component
    }

    Write-Output $updatedRootComponents
}