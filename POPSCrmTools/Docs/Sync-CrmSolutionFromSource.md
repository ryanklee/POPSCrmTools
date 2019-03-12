---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# Sync-CrmSolutionFromSource

## SYNOPSIS
Syncs a Solution in a Dynamics Crm org based on a source solution
in another org.

## SYNTAX

### Cred
```
Sync-CrmSolutionFromSource [-Credential <PSCredential>] -ConfigFilePath <String> [-GenerateConfig]
 [<CommonParameters>]
```

### DiscreteCreds
```
Sync-CrmSolutionFromSource -UserName <String> -Password <SecureString> -ConfigFilePath <String>
 [-GenerateConfig] [<CommonParameters>]
```

## DESCRIPTION
Syncs a Solution in a Dynamics Crm org based on a source solution in another org.

Necessary parameters read from config file.

File can be generated using the '-GenerateConfig' switch -- this will prompt you for 
the required parameters -- or via the 'New-CrmSolutionFromSourceConfig' cmdlet.

If Solution does not already exist on target, it will be created. If Publisher does not 
exist on target, it will be created. All publisher info and solution name are assumed to 
be the same on source and target.

WARNING: If the target Solution exists and contains SolutionComponents, any
SolutionComponents not in source Solution will either (a) be removed from
the target Solution if they exist in other Solutions on the target org, or
(b) deleted if they exist in target solution only and nowhere else.

If specified in config, entities with rootcomponentbehaviors of 0 will be
changed to 1. This effectively Syncs the target solution with source solution, cleaning
'rogue' SolutionComponents from the target org.

## PARAMETERS

### -Credential
{{Fill Credential Description}}

```yaml
Type: PSCredential
Parameter Sets: Cred
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
{{Fill UserName Description}}

```yaml
Type: String
Parameter Sets: DiscreteCreds
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
{{Fill Password Description}}

```yaml
Type: SecureString
Parameter Sets: DiscreteCreds
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigFilePath
{{Fill ConfigFilePath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GenerateConfig
{{Fill GenerateConfig Description}}

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

## OUTPUTS

### -Solution on target Dynamics Crm Org.
### -'Errorlog.txt', if errors encountered.
### -'BuildCrmSolutionLog.json', contains useful information about SolutionComponents
###  manipulated by the cmdlet. This includes those Added, Skipped, and comparison results.
