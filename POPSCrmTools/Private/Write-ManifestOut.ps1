Function Write-ManifestOut{
    Param
    (
        [hashtable]$Manifest
    )

    
    if ($Manifest.Add.Entities) { 
        Write-Verbose ("{0} valid entities to be added..." -f $Manifest.Add.Entities.Count) 
    } else {
        Write-Verbose ("No entities to be added...")
    }
    
    if ($Manifest.Add.Nonentities) {
        Write-Verbose ("{0} valid Nonentities to be added..." -f $Manifest.Add.Nonentities.Count)
    } else {
        Write-Verbose ("No nonentities to be added...")
    }

    if ($Manifest.Skip.Entities) {
        Write-Verbose ("{0} invalid entities..." -f $Manifest.Skip.Entities.Count)
    } 

    if ($Manifest.Skip.Nonentities) {
        Write-Verbose ("{0} invalid nonentities..." -f $Manifest.Skip.Nonentities.Count) 
    }

    <# if ($Manifest.Removals) {
        Write-Verbose ("{0} components to be removed..." -f $Manifest.Removals.Count) 
    } #>
}