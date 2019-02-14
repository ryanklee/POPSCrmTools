---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Remove-CrmComponentFromSolution

## SYNOPSIS
Removes SolutionComponent(s) from Dynamics crm solution.

## SYNTAX

```
Remove-CrmComponentFromSolution [[-SolutionName] <String>] [[-Component] <Array>] [[-conn] <CrmServiceClient>]
 [<CommonParameters>]
```

## PARAMETERS

### -SolutionName
UniqueName of Solution containing SolutionComponent(s) to delete.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Component
SolutionComponent(s) to delete.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -conn
Dynamics crm connection.

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