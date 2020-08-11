function Get-MacAddressVendor {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$MacAddress
    )

    BEGIN {
        $VerbosePrefix = 'Get-DayOfThisWeek'

        $Rx = [regex] '^([0-9a-fA-F][0-9a-fA-F](:|-|\.)?){5}([0-9a-fA-F][0-9a-fA-F])$'
        $ReturnObject = @()
    }

    PROCESS {
        foreach ($mac in $MacAddress) {
            if ($Rx.Match($mac).Success) {
                $new = "" | Select-Object 'MacAddress', 'Vendor'
                $ReturnObject += $new
                $new.MacAddress = $mac

                #sanitize mac
                $mac = $mac -replace ':', '' -replace '\.', '' -replace '-', ''

                # get vendor
                $Uri = 'https://api.macvendors.com/' + $mac
                $new.Vendor = Invoke-RestMethod -Uri $Uri

                # api rate limites to 1 request per second
                if ($MacAddress.Count -gt 1) {
                    Start-Sleep -Seconds 1
                }
            } else {
                Write-Warning "$VerbosePrefix unrecognized MacAddress format: $mac"
            }
        }
    }

    END {
        $ReturnObject
    }
}

New-Alias -Name gmac -Value Get-MacAddressVendor