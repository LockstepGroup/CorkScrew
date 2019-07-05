function Write-CustomLog {
    [CmdletBinding()]
    Param (
        [parameter(Position = 0, Mandatory = $false)]
        [ValidateRange(0, 5)]
        [int]$LogLevel = 1,

        [Parameter(Position = 1, Mandatory = $true)]
        [String]$Message,

        [Parameter(Position = 2, Mandatory = $false)]
        [String]$LogFile = $global:LogFile,

        [Parameter(Position = 3, Mandatory = $false)]
        [String]$TimeStampFormat = "HH:mm:ss.fffff",

        [Parameter(Mandatory = $false)]
        [Parameter(ParameterSetName = "nosyslog", Mandatory = $false)]
        [switch]$LogHeader,

        [Parameter(Mandatory = $false)]
        [String]$SyslogServer = $global:SyslogServer,

        [Parameter(Mandatory = $false)]
        [int]$SyslogPort = $global:SyslogPort,

        [Parameter(Mandatory = $false)]
        [String]$SyslogApplication = $global:SyslogApplication,

        [Parameter(Mandatory = $false)]
        [String]$LogDnaApiKey = $global:LogDnaApiKey,

        [Parameter(Mandatory = $false)]
        [String]$LogDnaEnvironment = $global:LogDnaEnvironment,

        [Parameter(Mandatory = $false)]
        [hashtable]$LogDnaMetaData = $global:LogDnaMetadata,

        [Parameter(Mandatory = $false)]
        [switch]$IsError,

        [Parameter(Mandatory = $false)]
        [switch]$CsLogger
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
        if ($IsError) {
            Write-Warning $LogMessage
        } else {
            Write-Verbose $LogMessage
        }

        # Write LogMessage to LogFile if specified
        if ($LogFile) {
            $LogMessage | Out-File $LogFile -Append
        }

        # Translate Loglevel to Severity for Syslog
        if ($LogLevel -gt 2) {
            $LogSeverity = 'Debug'
        } else {
            $LogSeverity = 'Informational'
        }

        if ($IsError) {
            $LogSeverity = 'Error'
        }

        # Syslog
        if (($SyslogServer -and $SyslogPort -and $SyslogApplication) -or ($CsLogger -and $SyslogApplication)) {
            if ($CsLogger) {
                Send-CsLoggerMessage -Message $SyslogMessage -Facility "user" -Application $SyslogApplication -Severity $LogSeverity
            } else {
                Send-SyslogMessage -Server $SyslogServer -UDPPort $SyslogPort -Severity $LogSeverity -Facility 'user' -Application $SyslogApplication -Message $SyslogMessage
            }
        }

        # LogDna
        if ($LogDnaApiKey -and $LogDnaEnvironment) {
            if ($LogSeverity -eq 'Informational') {
                $LogSeverity = 'INFO'
            }

            $LogDnaParameters = @{}
            $LogDnaParameters.SyslogMessage = $LogDnaApiKey
            $LogDnaParameters.Message = $SyslogMessage
            $LogDnaParameters.Application = $SyslogApplication
            $LogDnaParameters.Environment = $LogDnaEnvironment
            $LogDnaParameters.Level = $LogSeverity

            if ($LogDnaMetaData) {
                $LogDnaParameters.Metadata = $LogDnaMetaData
            }

            $SendLogDna = Send-LogDnaMessage @LogDnaParameters
        }
    }
}

Set-Alias -Name log -Value Write-CustomLog
