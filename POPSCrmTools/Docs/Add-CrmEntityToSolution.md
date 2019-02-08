---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Add-CrmEntityToSolution

## SYNOPSIS
Adds an Entity to a Dynamics Crm Solution.

## SYNTAX

```
Add-CrmEntityToSolution [[-Conn] <CrmServiceClient>] [[-EntityName] <String>] [[-SolutionName] <String>]
 [-IncludeMetadata] [<CommonParameters>]
```

## PARAMETERS

### -Conn
Dynamics Crm connection.

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

### -EntityName
LogicalName of Entity

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

### -SolutionName
UniqueName of Solution

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeMetadata
Include Entity Metadata.
Default is false.
SubComponents to include 
\[ValidateSet("None","All","Custom")\]
\[String\]$IncludeSubComponentSet = "None"

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).