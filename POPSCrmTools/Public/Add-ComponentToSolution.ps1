Function Add-ComponentToSolution {
    [cmdletbinding()]
    Param
    (
        [SolutionComponent[]]$Component,
        [String]$SolutionName,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$conn
    )

    foreach ($component in $Component) {
        $request = [Microsoft.Crm.Sdk.Messages.AddSolutionComponentRequest]::new()
        $request.ComponentId = $component.ObjectId
        $request.ComponentType = $component.ComponentType
        $request.SolutionUniqueName = $SolutionName

        if ($request.ComponentType -eq 1) {
            Switch ($component.rootcomponentbehavior) {
                "1" { 
                    $request.DoNotIncludeSubcomponents = $true; 
                    $request.IncludedComponentSettingsValues = $null
                }
                "2" { 
                    $request.DoNotIncludeSubcomponents = $true; 
                    $request.IncludedComponentSettingsValues = @()
                }
                Default { 
                    $err = $("Invalid behavior value {0} identified for component {1}" -f $component.rootcomponentbehavior, $component.ObjectId);
                    Write-Error -Message $err
                    $err | Out-File -Append 'log\errorlog.txt'
                }
            }
        }
        
        try {
            Write-Verbose ("Adding {0} " -f $request.ComponentId)
            $conn.Execute($request) | Out-Null
        }
        catch [Microsoft.PowerShell.Commands.WriteErrorException], [System.Management.Automation.MethodInvocationException] {
            $err = $_.Exception.Message
            if (($err -match 'does not exist') -or
                ($err -match 'cannot be added')) {
                    $err | Out-File -Append 'errorlog.txt'
            }
            else {
                $err | Out-File -Append 'errorlog.txt'
                throw $err
            }
        }
        catch {
            $err = $_.Exception.Message
            $err | Out-File -Append 'errorlog.txt'
            Throw $err
        }
    }
}