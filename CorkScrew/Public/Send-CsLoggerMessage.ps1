function Send-CsLoggerMessage {
    [CmdletBinding()]
    Param (
        # TODO: need to ensure that message and or application fields do NOT contain restricted chars, specifically colons (:). also including words like "error" in non-error messages can get weird
        [Parameter(Mandatory = $true)]
        [string] $Message,

        [Parameter(Mandatory = $true)]
        [string] $Application,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Emergency', 'Alert', 'Critical', 'Error', 'Warning', 'Notice', 'Informational', 'Debug')]
        [string] $Severity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('kern', 'user', 'mail', 'daemon', 'auth', 'syslog', 'lpr', 'news', 'uucp', 'clock', 'authpriv', 'ftp', 'ntp', 'logaudit', 'logalert', 'cron', 'local0', 'local1', 'local2', 'local3', 'local4', 'local5', 'local6', 'local7')]
        [string] $Facility
    )

    $VerbosePrefix = 'Send-CsLoggerMessage:'

    $global:CsLoggerQueue.Enqueue(
        @{
            Severity    = $Severity
            Facility    = 'user'
            Application = $Application
            Message     = $Message
        }
    )
}