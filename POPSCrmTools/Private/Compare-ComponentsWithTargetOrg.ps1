Function Compare-ComponentsWithTargetOrg {
    Param
    (
        [SolutionComponent[]]$Component,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )

    Write-Verbose 'Getting source crm metadata...'
    $metadata = Get-CrmEntityAllMetadata -conn $sourceConn -EntityFilters Attributes | MetadataToHash

    $entities = @{}
    $nonentities = @{}
    
    [SolutionComponent[]]$entities["All"] = $Component | Where-Object -Property ComponentType -EQ 1
    [SolutionComponent[]]$nonentities["All"] = $Component | Where-Object -Property ComponentType -NE 1
    $entities["Exist"] = Get-ComponentSortedOnExistence -Component $entities.All -Conn $conn
    [SolutionComponent[]]$entities["Valid"] = Get-ValidEntityComponent -AllEntityComponent $entities.All -ExistingComponent $entities.Exist.True  
    [SolutionComponent[]]$entities["Invalid"] = Get-InvalidComponent -AllEntityComponent $entities.All -ValidComponent $entites.Valid

    [guid[]]$invalidAttributeIds = Get-ComponentAttributeId -Component $entities.Invalid -Metadata $metadata 

    Write-Verbose "Identifying valid Nonentities..."
    $validNonentitiesGoodIds = $nonentities.All | 
        Where-Object -Filter {($invalidAttributeIds -notcontains $_.ObjectId)} 
    
    $validNonentities = $validNonentitiesGoodIds |
        Where-Object -Filter {(Test-CrmComponentExists $_.ObjectId $conn)}

    Write-Verbose "Identifying invalid Nonentities..."
    if($validNonentities){
        $invalidNonentities = Compare-Object $validNonentities $nonentities.All |
        Where-Object SideIndicator -eq '=>' |
        ForEach-Object InputObject   
    } else {
        $invalidNonentities = $nonentities.All
    }

    $manifest = @{}
    $add = @{}
    $skip = @{}
    
    [SolutionComponent[]]$add["Entities"] = $entities.Valid 
    [SolutionComponent[]]$add["Nonentities"] = $validNonentities
    [SolutionComponent[]]$skip["Entities"] = $entities.Invalid
    [SolutionComponent[]]$skip["Nonentities"] = $invalidNonentities
    
    $manifest["Add"] = $add
    $manifest["Skip"] = $skip
    
    Write-Output $manifest
}

