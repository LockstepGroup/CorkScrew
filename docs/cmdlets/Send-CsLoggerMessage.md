---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version: https://github.com/LockstepGroup/CorkScrew/blob/master/docs/cmdlets/Send-CsLoggerMessage.md
schema: 2.0.0
---

# Send-CsLoggerMessage

## SYNOPSIS
Sends a log message to active CsLogger instance.

## SYNTAX

```
Send-CsLoggerMessage [-Message] <String> [-Application] <String> [-Severity] <String> [-Facility] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Sends a log message to active CsLogger instance.

## EXAMPLES

### Example 1
```powershell
> Start-CsLogger
> Send-CsLoggerMessage -Message "My log message" -Application "My Cool App" -Severity "Emergency" -Facility "user"
> Stop-CsLogger
```

Starts a CsLogger instance. Sends the message "My log message" from Application "My Cool App" with a Severity of "Emergency" and Facility of "user". Stops CsLogger instance.

## PARAMETERS

### -Application
The Name of the application that is sending the log

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Facility
The log source facililty

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: kern, user, mail, daemon, auth, syslog, lpr, news, uucp, clock, authpriv, ftp, ntp, logaudit, logalert, cron, local0, local1, local2, local3, local4, local5, local6, local7

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
Desired message for the log

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Severity
Severity level of the log

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Emergency, Alert, Critical, Error, Warning, Notice, Informational, Debug

Required: True
Position: 2
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

[Start-CsLogger](https://github.com/LockstepGroup/CorkScrew/blob/master/docs/cmdlets/Start-CsLogger.md)

[Stop-CsLogger](https://github.com/LockstepGroup/CorkScrew/blob/master/docs/cmdlets/Stop-CsLogger.md)