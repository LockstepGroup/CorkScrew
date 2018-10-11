---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version: https://github.com/LockstepGroup/CorkScrew/blob/master/docs/New-EncryptedString.md
schema: 2.0.0
---

# New-EncryptedString

## SYNOPSIS
Encrypts a string using an Aes key.

## SYNTAX

```
New-EncryptedString [[-PlainTextString] <String>] [[-AesKey] <Array>] [<CommonParameters>]
```

## DESCRIPTION
Encrypts a string using an AES key. Key can be generated by New-EncryptionKey

## EXAMPLES

### Example 1
```powershell
PS C:\> $Key = New-EncryptionKey
PS C:\> $EncryptedString = New-EncryptedString -PlainTextString 'my secret' -AesKey $Key
PS C:\> $EncryptedString
76492d1116743f0423413b16050a5345MgB8AHUAbwBwAGwAaABtAEUAUQBzADgAawBaAGYAOABZAFkASQArADIAbgBXAGcAPQA9AHwANAA0ADIAYgA2ADYAYgBjADMAYwBkADcAZgA3ADMAZgA5ADEAYwAyADAAZAA3ADUAOABlADQAZQA4ADUANAAwAGQAMwA0ADYAYgAwADYAZgBmADYANQBmADYAOAAwADcAMQBiADAAYgAwAGYAOQA2ADMANwA0ADAANgBhAGQAZgA=
```

Creates a new encryption key and encryps the string 'my secret'.

## PARAMETERS

### -AesKey
Byte Array to be used as Aes Key

```yaml
Type: Array
Parameter Sets: (All)
Aliases: Key

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlainTextString
String to be encrypted

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