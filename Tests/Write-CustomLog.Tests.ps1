<# if (-not $ENV:BHProjectPath) {
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

    Describe "Write-CustomLog" {
        $TestDate = '2018/08/27 16:37:37.83235'
        $LogHeader = "`r`n-------------$TestDate Log Header-------------"
        Mock Get-Date { return $TestDate }
        function GenLogMessages() {
            $Messages = @()
            $Messages += Write-CustomLog 1 "Log 1" -Verbose 4>&1
            $Messages += Write-CustomLog 2 "Log 2" -Verbose 4>&1
            $Messages += Write-CustomLog 3 "Log 3" -Verbose 4>&1
            $Messages += Write-CustomLog 4 "Log 4" -Verbose 4>&1
            $Messages += Write-CustomLog 5 "Log 5" -Verbose 4>&1
            $Messages
        }
        It "Produce a log header on a new line" {
            $global:LogThreshold = 2
            $Output = Write-CustomLog 1 "Log Header" -LogHeader -Verbose 4>&1
            $Output | Should -Be $LogHeader
        }
        It "Should log messages with verbosity 1 or lower" {
            $global:LogThreshold = 1
            $Messages = GenLogMessages
            $Messages | Should -HaveCount 1
        }
        It "Should log messages with verbosity 2 or lower" {
            $global:LogThreshold = 2
            $Messages = GenLogMessages
            $Messages | Should -HaveCount 2
        }
        It "Should log messages with verbosity 3 or lower" {
            $global:LogThreshold = 3
            $Messages = GenLogMessages
            $Messages | Should -HaveCount 3
        }
        It "Should log messages with verbosity 4 or lower" {
            $global:LogThreshold = 4
            $Messages = GenLogMessages
            $Messages | Should -HaveCount 4
        }
        It "Should log messages with verbosity 5 or lower" {
            $global:LogThreshold = 5
            $Messages = GenLogMessages
            $Messages | Should -HaveCount 5
        }
        It "Should log no messages" {
            $global:LogThreshold = 0
            $Messages = GenLogMessages
            $Messages | Should -HaveCount 0
        }
    }
} #>