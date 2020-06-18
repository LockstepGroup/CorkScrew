function Get-DayOfThisWeek {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        [string]$DayOfWeek
    )

    BEGIN {
        $VerbosePrefix = 'Get-DayOfThisWeek'

        $DayOrder = @{
            Sunday    = 1
            Monday    = 2
            Tuesday   = 3
            Wednesday = 4
            Thursday  = 5
            Friday    = 6
            Saturday  = 7
        }
    }

    PROCESS {
        $ThisDayOfWeek = Get-Date
        if ($ThisDayOfWeek.DayOfWeek -ne $DayOfWeek) {
            $DesiredOrder = $DayOrder.$DayOfWeek
            $ThisOrder = $DayOrder."$($ThisDayOfWeek.DayOfWeek)"
            $Difference = $DesiredOrder - $ThisOrder
            $ThisDayOfWeek = $ThisDayOfWeek.AddDays($Difference)
        }
    }

    END {
        get-date "$($ThisDayOfWeek.Month)/$($ThisDayOfWeek.Day)/$($ThisDayOfWeek.Year)"
    }
}
