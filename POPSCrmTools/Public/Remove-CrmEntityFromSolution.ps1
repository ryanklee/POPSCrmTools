Function Remove-CrmEntityFromSolution {
    <#
        .SYNOPSIS
            Deletes Entity from a Dynamics crm solution.
    #>
    [cmdletbinding()]
    Param
    (
        # Dynamics crm connection
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn,
        # LogicalName of Entity to remove
        [String]$EntityName,
        # Name of solution that contains entity to delete
        [String]$SolutionName
    )

    $EntityMetadataId = Get-CrmEntityMetadata -Conn $Conn -EntityLogicalName $EntityName -EntityFilters None | Select-Object -ExpandProperty MetadataId;
    Write-Verbose ("Retrieved MetadataId {0} for EntityName {1}" -f $EntityMetadataId, $EntityName);
    
    Remove-CrmComponentFromSolution -Conn $Conn -SolutionName $SolutionName -Component @{'objectid' = $EntityMetadataId; 'componenttype' = 1};
    
    Write-Output ($EntityMetadataId);
}