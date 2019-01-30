Function Add-EntityToSolution {
    [cmdletbinding()]
    Param
    (
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient] $Conn,
        [String]                                           $EntityName,
        [String]                                           $SolutionName,
        [Switch]                                           $IncludeMetadata = $false,
        [ValidateSet("None","All","Custom")][String]       $IncludeSubComponentSet = "None"
    )

    $Metadata = (Get-CrmEntityMetadata -EntityLogicalName $EntityName -conn $Conn -EntityFilters Attributes);
    $ObjectTypeCode = $Metadata.ObjectTypeCode;
    $EntityMetadataId = $Metadata.MetadataId;
    Write-Verbose ("Retrieved MetadataId {0} for EntityName {1}" -f $EntityMetadataId, $EntityName);

    if ($IncludeMetadata) { 
        $rootcomponentbehavior = 1; 
    } else { 
        $rootcomponentbehavior = 2; 
    }
    
    Add-ComponentToSolution -Conn $Conn -SolutionName $SolutionName `
        -Component @{'objectid' = $EntityMetadataId; 'componenttype' = 1; 'rootcomponentbehavior' = $rootcomponentbehavior; };
    
    if ($IncludeSubComponentSet -eq "None") {
        Write-Output ($EntityMetadataId);
        return;
    }
    
    if ($IncludeSubComponentSet -eq "All") {
        $Attributes = $Metadata.Attributes | Select-Object MetadataId,LogicalName,IsCustomAttribute;
        $DisplayStrings = ("<fetch><entity name='displaystringmap' ><attribute name='displaystringid' /><filter type='and' ><condition attribute='objecttypecode' operator='eq' value='{0}' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        $Views = ("<fetch><entity name='savedquery' ><attribute name='savedqueryid' /><attribute name='iscustom' /><attribute name='name' /><filter type='and' ><condition attribute='returnedtypecode' operator='eq' value='{0}' /><condition attribute='isprivate' operator='neq' value='1' /><condition attribute='statecode' operator='eq' value='0' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        $Charts = ("<fetch><entity name='savedqueryvisualization' ><attribute name='name' /><attribute name='savedqueryvisualizationidunique' /><filter type='and' ><condition attribute='primaryentitytypecode' operator='eq' value='{0}' /><condition attribute='iscustomizable' operator='eq' value='1' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        $Forms = ("<fetch><entity name='systemform' ><attribute name='name' /><attribute name='formidunique' /><filter type='and' ><condition attribute='canbedeleted' operator='eq' value='1' /><condition attribute='objecttypecode' operator='eq' value='{0}' /><condition attribute='formactivationstate' operator='eq' value='1' /><condition attribute='iscustomizable' operator='eq' value='1' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        # TBD Relationships RetrieveRelationshipRequest
        # TBD Alternate Keys RetrieveEntityKeyRequest
        # TBD Dashboards (Interactive / Legacy)
    }

    # TBD Views and Forms are not working.
    if ($IncludeSubComponentSet -eq "Custom") {
        $Attributes = $Metadata.Attributes | Select-Object MetadataId,LogicalName,IsCustomAttribute | Where-Object { $_.IsCustomAttribute }; 
        $DisplayStrings = @();
        $Views = ("<fetch><entity name='savedquery' ><attribute name='savedqueryid' /><attribute name='iscustom' /><attribute name='name' /><filter type='and' ><condition attribute='returnedtypecode' operator='eq' value='{0}' /><condition attribute='isprivate' operator='neq' value='1' /><condition attribute='statecode' operator='eq' value='0' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults | Where-Object { $_.iscustom };
        $Charts = @();
        $Forms = ("<fetch><entity name='systemform' ><attribute name='name' /><attribute name='formid' /><filter type='and' ><condition attribute='canbedeleted' operator='eq' value='1' /><condition attribute='objecttypecode' operator='eq' value='{0}' /><condition attribute='formactivationstate' operator='eq' value='1' /><condition attribute='iscustomizable' operator='eq' value='1' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
    }

    $Attributes | ForEach-Object { Add-ComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.MetadataId; 'componenttype' = 2; }; }
    $DisplayStrings | ForEach-Object { Add-ComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.displaystringid; 'componenttype' = 22; }; }
    $Views | ForEach-Object { Add-ComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.savedqueryid; 'componenttype' = 26; }; }
    $Charts | ForEach-Object { Add-ComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.savedqueryvisualizationid; 'componenttype' = 59; }; }
    $Forms | ForEach-Object { Add-ComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.formid; 'componenttype' = 60; }; }
}

