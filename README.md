# POPSCrmTools

PowerObjects PowerShell Crm Tools is a PowerShell module for build and pipeline automation of Microsoft Dynamics 365 crm.

See the Sync-CrmSolutionFromSource cmdlet for an example controlling function that utilizes many of the module's cmdlets.

### Installing

#### To install from PSGallery

```
Install-Module POPSCrmTools -Force -Scope CurrentUser
```

#### To install from repository

From base git directory:

```
Import-Module .\POPSCrmTools
```

To see a list of commands

```
Get-Command -Module POPSCrmTools
```

### Available Commands
- [**Add-CrmComponentToSolution**](POPSCrmTools/Docs/Add-CrmComponentToSolution.md)
- [**Add-CrmEntityToSolution**](POPSCrmTools/Docs/Add-CrmEntityToSolution.md)
- [**Compare-CrmSolutionComponent**](POPSCrmTools/Docs/Compare-CrmSolutionComponent.md)
- [**Get-CrmSolutionComponent**](POPSCrmTools/Docs/Get-CrmSolutionComponent.md)
- [**New-CrmPublisher**](POPSCrmTools/Docs/New-CrmPublisher.md)
- [**New-CrmSolution**](POPSCrmTools/Docs/New-CrmSolution.md)
- [**Remove-CrmComponentFromSolution**](POPSCrmTools/Docs/Remove-CrmComponentFromSolution.md)
- [**Remove-CrmEntityFromSolution**](POPSCrmTools/Docs/Remove-CrmEntityFromSolution.md)
- [**Remove-SolutionComponentFromCrm**](POPSCrmTools/Docs/Remove-SolutionComponentFromCrm.md)
- [**Set-CrmSolutionComponent**](POPSCrmTools/Docs/Set-CrmSolutionComponent.md)
- [**Sync-CrmSolutionFromSource**](POPSCrmTools/Docs/Sync-CrmSolutionFromSource.md)
- [**Sync-CrmSolutionFromSourceConfig**](POPSCrmTools/Docs/Sync-CrmSolutionFromSourceConfig.md)
- [**Test-CrmSolutionComponentExists**](POPSCrmTools/Docs/Test-CrmSolutionComponentExists.md)
- [**Test-CrmSolutionExists**](POPSCrmTools/Docs/Test-CrmSolutionExists.md)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details