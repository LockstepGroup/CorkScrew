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
        [switch]$LogHeader
    )
    # timestamp formats:
    # "yyyy/MM/dd HH:mm:ss.fffff"
    # "HH:mm:ss.fffff"

    if ($global:LogThreshold -ge $LogLevel) {

        # Create Custom LogMessage
        if ($LogHeader) {
            $LogMessage = "`r`n" + '-------------' + (Get-Date -Format "yyyy/MM/dd HH:mm:ss.fffff") + " " + $Message + '-------------'
        } else {
            $LogMessage = (Get-Date -Format $TimeStampFormat) + ": " + $Message
        }

        # Write LogMessage to Verbose
        Write-Verbose $LogMessage

        # Write LogMessage to LogFile if specified
        if ($LogFile) {
            $LogMessage | Out-File $LogFile -Append
        }
    }
}

Set-Alias -Name log -Value Write-CustomLog
