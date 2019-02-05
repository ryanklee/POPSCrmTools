Function Get-ComponentAttributeId {
    Param
    (
        [SolutionComponent[]]$Component,
        [hashtable]$Metadata
    )

    $ids = $Component | Select-Object -ExpandProperty ObjectId
    $attributeIds = $()
    
    foreach ($id in $ids){
        [guid[]]$attributeIds = $Metadata[$id].Attributes | 
            Select-Object -ExpandProperty Metadataid
        [guid[]]$attributeIds += $attributeIds
    }

    Write-Output $attributeIds
}