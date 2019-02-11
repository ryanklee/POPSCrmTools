---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Test-CrmSolutionExists

## SYNOPSIS
Tests whether a solution exists on a Dynamics Crm Org.

## SYNTAX

```
Test-CrmSolutionExists [[-Conn] <CrmServiceClient>] [[-SolutionName] <String>] [<CommonParameters>]
```

## PARAMETERS

### -Conn
Dynamics 365 Crm Connection

```yaml
Type: CrmServiceClient
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SolutionName
Unique Name of Solution

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## OUTPUTS

### 'True' if the solution exists; 'False' if the solution does not exist.