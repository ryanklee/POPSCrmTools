---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Add-ComponentToSolution

## SYNOPSIS
Adds SolutionComponent(s) to a Dynamics Crm Solution

## SYNTAX

```
Add-ComponentToSolution [[-Component] <SolutionComponent[]>] [[-SolutionName] <String>]
 [[-conn] <CrmServiceClient>] [<CommonParameters>]
```

## DESCRIPTION
Adds SolutionComponent(s) to Dynamics Crm Solution.
Only supports SolutionComponents with rootcomponentbehavior of 1 or 2.

## PARAMETERS

### -Component
SolutionComponent(s) to be added to the Solution

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

### -SolutionName
UniqueName of Solution

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -conn
Dynamics crm connection

```yaml
Type: CrmServiceClient
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).