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

    Describe "New-EncryptionKey" {
        It "Should create an array with 32 entries" {
            New-EncryptionKey | Should -HaveCount 32
        }
        It "Array should only contain objects with Byte type" {
            $Key = New-EncryptionKey
            $key = @('test')
            foreach ($k in $key) {
                $k.GetType().Name | Should -Be 'Byte'
            }
        }
    }
}