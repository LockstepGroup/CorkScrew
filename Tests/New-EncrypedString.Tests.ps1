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

    Describe "New-EncryptedString" {
        $TestKey = @'
[
11,
52,
237,
151,
79,
144,
238,
223,
103,
22,
67,
136,
184,
195,
228,
12,
26,
242,
93,
160,
125,
102,
188,
59,
107,
174,
97,
54,
10,
107,
119,
29
]
'@
        $TestKey = $TestKey | ConvertFrom-Json
        $TestString = 'teststring'
        It "Should return a correctly encrypted string" {
            $EncryptedString = New-EncryptedString -PlainTextString $TestString -AesKey $TestKey
            $SecureString = ConvertTo-SecureString $EncryptedString -Key $TestKey
            $TestCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'user', $SecureString
            $TestCred.GetNetworkCredential().Password | Should -BeExactly $TestString
        }
    }
} #>