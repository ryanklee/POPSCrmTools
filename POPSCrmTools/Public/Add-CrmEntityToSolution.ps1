Function Add-CrmEntityToSolution {
    <#
        .SYNOPSIS
            Adds an Entity to a Dynamics Crm Solution.
    #>
    [cmdletbinding()]
    Param
    (
        # Dynamics Crm connection.
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient] $Conn,
        # LogicalName of Entity
        [Parameter(Mandatory = $true)]
        [String]$EntityName,
        # UniqueName of Solution
        [Parameter(Mandatory = $true)]
        [String]$SolutionName,
        # Include Entity Metadata. Default is false.
        [Parameter(Mandatory = $true)]
        [Switch]$IncludeMetadata = $false,
        # SubComponents to include 
        [Parameter(Mandatory = $false)]
        [ValidateSet("None","All","Custom")]
        [String]$IncludeSubComponentSet = "None",
        # Metadata for entity. Can be supplied in case of cache conflicts.
        [Parameter(Mandatory = $false)]
		[System.Array]$EntityMetadata = @()
    )

	# If this is called in a loop, provide ConnMetadata from parent function. There is a bug in how the Metadata is stored globally which will cause threading data issues.
	if (-not $EntityMetadata.Length) {
		Write-Verbose ("Refreshing metadata cache...");
		Get-CrmEntityAllMetadata -conn $Conn | Out-Null;
		$EntityMetadata = (Get-CrmEntityMetadata -EntityLogicalName $EntityName -conn $Conn -EntityFilters Attributes);
	}
	
    $ObjectTypeCode = $EntityMetadata.ObjectTypeCode;
    $EntityMetadataId = $EntityMetadata.MetadataId;
    Write-Verbose ("Retrieved MetadataId {0} for EntityName {1} with ObjectTypeCode {2}" -f $EntityMetadataId, $EntityName, $ObjectTypeCode);

    if ($IncludeMetadata) { 
        $rootcomponentbehavior = 1; 
    } else { 
        $rootcomponentbehavior = 2; 
    }
    
    Add-CrmComponentToSolution -Conn $Conn -SolutionName $SolutionName `
        -Component @{'objectid' = $EntityMetadataId; 'componenttype' = 1; 'rootcomponentbehavior' = $rootcomponentbehavior; };
    
    if ($IncludeSubComponentSet -eq "None") {
        Write-Output ($EntityMetadataId);
        return;
    }
    
	Write-Verbose ("Generating fetches for components using ObjectTypeCode {0}" -f $ObjectTypeCode);
    if ($IncludeSubComponentSet -eq "All") {
        $Attributes = $EntityMetadata.Attributes | Select-Object MetadataId,LogicalName,IsCustomAttribute;
        $DisplayStrings = ("<fetch><entity name='displaystringmap' ><attribute name='displaystringid' /><filter type='and' ><condition attribute='objecttypecode' operator='eq' value='{0}' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        $Views = ("<fetch><entity name='savedquery' ><attribute name='savedqueryid' /><attribute name='iscustom' /><attribute name='name' /><filter type='and' ><condition attribute='returnedtypecode' operator='eq' value='{0}' /><condition attribute='isprivate' operator='neq' value='1' /><condition attribute='statecode' operator='eq' value='0' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        $Charts = ("<fetch><entity name='savedqueryvisualization' ><attribute name='name' /><attribute name='savedqueryvisualizationidunique' /><filter type='and' ><condition attribute='primaryentitytypecode' operator='eq' value='{0}' /><condition attribute='iscustomizable' operator='eq' value='1' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        $Forms = ("<fetch><entity name='systemform' ><attribute name='name' /><attribute name='formid' /><filter type='and' ><condition attribute='objecttypecode' operator='eq' value='{0}' /><condition attribute='formactivationstate' operator='eq' value='1' /><condition attribute='iscustomizable' operator='eq' value='1' /></filter></entity></fetch>" -f $ObjectTypeCode) | RetrieveFetchResults;
        # TBD Relationships RetrieveRelationshipRequest
        # TBD Alternate Keys RetrieveEntityKeyRequest
        # TBD Dashboards (Interactive / Legacy)
    }

    # TBD Views and Forms are not working.
    if ($IncludeSubComponentSet -eq "Custom") {
        $Attributes = $EntityMetadata.Attributes | Select-Object MetadataId,LogicalName,IsCustomAttribute,IsPrimaryId | Where-Object { $_.IsCustomAttribute -or $_.IsPrimaryId }; 
        $DisplayStrings = @();
        $ViewFetch = ("<fetch><entity name='savedquery' ><attribute name='savedqueryid' /><attribute name='iscustom' /><attribute name='name' /><filter type='and' ><condition attribute='returnedtypecode' operator='eq' value='{0}' /><condition attribute='isprivate' operator='neq' value='1' /><condition attribute='statecode' operator='eq' value='0' /></filter></entity></fetch>" -f $ObjectTypeCode);
		$Views = @((Get-CrmRecordsByFetch -Fetch ($ViewFetch) -conn $Conn -AllRows).CrmRecords) | Where-Object { $_.iscustom };
        $Charts = @();
		$FormFetch = ("<fetch><entity name='systemform'><attribute name='name'/><attribute name='formid'/><filter type='and'><condition attribute='formactivationstate' operator='eq' value='1'/><condition attribute='iscustomizable' operator='eq' value='1'/><condition attribute='objecttypecode' operator='eq' value='{0}'/><condition attribute='ismanaged' operator='eq' value='0'/></filter></entity></fetch>" -f $ObjectTypeCode);
		Write-Verbose ("Fetch: {0}" -f $FormFetch);
		$Forms = (Get-CrmRecordsByFetch -Fetch ($FormFetch) -conn $Conn -AllRows).CrmRecords;
    }

	Write-Verbose ("Forms Guids = {0}" -f $(@($Forms.formid) -join ", "));
    $Attributes | ForEach-Object { Add-CrmComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.MetadataId; 'componenttype' = 2; }; }
    $DisplayStrings | ForEach-Object { Add-CrmComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.displaystringid; 'componenttype' = 22; }; }
    $Views | ForEach-Object { Add-CrmComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.savedqueryid; 'componenttype' = 26; }; }
    $Charts | ForEach-Object { Add-CrmComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.savedqueryvisualizationid; 'componenttype' = 59; }; }
    $Forms | ForEach-Object { Add-CrmComponentToSolution -Conn $Conn -SolutionName $SolutionName `
                                -Component @{'objectid' = $_.formid; 'componenttype' = 60; }; }
}

