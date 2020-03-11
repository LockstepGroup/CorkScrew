function Resolve-GenericNetworkString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Network,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$SubnetMask
    )

    # 192.168.10.10-192.168.11.10
    # 192.168.10.20-255
    # 192.168.*.2
    # 192.168.10.0/24
    # 192.168.10.0 255.255.255.0

    $IpRx = [regex] '(\d+)\.(\d+)\.(\d+)\.(\d+)'
    $RangeRx = [regex] "^(?<start>$IpRx)-(?<stop>$IpRx)$"
    $RangeShortRx = [regex] "^(?<start>$IpRx)-(?<stop>(\d+\.){1,3}\d+|\d+)$"
    $WildcardRx = [regex] "^(\d+\.\d+\.\d+\.\*|\d+\.\d+\.\*\.\d+|\d+\.\*\.\d+\.\d+|\*\.\d+\.\d+\.\d+)$"
    $NetworkAndMaskLengthRx = [regex] "^(?<network>$IpRx)\/(?<mask>\d+)$"
    $NetworkAndMaskRx = [regex] "^(?<network>$IpRx)\ (?<mask>$IpRx)$"

    $RangeMatch = $RangeRx.Match($Network)
    $RangeShortMatch = $RangeShortRx.Match($Network)
    $WildcardMatch = $WildcardRx.Match($Network)
    $NetworkAndMaskLengthMatch = $NetworkAndMaskLengthRx.Match($Network)
    $NetworkAndMaskMatch = $NetworkAndMaskRx.Match($Network)

    $Ips = @()

    if ($SubnetMask) {
        $Ips = Get-NetworkRange -IpAddress $Network -SubnetMask $SubnetMask -IncludeNetworkAndBroadcast
    } elseif ($RangeMatch.Success) {
        $Start = $RangeMatch.Groups['start'].Value
        Write-Verbose $Start
        $Stop = $RangeMatch.Groups['stop'].Value
        Write-Verbose $Stop

        $DecimalStart = ConvertTo-DecimalIP $Start
        $DecimalStop = ConvertTo-DecimalIP $Stop

        for ($i = $DecimalStart; $i -le $DecimalStop; $i++) {
            $Ips += ConvertTo-DottedDecimalIP $i
        }
        return $Ips
    } elseif ($RangeShortMatch.Success) {
        Write-Verbose "Short range matched: $RangeShortMatch.Value"

        $StartIpMatch = $IpRx.Match($RangeShortMatch.Groups['start'].Value)
        Write-Verbose "Starting IP: $($StartIpMatch.Value)"

        $StopSplit = $RangeShortMatch.Groups['stop'].Value -split '\.'
        Write-Verbose "Range end: $($RangeShortMatch.Groups['stop'].Value)"
        Write-Verbose "Octets found in stop range: $($StopSplit.Count)"

        $StartCalc = 4 - $StopSplit.Count
        Write-Verbose $StartCalc

        $StopIp = ""
        for ($i = 1; $i -le $StartCalc; $i++) {
            $StopIp += $StartIpMatch.Groups[$i].Value + '.'
        }
        $StopIp += $($RangeShortMatch.Groups['stop'].Value)
        Write-Verbose $StopIp

        $DecimalStart = ConvertTo-DecimalIP $StartIpMatch.Value
        $DecimalStop = ConvertTo-DecimalIP $StopIp

        for ($i = $DecimalStart; $i -le $DecimalStop; $i++) {
            $Ips += ConvertTo-DottedDecimalIP $i
        }
        return $Ips
    } elseif ($WildcardMatch.Success) {
        Write-Verbose "Wildcard matched: $($WildcardMatch.Value)"

        $Ips = 1..255 | % { $WildcardMatch.Value -replace "\*", $_ }

    } elseif ($NetworkAndMaskLengthMatch.Success) {
        Write-Verbose "Network and mask length found $($NetworkAndMaskLengthMatch.Value)"
        $Ips = Get-NetworkRange -IpAndMaskLength $NetworkAndMaskLengthMatch.Value -IncludeNetworkAndBroadcast
    } elseif ($NetworkAndMaskMatch.Success) {
        Write-Verbose "Network and subnet mask found: $($NetworkAndMaskMatch.value)"
        $Split = $NetworkAndMaskMatch.value.Split()
        Write-Verbose $Split[0]
        $Ips = Get-NetworkRange -IpAddress $Split[0] -SubnetMask $Split[1] -IncludeNetworkAndBroadcast
    }

    return $Ips
}