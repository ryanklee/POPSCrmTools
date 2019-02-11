---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Test-CrmSolutionComponentExists

## SYNOPSIS
Tests whether a SolutionComponent exists in any solution on a Dynamics Crm Org.
Includes default solution.

## SYNTAX

```
Test-CrmSolutionComponentExists [[-ObjectId] <Guid>] [[-conn] <CrmServiceClient>] [<CommonParameters>]
```

## PARAMETERS

### -ObjectId
ObjectId of SolutionComponent

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -conn
Dynamics 365 Crm Connection

```yaml
Type: CrmServiceClient
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

### 'True' if the SolutionComponent exists. 'False' if the SolutionComponent does not exist.