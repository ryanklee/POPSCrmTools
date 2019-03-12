Function Compare-ComponentsWithTargetOrg {
    Param
    (
        [SolutionComponent[]]$Component,
        [hashtable]$metadata,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$SourceConn,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$TargetConn
    )

    $entities = @{}
    $nonentities = @{}
    
    [SolutionComponent[]]$entities["All"] = $Component | Where-Object -Property ComponentType -EQ 1
    [SolutionComponent[]]$nonentities["All"] = $Component | Where-Object -Property ComponentType -NE 1

    $entities["Exist"] = Get-ComponentSortedByExistence -Component $entities.All -Conn $TargetConn

    [SolutionComponent[]]$entities["Valid"] = Get-ValidEntityComponent -AllEntityComponent $($entities.All) -ExistingComponent $($entities.Exist.True)  
    [SolutionComponent[]]$entities["Invalid"] = Get-InvalidComponent -AllEntityComponent $($entities.All) -ValidComponent $($entites.Valid)

    [guid[]]$invalidAttributeIds = Get-ComponentAttributeId -Component $($entities.Invalid) -Metadata $metadata.Source 

    Write-Verbose "Identifying valid Nonentities..."
    $validNonentitiesGoodIds = $nonentities.All | 
        Where-Object -Filter {($invalidAttributeIds -notcontains $_.ObjectId)} 
    
    $validNonentities = @()
    foreach ($nonEntity in $validNonentitiesGoodIds){
        $exists = Test-CrmSolutionComponentExists -SolutionComponent $nonEntity -Conn $TargetConn
        if ($exists){
            $validNonentities += $nonEntity
        }
    }

    Write-Verbose "Identifying invalid Nonentities..."
    if($validNonentities){
        $invalidNonentities = Compare-Object $validNonentities $nonentities.All -Property ObjectId.Guid -PassThru |
        Where-Object SideIndicator -eq '=>' 
    } else {
        $invalidNonentities = $nonentities.All
    }

    $manifest = @{}
    $add = @{}
    $skip = @{}
    $all = @{}
    
    [SolutionComponent[]]$all["Entities"] = $entities.All
    [SolutionComponent[]]$all["Nonentities"] = $nonentities.All

    [SolutionComponent[]]$add["Entities"] = $entities.Valid
    [SolutionComponent[]]$add["Nonentities"] = $validNonentities

    [SolutionComponent[]]$skip["Entities"] = $entities.Invalid
    [SolutionComponent[]]$skip["Nonentities"] = $invalidNonentities
    
    $manifest["Add"] = $add
    $manifest["Skip"] = $skip
    $manifest["All"] = $all
    
    Write-Output $manifest
}

