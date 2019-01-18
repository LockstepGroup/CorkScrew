function Invoke-ElevatedProcess {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$ProcessName,

        [Parameter(Mandatory = $False, Position = 1)]
        [string]$Arguments,

        [Parameter(Mandatory = $False, Position = 2)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $False)]
        [switch]$NoWait
    )

    Write-Verbose "Invoking elevated process."
    Write-Verbose ("  Args: " + $Arguments)
    Write-Verbose ("  StartIn: " + $WorkingDirectory)

    $ProcessInfo = new-object System.Diagnostics.ProcessStartInfo "$ProcessName"
    $ProcessInfo.Verb = "runas"
    #$ProcessInfo.UseShellExecute        = $false
    $ProcessInfo.Arguments = $Arguments
    #$ProcessInfo.RedirectStandardOutput = $true
    #$ProcessInfo.RedirectStandardError  = $true
    $ProcessInfo.WorkingDirectory = $WorkingDirectory

    $Process = New-Object System.Diagnostics.Process
    $Process.StartInfo = $ProcessInfo
    try {
        $Process.Start() | Out-Null
        if (!($NoWait)) {
            $Process.WaitForExit()
        }
        return $Process
    } catch {
        Write-Error "Unable to start elevated process."
        return $false
    }

}