function Start-CsLogger {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [String]$SyslogServer = $global:SyslogServer,

        [Parameter(Mandatory = $false)]
        [int]$SyslogPort = $global:SyslogPort,

        [Parameter(Mandatory = $false)]
        [int]$DelayMilliseconds = 1000
    )

    BEGIN {
        $VerbosePrefix = "Start-CsLogger:"
    }

    PROCESS {
        if (!($SyslogServer) -and !($SyslogPort)) {
            Throw "SyslogServer and SyslogPort need to be define explicitly or as global variables"
        }
        $Global:CsLoggerSettings = [hashtable]::Synchronized(@{})
        $Global:CsLoggerQueue = [System.Collections.Queue]::Synchronized(@())
        $Global:CsLoggerSettings.Enabled = $True
        $Global:CsLoggerSettings.Host = $host
        $Global:CsLoggerSettings.DelayMilliseconds = $DelayMilliseconds
        $Global:CsLoggerSettings.SyslogServer = $SyslogServer
        $Global:CsLoggerSettings.SyslogPort = $SyslogPort
        $RunSpace = [runspacefactory]::CreateRunspace()
        $RunSpace.Open()
        $RunSpace.SessionStateProxy.SetVariable('CsLoggerSettings', $Global:CsLoggerSettings)
        $RunSpace.SessionStateProxy.SetVariable('CsLoggerQueue', $Global:CsLoggerQueue)
        $Global:CsLoggerPowerShell = [powershell]::Create()
        $Global:CsLoggerPowerShell.Runspace = $RunSpace
        $Global:CsLoggerPowerShell.AddScript( {
                While ($CsLoggerSettings.Enabled) {
                    $FirstLogEntry = $CsLoggerQueue.Dequeue()
                    if ($FirstLogEntry) {

                        $SyslogParams = @{
                            Server      = $CsLoggerSettings.SyslogServer
                            UDPPort     = $CsLoggerSettings.SyslogPort
                            Severity    = $FirstLogEntry.Severity
                            Facility    = $FirstLogEntry.Facility
                            Application = $FirstLogEntry.Application
                            Message     = $FirstLogEntry.Message
                        }

                        $VerboseMessage = $SyslogParams.Server + ':' + $SyslogParams.UDPPort
                        $VerboseMessage += '; ' + $SyslogParams.Severity
                        $VerboseMessage += '; ' + $SyslogParams.Facility
                        $VerboseMessage += '; ' + $SyslogParams.Application
                        $VerboseMessage += '; ' + $SyslogParams.Message

                        $CsLoggerSettings.host.ui.WriteVerboseLine($VerboseMessage)

                        Send-SyslogMessage @SyslogParams
                    }
                    $FirstLogEntry = $null
                    Start-Sleep -Milliseconds $CsLoggerSettings.DelayMilliseconds
                }
            }) | Out-Null
        $Global:CsLoggerRunSpace = $Global:CsLoggerPowerShell.BeginInvoke()
    }

    END {
    }
}