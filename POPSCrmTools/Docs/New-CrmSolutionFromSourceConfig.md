---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# New-CrmSolutionFromSourceConfig

## SYNOPSIS
Generates config file for 'New-CrmSolutionFromSource'

## SYNTAX

```
New-CrmSolutionFromSourceConfig [-FileName] <String> [-SourceOrg] <String> [-TargetOrg] <String>
 [-SolutionName] <String> [-FixRootComponentBehavior] <Boolean> [-PubName] <String> [-PubDisplayName] <String>
 [-PubPrefix] <String> [<CommonParameters>]
```

## DESCRIPTION
Generates config file for 'New-CrmSolutionFromSource'.
Assumes
that all publisher info and solution name are the same for source
and target.

## PARAMETERS

### -FileName
FileName for config

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceOrg
Name of the Dynamics Crm org containing source Solution

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetOrg
Name of the Dynamics Crm org to contain target Solution

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SolutionName
UniqueName of source Solution and for target solution

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FixRootComponentBehavior
Change any rootcomponentbehaviors of 0 to 1.
Default is False.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PubName
UniqueName of Publisher

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PubDisplayName
DisplayName of Publisher

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PubPrefix
Prefix for publisher

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## OUTPUTS

### Psd1 config file of name specified in parameter.
