function Write-CustomLog {
    [CmdletBinding()]
    Param (
        [parameter(ParameterSetName = "syslog", Position = 0, Mandatory = $false)]
        [parameter(ParameterSetName = "nosyslog", Position = 0, Mandatory = $false)]
        [ValidateRange(0, 5)]
        [int]$LogLevel = 1,

        [Parameter(ParameterSetName = "syslog", Position = 1, Mandatory = $true)]
        [Parameter(ParameterSetName = "nosyslog", Position = 1, Mandatory = $true)]
        [String]$Message,

        [Parameter(ParameterSetName = "syslog", Position = 2, Mandatory = $false)]
        [Parameter(ParameterSetName = "nosyslog", Position = 2, Mandatory = $false)]
        [String]$LogFile = $global:LogFile,

        [Parameter(ParameterSetName = "syslog", Position = 3, Mandatory = $false)]
        [Parameter(ParameterSetName = "nosyslog", Position = 3, Mandatory = $false)]
        [String]$TimeStampFormat = "HH:mm:ss.fffff",

        [Parameter(ParameterSetName = "syslog", Mandatory = $false)]
        [Parameter(ParameterSetName = "nosyslog", Mandatory = $false)]
        [switch]$LogHeader,

        [Parameter(ParameterSetName = "syslog", Mandatory = $true)]
        [String]$SyslogServer = $global:SyslogServer,

        [Parameter(ParameterSetName = "syslog", Mandatory = $true)]
        [int]$SyslogPort = $global:SyslogPort,

        [Parameter(ParameterSetName = "syslog", Mandatory = $true)]
        [String]$SyslogApplication = $global:SyslogApplication,

        [Parameter(ParameterSetName = "syslog", Mandatory = $false)]
        [switch]$IsError
    )
    # timestamp formats:
    # "yyyy/MM/dd HH:mm:ss.fffff"
    # "HH:mm:ss.fffff"

    $VerbosePrefix = 'Write-CustomLog:'

    if ($global:LogThreshold -ge $LogLevel) {

        # Create Custom LogMessage
        if ($LogHeader) {
            $LogMessage = "`r`n" + '-------------' + (Get-Date -Format "yyyy/MM/dd HH:mm:ss.fffff") + " " + $Message + '-------------'
            $SyslogMessage = $LogMessage
        } else {
            $LogMessage = (Get-Date -Format $TimeStampFormat) + ": " + $Message
            $SyslogMessage = $Message
        }

        # Write LogMessage to Verbose
        Write-Verbose $LogMessage

        # Write LogMessage to LogFile if specified
        if ($LogFile) {
            $LogMessage | Out-File $LogFile -Append
        }

        # Syslog
        if ($PsCmdlet.ParameterSetName -eq 'syslog') {
            # Translate Loglevel to Severity for Syslog
            if ($VerbosityThreshold -gt 2) {
                $LogSeverity = 'Debug'
            } else {
                $LogSeverity = 'Informational'
            }

            if ($IsError) {
                $LogSeverity = 'Error'
            }

            # Send Syslog to LogDNA
            Write-Verbose "$VerbosePrefix Sending syslog to $SyslogServer`:$SyslogPort with Severity $LogSeverity"
            Send-SyslogMessage -Server $SyslogServer -UDPPort $SyslogPort -Severity $LogSeverity -Facility 'user' -Application $SyslogApplication -Message $SyslogMessage
        }
    }
}

Set-Alias -Name log -Value Write-CustomLog
