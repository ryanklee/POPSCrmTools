Function Update-ComponentAgainstMetadata {
    Param
    (
        [SolutionComponent[]]$SolutionComponent,
        [hashtable]$MetadataSource,
        [hashtable]$MetadataTarget,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$SourceConn,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$TargetConn

    )

    foreach ($component in $SolutionComponent){
        $ObjectId                = $component.ObjectId
        $RootsolutionComponentId = $component.RootsolutionComponentId
        $TypeCode                = $component.ComponentType
        
        # Get correct target Guid for fields
        if ($TypeCode -eq 2){
            $parentObjectId = ($solutioncomponent | 
                Where-Object -Property SolutionComponentId -eq $rootsolutioncomponentid | 
                Select-Object ObjectId).ObjectId

            $entityLogicalName = ($metadataSource[$parentObjectId].Attributes | 
                                    Where-Object -Property MetadataId -eq $ObjectId).EntityLogicalName

            $logicalName = ($metadataSource[$parentObjectId].Attributes | 
                                    Where-Object -Property MetadataId -eq $ObjectId).LogicalName

            $targetMetadataId = ($metadataTarget[$parentObjectId].Attributes | 
                                    Where-Object -Property LogicalName -eq $logicalName).Metadataid

            if ($targetMetadataId){
                $component.OriginalObjectId = $component.ObjectId
                $component.ObjectId = $targetMetadataId
                Write-Verbose ("Set objectid {0} to target metadataid {1} for attr {2} on Entity {3} " -f $ObjectId, $targetMetadataId, $LogicalName, $entityLogicalName)
            }
        }

        # Get correct target GUID for ManyToOneRelationships
        if ($TypeCode -eq 10){
            $parentObjectId = ($solutioncomponent | 
                Where-Object -Property SolutionComponentId -eq $rootsolutioncomponentid | 
                Select-Object ObjectId).ObjectId

            $type = Get-RelationshipType -Metadata $MetadataSource -SolutionComponent $component -EntityObjectId $parentObjectId

            switch ($type) {
                'ManyToOneRelationship' { 
                    $entityLogicalName = ($metadataSource[$parentObjectId].ManyToOneRelationships | 
                        Where-Object -Property MetadataId -eq $ObjectId).EntityLogicalName

                    $ReferencePropertyName = ($metadataSource[$parentObjectId].ManyToOneRelationships | 
                        Where-Object -Property MetadataId -eq $ObjectId).ReferencedEntityNavigationPropertyName

                    $targetMetadataId = ($metadataTarget[$parentObjectId].ManyToOneRelationships | 
                        Where-Object -Property ReferencedEntityNavigationPropertyName -eq $ReferencePropertyName).Metadataid
                }
                'OneToManyRelationship' {
                    $entityLogicalName = ($metadataSource[$parentObjectId].OneToManyRelationships | 
                        Where-Object -Property MetadataId -eq $ObjectId).EntityLogicalName

                    $ReferencePropertyName = ($metadataSource[$parentObjectId].OneToManyRelationships | 
                        Where-Object -Property MetadataId -eq $ObjectId).ReferencedEntityNavigationPropertyName

                    $targetMetadataId = ($metadataTarget[$parentObjectId].OneToManyRelationships | 
                        Where-Object -Property ReferencedEntityNavigationPropertyName -eq $ReferencePropertyName).Metadataid

                }
                'ManyToManyRelationship' {
                    $entityLogicalName = ($metadataSource[$parentObjectId].ManyToManyRelationships | 
                        Where-Object -Property MetadataId -eq $ObjectId).EntityLogicalName

                    $ReferencePropertyName = ($metadataSource[$parentObjectId].ManyToManyRelationships | 
                        Where-Object -Property MetadataId -eq $ObjectId).ReferencedEntityNavigationPropertyName

                    $targetMetadataId = ($metadataTarget[$parentObjectId].ManyToManyRelationships | 
                        Where-Object -Property ReferencedEntityNavigationPropertyName -eq $ReferencePropertyName).Metadataid
                }
                Default {}
            }

            if ($targetMetadataId){
                $component.OriginalObjectId = $component.ObjectId
                $component.ObjectId = $targetMetadataId
                Write-Verbose ("Set objectid {0} to metadataid {1} for relationship {2} on Entity {3} " -f $ObjectId, $targetMetadataId, $ReferencePropertyName, $entityLogicalName)
            }
        }
    

        # Get correct target GUID for OptionSets
        if ($TypeCode -eq 9){ 
            $OptionRequest = [Microsoft.Xrm.Sdk.Messages.RetrieveOptionSetRequest]::new()
            $OptionRequest.MetadataId = $ObjectId
            $OptionResponse = $SourceConn.Execute($OptionRequest)
            $OptionSchemaName = $OptionResponse.OptionSetMetadata.Name
    
            try {
                $TargetOptionMetadata = Get-CrmGlobalOptionSet -Conn $TargetConn -OptionSetName $OptionSchemaName
                $component.OriginalObjectId = $component.ObjectId
                $component.ObjectId = $targetOptionMetadata.MetadataId
                Write-Verbose ("Set objectid {0} to target metadataid {1} for OptionSet {2}" -f $ObjectId, $($targetOptionMetadata.MetadataId), $OptionSchemaName)

            }
            catch {
                $err = $_.Exception.Message
                Write-Verbose $err
            }
        }
    }

    Write-Output $SolutionComponent
}
