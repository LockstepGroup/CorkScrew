if (-not $ENV:BHProjectPath) {
    Set-BuildEnvironment -Path $PSScriptRoot\..
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force


InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major
    $ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}
    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose", $True)
    }

    Describe "Get-Ninite" {
        Context "Non-Windows" {
            Mock Get-Item { return @{Value = "macos"} } -ParameterFilter { $Path -eq 'env:os' }
            It "Should throw on non-windows systems" {
                { Get-Ninite -Apps 7zip } | Should -Throw
            }
        }
        try {
            $ThisOS = (Get-Item -Path env:os -ErrorAction Stop).Value     # did it this way so I could Mock Get-Item with Pester
            if ($ThisOS -eq 'Windows_NT') {
                Context "Windows" {
                    It "Should download a file" {
                        $ExePath = Join-Path -Path $env:TEMP -ChildPath ninite.exe
                        Write-Host $ExePath
                        Write-Host (gci $env:TEMP | Out-String)
                        Test-Path $ExePath | Should -BeTrue
                    }
                }
            }
        } catch {
        }
    }
}