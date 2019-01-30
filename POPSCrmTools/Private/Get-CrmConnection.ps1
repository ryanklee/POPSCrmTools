Function Get-CrmConnection {
    Param 
    ( 
        [Parameter(ParameterSetName='Cred', Mandatory=$true)]
        [pscredential]$Credential,
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [string]$UserName,
        [Parameter(ParameterSetName='DiscreteCreds', Mandatory=$true)]
        [securestring]$Password,
        [string]$url
    )

    try {
        
        if ($PSBoundParameters.ContainsKey('Password')){
            $O365Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
            $conn = Connect-CRMOnline -Credential $O365Cred -ServerURL $URL;
        } else {
            Write-Verbose "Connecting to $url..."
            $conn = Connect-CrmOnline -Credential $Credential -ServerUrl $url -ErrorAction Stop -WarningAction SilentlyContinue
        }
    }
    catch {
        $err = $_.Exception.Message
        Write-Error "Connection to $url failed..."
        throw $err
    }
    finally {
        if (-Not $conn.IsReady) {
            throw "Connection to $url failed..."
        }
    }
    Write-Verbose "Connected to $url..."
    Write-Output $conn
}