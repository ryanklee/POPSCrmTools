Filter RetrieveFetchResults
{
	param
	(
		[Object] $Conn
	)
	begin { $results = @(); }
	process { 
        $results = (Get-CrmRecordsByFetch -Fetch ($_) -conn $Conn -AllRows).CrmRecords;
    }
	end { return $results; }
}