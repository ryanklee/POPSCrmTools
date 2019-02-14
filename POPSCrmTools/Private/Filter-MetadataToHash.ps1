Filter RetrieveFetchResults
{
	param
	(
		[Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
	)

	begin { $results = @(); }
	process { 
        $results = (Get-CrmRecordsByFetch -Fetch ($_) -conn $Conn -AllRows).CrmRecords;
    }
	end { return $results; }
}