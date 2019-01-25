---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version: https://github.com/LockstepGroup/CorkScrew/blob/master/docs/Write-CustomLog.md
schema: 2.0.0
---

# Write-CustomLog

## SYNOPSIS
Creates a customized Log Message.

## SYNTAX

```
Write-CustomLog [[-LogLevel] <Int32>] [-Message] <String> [[-LogFile] <String>] [[-TimeStampFormat] <String>]
 [-LogHeader] [-SyslogServer <String>] [-SyslogPort <Int32>] [-SyslogApplication <String>] [-IsError]
 [-CsLogger] [<CommonParameters>]
```

## DESCRIPTION
Creates a customized Log Message based on the desired Verbosity level. Verbosity is set with the global variable $global:Verbosity. If the Write-CustomLog Verbosity Threshold is lower than $global:Verbosity, then Message will be written to the Verbose Stream and optionally to LogFile. LogFile defaults to $global:Logfile. The intended usage is to set Verbosity and LogFile at the top of whatever script you use this in.

## EXAMPLES

### Example 1

```powershell
PS C:\> Write-CustomLog 1 "Special Log Message"
```

If $Global:Verbosity is higher than 1, write formatted log message to Verbose Stream. Also write to LogFile if set globally.

### Example 2

```powershell
PS C:\> Write-CustomLog 1 "This is a Log header" -LogHeader
```

If $Global:Verbosity is higher than 1, write formatted log header message to Verbose Stream. Also write to LogFile if set globally.

## PARAMETERS

### -CsLogger
{{Fill CsLogger Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsError
{{Fill IsError Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFile
LogFile to write to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogHeader
Changes the format of the LogMessage so it's easy to see the start of a section of logs

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogLevel
{{Fill LogLevel Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
String to log

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

### -SyslogApplication
{{Fill SyslogApplication Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyslogPort
{{Fill SyslogPort Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyslogServer
{{Fill SyslogServer Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeStampFormat
Custom TimeStamp format

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://github.com/LockstepGroup/CorkScrew](https://github.com/LockstepGroup/CorkScrew)

[https://www.powershellgallery.com/packages/CorkScrew](https://www.powershellgallery.com/packages/CorkScrew)