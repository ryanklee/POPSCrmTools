
Filter RetrieveFetchResults
{
	begin { $results = @(); }
	process { 
        $results = (Get-CrmRecordsByFetch -Fetch ($_) -AllRows).CrmRecords;
    }
	end { return $results; }
}