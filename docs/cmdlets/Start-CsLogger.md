---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version: https://github.com/LockstepGroup/CorkScrew/blob/master/docs/cmdlets/Start-CsLogger.md
schema: 2.0.0
---

# Start-CsLogger

## SYNOPSIS
Starts background log collector.

## SYNTAX

```
Start-CsLogger [[-SyslogServer] <String>] [[-SyslogPort] <Int32>] [[-DelayMilliseconds] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
CsLogger is a special runspace designed to receive logs and send them to a syslog server as fast as it can while the rest of your script gets on with it's job.  Originally it was designed to circumvent a log server who's time precision only went as low as a second. This meant that logs that showed up out of order, with the same second in the timestamp, stayed out of order. Reading and sending these logs 1 second at a time fixed the issue. You can use DelayMilliseconds to customize this effect.

## EXAMPLES

### Example 1
```powershell
>Start-CsLogger
```

Starts a CsLogger runspace with default delay of 1000 Milliseconds, $global:SyslogServer, and $global:SyslogPort settings.

### Example 1
```powershell
>Start-CsLogger -SyslogServer 'syslog.example.com' -SyslogPort 999 -DelayMilliseconds 5
```

Starts a CsLogger runspace with delay of 5 Milliseconds, sending logs to syslog.exampl.com over port 999.

## PARAMETERS

### -DelayMilliseconds
Delay in Milliseconds between sending logs to SyslogServer

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyslogPort
UDP Port for SyslogServer

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyslogServer
Destination SyslogServer

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://github.com/LockstepGroup/CorkScrew](https://github.com/LockstepGroup/CorkScrew)

[https://www.powershellgallery.com/packages/CorkScrew](https://www.powershellgallery.com/packages/CorkScrew)

[Send-CsLoggerMessage](https://github.com/LockstepGroup/CorkScrew/blob/master/docs/cmdlets/Send-CsLoggerMessage.md)

[Stop-CsLogger](https://github.com/LockstepGroup/CorkScrew/blob/master/docs/cmdlets/Stop-CsLogger.md)