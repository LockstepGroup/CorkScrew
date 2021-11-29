Function Invoke-FuriousIp {
    [CmdLetBinding()]
    Param(
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "cidr")]
        [string]$Network,

        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = "cidr")]
        [string]$SubnetMask,

        [Parameter(Mandatory = $false)]
        [int]$Limit = 25,

        [Parameter(Mandatory = $false)]
        [int]$PingDelay = 100,

        [Parameter(Mandatory = $false)]
        [switch]$ReverseLookup,

        [Parameter(Mandatory = $true, ParameterSetName = "list")]
        [string[]]$AddressList
    )
    Begin {
        if ($SubnetMask) {
            $NetworkRange = Resolve-GenericNetworkString -Network $Network -SubnetMask $SubnetMask
        } elseif ($AddressList) {
            $NetworkRange = $AddressList
        } else {
            $NetworkRange = Resolve-GenericNetworkString -Network $Network
        }

        $ScriptBlock = {
            Param (
                $ComputerName,
                $PingDelay,
                $ReverseLookup
            )

            function Invoke-FastPing {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
                    [string]$ComputerName,

                    [Parameter(Mandatory = $false, Position = 1)]
                    [int]$PingDelay = 100,

                    [Parameter(Mandatory = $false, Position = 2)]
                    [switch]$ReverseLookup
                )

                $Ping = New-Object System.Net.NetworkInformation.Ping
                # see http://msdn.microsoft.com/en-us/library/system.net.networkinformation.ipstatus%28v=vs.110%29.aspx
                try {
                    if ($Ping.send($ComputerName, $PingDelay).status -ne "Success") {
                        return $false;
                    } else {
                        return $true;
                    }
                } catch {
                    return $false;
                }
            }

            $ReturnData = "" | Select-Object Name, State, Hostname
            $ReturnData.Name = $ComputerName
            $ReturnData.State = Invoke-FastPing $ComputerName

            if ($ReverseLookup) {
                # reverse resolution
                try {
                    $ReverseLookup = [System.Net.Dns]::GetHostByAddress($ComputerName)
                    if ($ReverseLookup.Hostname) {
                        $ReturnData.Hostname = $ReverseLookup.HostName
                    }
                } catch {
                }
            }

            $ReturnData
        }
    }

    Process {
        $RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Limit)
        $RunspacePool.Open()

        $Jobs = @()

        foreach ($computer in $NetworkRange) {
            $Job = [powershell]::Create().AddScript($ScriptBlock)

            $Job.AddArgument($computer) | Out-Null
            $Job.AddArgument($PingDelay) | Out-Null
            $Job.AddArgument($ReverseLookup) | Out-Null

            $Job.RunspacePool = $RunspacePool

            $ThisJob = "" | Select-Object Pipe, Result
            $ThisJob.Pipe = $Job
            $ThisJob.Result = $Job.BeginInvoke()

            $Jobs += $ThisJob
        }

        Do {
            Start-Sleep -Milliseconds 250
        } While ( $Jobs.Result.IsCompleted -contains $false )

        $Results = @()
        ForEach ($Job in $Jobs ) {
            $Results += $Job.Pipe.EndInvoke($Job.Result)
        }
        $Results
    }
}
