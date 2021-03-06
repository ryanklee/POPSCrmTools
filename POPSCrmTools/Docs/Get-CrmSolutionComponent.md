---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Get-CrmSolutionComponent

## SYNOPSIS
Gets all SolutionComponents in a Solution on a Dynamics crm org

## SYNTAX

```
Get-CrmSolutionComponent [[-conn] <CrmServiceClient>] [[-solutionName] <String>] [<CommonParameters>]
```

## PARAMETERS

### -conn
Dynamics crm connection

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

### -solutionName
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).