function Stop-CsLogger {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "Stop-CsLogger:"
    }

    PROCESS {
        $Global:CsLoggerSettings.Enabled = $False
        while (-not $global:CsLoggerRunSpace.IsCompleted) {
            Start-Sleep -Seconds 1
        }

        $Global:CsLoggerPowerShell.EndInvoke($Global:CsLoggerRunSpace)
        $Global:CsLoggerPowerShell.Dispose()

        Remove-Variable -Name 'CsLoggerSettings' -Scope Global
        Remove-Variable -Name 'CsLoggerQueue' -Scope Global
        Remove-Variable -Name 'CsLoggerPowerShell' -Scope Global
        Remove-Variable -Name 'CsLoggerRunSpace' -Scope Global
    }

    END {
    }
}