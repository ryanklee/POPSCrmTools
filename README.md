# POPSCrmTools

A PowerShell module to help with build tasks and pipeline automation for Microsoft Dynamics 365 crm.

See New-CrmSolutionFromSource for an example controlling function that utilizes many of these module cmdlets.

### Installing

Clone repository. From PowerShell commandline in base git directory:

```
Import-Module .\POPSCrmTools
```

To see a list of commands

```
Get-Command -Module POPSCrmTools
```



### Available Commands
- [**Add-ComponentToSolution**](POPSCrmTools/Docs/Add-ComponentToSolution.md)
- [**Add-CrmEntityToSolution**](POPSCrmTools/Docs/Add-CrmEntityToSolution.md)
- [**Get-CrmSolutionComponent**](POPSCrmTools/Docs/Get-CrmSolutionComponent.md)
- [**Compare-CrmSolutionComponent**](POPSCrmTools/Docs/Compare-CrmSolutionComponent.md)
- [**New-CrmPublisher**](POPSCrmTools/Docs/New-CrmPublisher.md)
- [**New-CrmSolution**](POPSCrmTools/Docs/New-CrmSolution.md)
- [**New-CrmSolutionFromSource**](POPSCrmTools/Docs/New-CrmSolutionFromSource.md)
- [**New-CrmSolutionFromSourceConfig**](POPSCrmTools/Docs/New-CrmSolutionFromSourceConfig.md)
- [**Remove-CrmComponentFromSolution**](POPSCrmTools/Docs/Remove-CrmComponentFromSolution.md)
- [**Remove-CrmEntityFromSolution**](POPSCrmTools/Docs/Remove-CrmEntityFromSolution.md)
- [**Remove-SolutionComponentFromCrm**](POPSCrmTools/Docs/Remove-SolutionComponentFromCrm.md)
- [**Set-CrmSolutionComponent**](POPSCrmTools/Docs/Set-CrmSolutionComponent.md)
- [**Test-CrmSolutionComponentExists**](POPSCrmTools/Docs/Test-CrmSolutionComponentExists.md)
- [**Test-CrmSolutionExists**](POPSCrmTools/Docs/Test-CrmSolutionExists.md)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details