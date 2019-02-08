---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Get-CrmSolutionComponentComparison

## SYNOPSIS
# Gets a list of components unique to ReferenceComponent.

## SYNTAX

```
Get-CrmSolutionComponentComparison [[-ReferenceComponent] <SolutionComponent[]>]
 [[-DifferenceComponent] <SolutionComponent[]>] [<CommonParameters>]
```

## DESCRIPTION
# Gets a list of components unique to ReferenceComponent.
Compares only on the ObjectId and RootComponentBehavior
# properties.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ReferenceComponent
Equivalent to Compare-Object ReferenceObject

```yaml
Type: SolutionComponent[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceComponent
Equivalent to Compare-Object DifferenceObject

```yaml
Type: SolutionComponent[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### # Array of containing objects of type SolutionComponent. Objects include SideIndicator properties from 
### # being processed by Compare-Object
## NOTES

## RELATED LINKS
