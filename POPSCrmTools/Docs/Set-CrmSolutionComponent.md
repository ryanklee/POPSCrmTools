---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Set-CrmSolutionComponent

## SYNOPSIS
Builds a SolutionComponent object from a single fetch record entry.

## SYNTAX

```
Set-CrmSolutionComponent [[-Record] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
Builds an object of type SolutionComponent.
All properties of the object are set according to
the provided fetchxml entry.
The fetch result should contain all SolutionComponent attributes.

## PARAMETERS

### -Record
Single record entry from fetch for SolutionComponent.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## OUTPUTS

### Object of type SolutionComponent.
