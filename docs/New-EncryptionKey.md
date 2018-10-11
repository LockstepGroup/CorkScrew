---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version:
schema: 2.0.0
---

# New-EncryptionKey

## SYNOPSIS
Generates Byte Array that can be used as an AES key for encrypting SecureStrings.

## SYNTAX

```
New-EncryptionKey [[-Size] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Generates Byte Array that can be used as an AES key for encrypting SecureStrings.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-EncryptionKey
```

Returns a 32 byte array.

### Example 2
```powershell
PS C:\> New-EncryptionKey -Size 64
```

Returns a 64 byte array.

## PARAMETERS

### -Size
Desired size of array in Bytes

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Array
## NOTES

## RELATED LINKS
