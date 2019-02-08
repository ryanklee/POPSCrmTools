---
external help file: POPSCrmTools-help.xml
Module Name: POPSCrmTools
online version:
schema: 2.0.0
---

# New-CrmSolutionFromSource

## SYNOPSIS
Builds a Solution in a Dynamics Crm org based on a source solution
in another org.

## SYNTAX

### Cred
```
New-CrmSolutionFromSource [-Credential <PSCredential>] -ConfigFilePath <String> [-GenerateConfig]
 [<CommonParameters>]
```

### DiscreteCreds
```
New-CrmSolutionFromSource -UserName <String> -Password <SecureString> -ConfigFilePath <String>
 [-GenerateConfig] [<CommonParameters>]
```

## DESCRIPTION
Builds a Solution in a Dynamics Crm org based on a source solution
in another org.

Necessary parameters read from config file.
File can be generated
using the '-GenerateConfig' switch -- this will prompt you for 
the required paramaters -- or via the 'New-CrmSolutionFromSourceConfig' cmdlet.

If Solution does not already exist on target, it will be created.
If publisher
does not already exist on target, it will be created.
All publisher info and 
solution name are assumed to be the same on source and target.

WARNING: If the target Solution exists and contains SolutionComponents, any
SolutionComponents not in source Solution will either (a) be removed from
the target Solution if they exist in other Solutions on the target org, or
(b) deleted if they exist in target solution only and nowhere else.

If specified in config, entities with rootcomponentbehaviors of 0 will be
changed to 1.

This effectively Syncs the two solutions, cleaning 'rogue' SolutionComponents from
the target org.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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

## INPUTS

## OUTPUTS

### -Solution on target Dynamics Crm Org.
### -'Errorlog.txt', if errors encountered.
### -'BuildCrmSolutionLog.json', contains useful information about SolutionComponents
###  manipulated by the cmdlet. This includes those Added, Skipped, and comparison results.
## NOTES

## RELATED LINKS
