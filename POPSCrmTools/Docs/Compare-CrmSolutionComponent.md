---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Compare-CrmSolutionComponent

## SYNOPSIS
# Gets a list of components unique to ReferenceComponent.

## SYNTAX

```
Compare-CrmSolutionComponent [[-ReferenceComponent] <SolutionComponent[]>]
 [[-DifferenceComponent] <SolutionComponent[]>] [<CommonParameters>]
```

## DESCRIPTION
# Gets a list of components unique to ReferenceComponent.
# Compares only on the ObjectId and RootComponentBehavior properties.

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

## OUTPUTS

### - Array containing objects of type SolutionComponent. (Array Objects also include SideIndicator property added by Compare-Object.)
