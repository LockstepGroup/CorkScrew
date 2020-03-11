function New-PsModuleFixture {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Noun,

        [Parameter(Mandatory = $false)]
        [string]$ProjectPath = (Resolve-Path ./)

    )

    BEGIN {
        $VerbosePrefix = "New-PsModuleFixture:"
    }

    PROCESS {

        #region Paths
        ####################################################################################

        # verify ProjectPath
        Write-Verbose "$VerbosePrefix checking that ProjectPath exists: $ProjectPath"
        try {
            $ProjectPath = Resolve-Path -Path $ProjectPath -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $ProjectPath"
        }

        Write-Verbose "$VerbosePrefix creating file structure"
        $ProjectName = Split-Path -Path $ProjectPath -Leaf
        $ModulePath = Join-Path -Path $ProjectPath -ChildPath $ProjectName
        $CmdletPath = Join-Path -Path $ModulePath -ChildPath 'Public'
        $TestsPath = Join-Path -Path $ProjectPath -ChildPath 'Tests'
        $ClassPath = Join-Path -Path $ModulePath -ChildPath 'Classes/Main'

        # verify ModulePath
        Write-Verbose "$VerbosePrefix checking that ModulePath exists: $ModulePath"
        try {
            $ModulePath = Resolve-Path -Path $ModulePath -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $ModulePath"
        }

        # verify CmdletPath
        Write-Verbose "$VerbosePrefix checking that CmdletPath exists: $CmdletPath"
        try {
            $CmdletPath = Resolve-Path -Path $CmdletPath -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $CmdletPath"
        }

        # verify TestsPath
        Write-Verbose "$VerbosePrefix checking that TestsPath exists: $TestsPath"
        try {
            $TestsPath = Resolve-Path -Path $TestsPath -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $TestsPath"
        }

        # verify ClassPath
        Write-Verbose "$VerbosePrefix checking that ClassPath exists: $ClassPath"
        try {
            $ClassPath = Resolve-Path -Path $ClassPath -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $ClassPath"
        }

        ####################################################################################
        #endregion Paths

        #region createCmdletFiles
        ####################################################################################

        $CmdletNames = @(
            "New-$Noun"
            "Get-$Noun"
            "Set-$Noun"
            "Remove-$Noun"
        )

        # create this cmdlet root path
        $ThisCmdletRoot = Join-Path -Path $CmdletPath -ChildPath $Noun
        New-Item -Path $ThisCmdletRoot -ItemType Directory | Out-Null

        $ThisTestRoot = Join-Path $TestsPath -ChildPath $Noun
        New-Item -Path $ThisTestRoot -ItemType Directory | Out-Null

        foreach ($cmdlet in $CmdletNames) {

            #region cmdletContent
            ################################################################################

            $CmdletContent = @()
            $CmdletContent += "function $cmdlet {"
            $CmdletContent += "    [CmdletBinding()]"
            $CmdletContent += "    Param ("
            $CmdletContent += "    )"
            $CmdletContent += ""
            $CmdletContent += "    BEGIN {"
            $CmdletContent += '        $VerbosePrefix = "' + $cmdlet + ':"'
            $CmdletContent += "    }"
            $CmdletContent += ""
            $CmdletContent += "    PROCESS {"
            $CmdletContent += "    }"
            $CmdletContent += ""
            $CmdletContent += "    END {"
            $CmdletContent += "    }"
            $CmdletContent += "}"

            ################################################################################
            #endregion cmdletContent

            #region testContent
            ################################################################################

            $TestsContent = @()
            $TestsContent += 'if (-not $ENV:BHProjectPath) {'
            $TestsContent += '    Set-BuildEnvironment -Path $PSScriptRoot\..'
            $TestsContent += '}'
            $TestsContent += 'Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue'
            $TestsContent += 'Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force'
            $TestsContent += ''
            $TestsContent += 'InModuleScope $ENV:BHProjectName {'
            $TestsContent += '    $PSVersion = $PSVersionTable.PSVersion.Major'
            $TestsContent += '    $ProjectRoot = $ENV:BHProjectPath'
            $TestsContent += ''
            $TestsContent += '    $Verbose = @{ }'
            $TestsContent += '    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {'
            $TestsContent += '        $Verbose.add("Verbose", $True)'
            $TestsContent += '    }'
            $TestsContent += ''
            $TestsContent += '    Describe "' + $cmdlet + '" {'
            $TestsContent += '        #region dummydata'
            $TestsContent += '        ########################################################################'
            $TestsContent += ''
            $TestsContent += '        ########################################################################'
            $TestsContent += '        #endregion dummydata'
            $TestsContent += ''
            $TestsContent += '        #region firstTest'
            $TestsContent += '        ########################################################################'
            $TestsContent += '        Context FirstTest {'
            $TestsContent += '            It "should pass the first test" {'
            $TestsContent += '            }'
            $TestsContent += '        }'
            $TestsContent += '        ########################################################################'
            $TestsContent += '        #endregion firstTest'
            $TestsContent += '    }'
            $TestsContent += '}'

            ################################################################################
            #endregion testContent

            #region classContent
            ################################################################################

            $ClassContent = @()
            $ClassContent += 'Class ' + $Noun + ' {'
            $ClassContent += '    [string]$String'
            $ClassContent += '    [int]$Integer'
            $ClassContent += '    [bool]$Bool'
            $ClassContent += ''
            $ClassContent += '    #region Initiators'
            $ClassContent += '    ########################################################################'
            $ClassContent += ''
            $ClassContent += '    # empty initiator'
            $ClassContent += '    ' + $Noun + '() {'
            $ClassContent += '    }'
            $ClassContent += ''
            $ClassContent += '    ########################################################################'
            $ClassContent += '    #endregion Initiators'
            $ClassContent += '}'

            ################################################################################
            #endregion classContent

            # output files
            $ThisCmdletPath = Join-Path -Path $ThisCmdletRoot -ChildPath "$cmdlet.ps1"
            $CmdletContent | Out-File -FilePath $ThisCmdletPath

            $ThisTestsPath = Join-Path -Path $ThisTestRoot -ChildPath "$cmdlet.Tests.ps1"
            $TestsContent | Out-File -FilePath $ThisTestsPath

            $ThisClassPath = Join-Path -Path $ClassPath -ChildPath "$Noun.Class.ps1"
            $ClassContent | Out-File -FilePath $ThisClassPath
        }
    }

    END {
    }
}