Function Test-AttributeOfInvalidEntity {
    Param
    (
        [parameter(Position = 0)]
        [guid]$ObjectId,
        [parameter(Position = 1)]
        [solutioncomponent[]]$component,
        [parameter(Position = 2)]
        [array]$Metadata
    )

    
    foreach ($component in $component){
        $attributes = $Metadata | Where-Object -Property Metadataid -eq $component.ObjectId | Select-Object -Property Attributes
        $attributeIds = $attributes.Attributes | Select-Object -Property Metadataid
        if ($attributeIds -match $ObjectId){
            $attributeOfInvalid = $true
        }
    }

    if ($attributeOfInvalid){
        Write-Output $true
    }
}