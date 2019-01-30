Function Remove-EntityFromSolution {
    [cmdletbinding()]
    Param
    (
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient] $Conn,
        [String]                                           $EntityName,
        [String]                                           $SolutionName
    )

    $EntityMetadataId = Get-CrmEntityMetadata -Conn $Conn -EntityLogicalName $EntityName -EntityFilters None | Select-Object -ExpandProperty MetadataId;
    Write-Verbose ("Retrieved MetadataId {0} for EntityName {1}" -f $EntityMetadataId, $EntityName);
    
    Remove-ComponentFromSolution -Conn $Conn -SolutionName $SolutionName -Component @{'objectid' = $EntityMetadataId; 'componenttype' = 1};
    
    Write-Output ($EntityMetadataId);
}