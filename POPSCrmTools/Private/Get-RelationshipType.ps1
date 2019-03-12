Function Get-RelationshipType{
    param
    (
        [hashtable]$Metadata,
        [SolutionComponent]$SolutionComponent,
        [guid]$EntityObjectId
    )

    $ObjectId = $SolutionComponent.ObjectId
    
    $result = ($metadata[$EntityObjectId].OneToManyRelationships | 
                Where-Object -Property MetadataId -eq $ObjectId).ReferencedEntityNavigationPropertyName

    if ($result){
        $type = 'OneToManyRelationship'
    } elseif (-Not $result){
        $result = ($metadata[$EntityObjectId].ManyToOneRelationships | 
                Where-Object -Property MetadataId -eq $ObjectId).ReferencedEntityNavigationPropertyName
        if ($result){
            $type = 'ManyToOneRelationship'
        }
    } elseif (-Not $result){
        $result = ($metadata[$EntityObjectId].ManyToManyRelationships | 
                Where-Object -Property MetadataId -eq $ObjectId).ReferencedEntityNavigationPropertyName
        if ($result){
            $type = 'ManyToManyRelationship'
        }
    } 
    
    Write-Output $type
}