Filter MetadataToHash
{
	begin { $hash = @{} }
	process { 
        $hash[$_.Metadataid] = $_ 
    }
	end { return $hash }
}