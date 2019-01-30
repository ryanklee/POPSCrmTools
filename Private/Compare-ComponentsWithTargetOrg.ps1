Function Compare-ComponentsWithTargetOrg {
    Param
    (
        [SolutionComponent[]]$Components,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    Write-Verbose 'Getting source crm metadata...'
    $metadata = Get-CrmEntityAllMetadata -conn $sourceConn -EntityFilters Attributes | MetadataToHash
    $entities = $Component | Where-Object -Property ComponentType -EQ 1
    $nonentities = $Component | Where-Object -Property ComponentType -NE 1

    Write-Verbose "Identifying valid entities..."
    $validEntities = $entities | 
        Where-Object -Filter {($_.rootcomponentbehavior -ne 0)} |
        Where-Object -Filter {(Test-CrmComponentExists $_.objectid $conn)}
        

    Write-Verbose "Identifying invalid entities..."
    if ($validEntities) {
        $invalidEntities = Compare-Object $validEntities $entities |
        Where-Object SideIndicator -eq '=>' |
        ForEach-Object InputObject   
    } else {
        $invalidEntities = $entities
    }

    $invalidEntitiesIds = $invalidEntities | Select-Object -ExpandProperty ObjectId
    $invalidAttributeIds = $()
    
    foreach ($id in $invalidEntitiesIds){
        [guid[]]$attributeIds = $Metadata[$id].Attributes | 
            Select-Object -ExpandProperty Metadataid
        [guid[]]$invalidAttributeIds += $attributeIds
    }

    Write-Verbose "Identifying valid Nonentities..."
    $validNonentitiesGoodIds = $nonentities | 
        Where-Object -Filter {($invalidAttributeIds -notcontains $_.ObjectId)} 
    
    $validNonentities = $validNonentitiesGoodIds |
        Where-Object -Filter {(Test-CrmComponentExists $_.ObjectId $conn)}

    Write-Verbose "Identifying invalid Nonentities..."
    if($validNonentities){
        $invalidNonentities = Compare-Object $validNonentities $nonentities |
        Where-Object SideIndicator -eq '=>' |
        ForEach-Object InputObject   
    } else {
        $invalidNonentities = $nonentities
    }

    $manifest = @{}
    $add = @{}
    $skip = @{}
    
    [SolutionComponent[]]$add["Entities"] = $validEntities  
    [SolutionComponent[]]$add["Nonentities"] = $validNonentities
    [SolutionComponent[]]$skip["Entities"] = $invalidEntities
    [SolutionComponent[]]$skip["Nonentities"] = $invalidNonentities   
    
    $manifest["Add"] = $add
    $manifest["Skip"] = $skip
    
    Write-Output $manifest
}

