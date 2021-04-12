function Get-OsVersion {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$ComputerName = 'localhost'
    )

    if ($IsMacOS) {
        if ($ComputerName -ne 'localhost') {
            Throw "Remote machines not support from MacOSX"
        } else {
            $ProductNameRx = [regex]'ProductName:\s+(.+)'
            $ProductVersionRx = [regex]'ProductVersion:\s+(.+)'
            $SwVerOutput = (sw_vers).Split("`r`n")

            $OutputString = ""

            foreach ($line in $SwVerOutput) {
                $ProductNameMatch = $ProductNameRx.Match($line)
                $ProductVersionMatch = $ProductVersionRx.Match($line)

                if ($ProductNameMatch.Success) {
                    $OutputString += $ProductNameMatch.Groups[1].Value -replace ' ', ''
                }

                if ($ProductVersionMatch.Success) {
                    $OutputString += ' '
                    $OutputString += $ProductVersionMatch.Groups[1].Value
                }
            }
        }
    }
    if ($IsLinux) {
        Throw "Not handled yet"
    }
    if ($IsWindows -or ($PSVersionTable.PSEdition -eq 'Desktop')) {
        $OutputString = (Get-WmiObject "win32_operatingsystem" -ComputerName $ComputerName).caption
    }

    $OutputString
}