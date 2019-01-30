Function Write-ManifestOut{
    Param
    (
        [hashtable]$Manifest
    )

    
    if ($Manifest.Add.Entities) { 
        Write-Verbose ("{0} valid entities to add to solution..." -f $Manifest.Add.Entities.Count) 
    } else {
        Write-Verbose ("No entities to add...")
    }
    
    if ($Manifest.Add.Nonentities) {
        Write-Verbose ("{0} valid Nonentities to add to solution..." -f $Manifest.Add.Nonentities.Count)
    } else {
        Write-Verbose ("No nonentities to add...")
    }

    if ($Manifest.Skip.Entities) {
        Write-Verbose ("{0} invalid entities..." -f $Manifest.Skip.Entities.Count)
    } 

    if ($Manifest.Skip.Nonentities) {
        Write-Verbose ("{0} invalid nonentities..." -f $Manifest.Skip.Nonentities.Count) 
    }
}