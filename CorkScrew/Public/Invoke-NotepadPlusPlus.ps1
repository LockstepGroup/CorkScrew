Function Invoke-NotepadPlusPlus {
    [CmdLetBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [string]$Path
    )
    try {
        $ThisOS = (Get-Item -Path env:os -ErrorAction Stop).Value     # did it this way so I could Mock Get-Item with Pester
    } catch {
        Throw "Ninite is only supported on Windows."
    }
    if ($ThisOS -ne 'Windows_NT') {
        Throw "Ninite is only supported on Windows."
    }

    $npp = (Resolve-Path "C:\Program Files (x86)\Notepad++\notepad++.exe").Path
    if ($Path) {
        $Target = (Resolve-Path $Path).Path
    }
    & $npp $Target
}

New-Alias -Name npp -Value Invoke-NotepadPlusPlus