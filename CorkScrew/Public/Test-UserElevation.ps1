function Test-UserElevation {
    [CmdletBinding()]
    Param (
    )
    # Get the ID and security principal of the current user account
    $MyWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $MyWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyWindowsID)

    # Get the security principal for the Administrator role
    $AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

    return $MyWindowsPrincipal.IsInRole($AdminRole)
}