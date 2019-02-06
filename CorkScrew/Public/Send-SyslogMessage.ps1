function Send-SyslogMessage {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Server,

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
        [string] $Facility,

        [Parameter(Mandatory = $false)]
        [string] $Hostname,

        [Parameter(Mandatory = $false)]
        [string] $Timestamp,

        [Parameter(Mandatory = $false)]
        [int] $UDPPort = 514
    )

    $SyslogFacilityHash = @{
        kern     = 0;
        user     = 1;
        mail     = 2;
        daemon   = 3;
        auth     = 4;
        syslog   = 5;
        lpr      = 6;
        news     = 7;
        uucp     = 8;
        clock    = 9;
        authpriv = 10;
        ftp      = 11;
        ntp      = 12;
        logaudit = 13;
        logalert = 14;
        cron     = 15;
        local0   = 16;
        local1   = 17;
        local2   = 18;
        local3   = 19;
        local4   = 20;
        local5   = 21;
        local6   = 22;
        local7   = 23
    }

    $SyslogSeverityHash = @{
        Emergency     = 0;
        Alert         = 1;
        Critical      = 2;
        Error         = 3;
        Warning       = 4;
        Notice        = 5;
        Informational = 6;
        Debug         = 7
    }

    $WhatIfMessage = ""

    $UDPCLient = New-Object System.Net.Sockets.UdpClient
    $UDPCLient.Connect($Server, $UDPPort)

    $FacilityNumber = $SyslogFacilityHash.$Facility
    $WhatIfMessage += "Facility: $FacilityNumber`r`n"

    $SeverityNumber = $SyslogSeverityHash.$Severity
    $WhatIfMessage += "Severity: $SeverityNumber`r`n"

    $Priority = ($FacilityNumber * 8) + $SeverityNumber
    $WhatIfMessage += "Priority: $Priority`r`n"

    if (($Hostname -eq "") -or ($Hostname -eq $null)) {
        $Hostname = Hostname
    }
    $WhatIfMessage += "Hostname: $Hostname`r`n"

    if (($Timestamp -eq "") -or ($Timestamp -eq $null)) {
        $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
        #$Timestamp = ([DateTimeOffset]::UtcNow).ToUnixTimeMilliseconds()
    }
    $WhatIfMessage += "Timestamp: $Timestamp`r`n"

    $FullSyslogMessage = "<{0}>{1} {2} {3}: {4}" -f $Priority, $Timestamp, $Hostname, $Application, $Message
    $WhatIfMessage += "Full Syslog Message: $FullSyslogMessage"

    $Encoding = [System.Text.Encoding]::ASCII

    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)

    if ($ByteSyslogMessage.Length -gt 1024) {
        $ByteSyslogMessage = $ByteSyslogMessage.SubString(0, 1024)
    }

    if ($PSCmdlet.ShouldProcess("Sending Syslog Messaage:`r`n" + $WhatIfMessage)) {
        $Send = $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    }
}