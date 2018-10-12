---
external help file: CorkScrew-help.xml
Module Name: CorkScrew
online version: https://github.com/LockstepGroup/CorkScrew/blob/master/docs/Invoke-FuriousIp.md
schema: 2.0.0
---

# Invoke-FuriousIp

## SYNOPSIS
Pings things in a furiously fast fashion.

## SYNTAX

```
Invoke-FuriousIp [-Network] <String> [[-SubnetMask] <String>] [-Limit <Int32>] [-PingDelay <Int32>]
 [-ReverseLookup] [<CommonParameters>]
```

## DESCRIPTION
Uses .net ping and runspaces to ping a given network range very quickly. Optionally does a reverse lookup as well.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-FuriousIp 10.88.64.0/29

Name       State Hostname
----       ----- --------
10.88.64.1  True
10.88.64.2 False
10.88.64.3 False
10.88.64.4 False
10.88.64.5 False
10.88.64.6 False
```

Pings all address in 10.88.64.0/29 network.

### Example 2
```powershell
PS C:\> Invoke-FuriousIp 10.88.64.0/29 -ReverseLookup

Name       State Hostname
----       ----- --------
10.88.64.1  True core.example.com
10.88.64.2 False
10.88.64.3 False
10.88.64.4 False
10.88.64.5 False
10.88.64.6 False
```

Pings all address in 10.88.64.0/29 network and performs a reverse lookup for each.

## PARAMETERS

### -Limit
Number of concurrent threads to use

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

### -Network
Network in any of the following formats:
192.168.10.10-192.168.11.10
192.168.10.20-255
192.168.*.2
192.168.10.0/24
192.168.10.0 255.255.255.0

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

### -PingDelay
Time to wait for ping response in milliseconds

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

### -ReverseLookup
Specify if reverse lookup is desired

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

### -SubnetMask
Subnet Mask for desired Network

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Net.IPAddress
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://github.com/LockstepGroup/CorkScrew](https://github.com/LockstepGroup/CorkScrew)

[https://www.powershellgallery.com/packages/CorkScrew](https://www.powershellgallery.com/packages/CorkScrew)