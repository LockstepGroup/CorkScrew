---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version:
schema: 2.0.0
---

# Invoke-ElevatedProcess

## SYNOPSIS
Starts a process with elevated privileges on a Windows system.

## SYNTAX

```
Invoke-ElevatedProcess [[-ProcessName] <String>] [[-Arguments] <String>] [[-WorkingDirectory] <String>]
 [-NoWait] [<CommonParameters>]
```

## DESCRIPTION
Starts a process with elevated privileges on a Windows system.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-ElevatedProcess
```

Creates instance of current PowerShell host process with elevated priveleges.

### Example 2
```powershell
PS C:\> Invoke-ElevatedProcess -ProcessName
```

Creates instance of current PowerShell host process with elevated priveleges.


## PARAMETERS

### -Arguments
{{Fill Arguments Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWait
{{Fill NoWait Description}}

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

### -ProcessName
{{Fill ProcessName Description}}

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

### -WorkingDirectory
{{Fill WorkingDirectory Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
