Function Get-ComponentToSkip {
    Param
    (
        [SolutionComponent[]]$component,
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]$Conn
    )
    $skip = @{}
    
    [SolutionComponent[]]$skip["NotInTargetCrm"] = $component | 
        Where-Object -Filter {-Not (Test-CrmSolutionComponentExists $_ $Conn)}
        
    [SolutionComponent[]]$skip["BadRootComponentBehavior"] = $component | 
        Where-Object -Property ComponentType -EQ 1 | 
        Where-Object -Filter {$_.rootcomponentbehavior -eq 0}
    
    Write-Output $skip
}