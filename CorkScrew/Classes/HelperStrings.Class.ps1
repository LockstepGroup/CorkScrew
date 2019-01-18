class HelperStrings {
    ############################################################
    # .vscode/settings.json file contents
    static [string]$VsCodeSettings = @'
{
  // Adds a newline (line break) after a closing brace.
  "powershell.codeFormatting.newLineAfterCloseBrace": false,

  // When enabled, will trim trailing whitespace when saving a file.
  "files.trimTrailingWhitespace": true,

  // Format a file on save. A formatter must be available, the file must not be auto-saved, and editor must not be shutting down.
  "editor.formatOnSave": true,

  // Controls whether the editor should automatically format the line after typing.
  "editor.formatOnType": true
}
'@

    ############################################################
    # psm1 file contents
    static [string]$Psm1File = @'
# cribbed this from https://www.powershellgallery.com/packages/Idempotion

$Subs = @(
    @{
        Path = 'Classes'
        Export = $false
        Recurse = $true
        Filter = '*.Class.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    } ,

    @{
        Path = 'Private'
        Export = $false
        Recurse = $false
        Filter = '*-*.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    } ,

    @{
        Path = 'Public'
        Export = $true
        Recurse = $false
        Filter = '*-*.ps1'
        Exclude = @(
                '*.Tests.ps1'
        )
    }
)


$thisModule = [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
$varName = "__${thisModule}_Export_All"
$exportAll = Get-Variable -Scope Global -Name $varName -ValueOnly -ErrorAction Ignore

$Subs | ForEach-Object -Process {
    $sub = $_
    $thisDir = $PSScriptRoot | Join-Path -ChildPath $sub.Path | Join-Path -ChildPath '*'
    $thisDir |
    Get-ChildItem -Filter $sub.Filter -Exclude $sub.Exclude -Recurse:$sub.Recurse -ErrorAction Ignore | ForEach-Object -Process {
        try {
            $Unit = $_.FullName
            . $Unit
            if ($sub.Export -or $exportAll) {
                Export-ModuleMember -Function $_.BaseName -Alias *
            }
        } catch {
            $e = "Could not import '$Unit' with exception: `n`n`n$($_.Exception)" -as $_.Exception.GetType()
            throw $e
        }
    }
}
'@

    ############################################################
    # .gitignore file contents
    static [string]$GitIgnore = @'
*.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon


# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Real config Files
config.json*

# Log Files
*.log
'@

    ############################################################
    # build.ps1 file contents
    static [string]$BuildPs1 = @'
[Cmdletbinding()]
Param ()
function Resolve-Module {
    [Cmdletbinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]]$Name
    )

    Process {
        foreach ($ModuleName in $Name) {
            $Module = Get-Module -Name $ModuleName -ListAvailable
            Write-Verbose -Message "Resolving Module $($ModuleName)"

            if ($Module) {
                $Version = $Module | Measure-Object -Property Version -Maximum | Select-Object -ExpandProperty Maximum
                $GalleryVersion = Find-Module -Name $ModuleName -Repository PSGallery | Measure-Object -Property Version -Maximum | Select-Object -ExpandProperty Maximum

                if ($Version -lt $GalleryVersion) {

                    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

                    Write-Verbose -Message "$($ModuleName) Installed Version [$($Version.tostring())] is outdated. Installing Gallery Version [$($GalleryVersion.tostring())]"

                    Install-Module -Name $ModuleName -Force
                    Import-Module -Name $ModuleName -Force -RequiredVersion $GalleryVersion
                } else {
                    Write-Verbose -Message "Module Installed, Importing $($ModuleName)"
                    Import-Module -Name $ModuleName -Force -RequiredVersion $Version
                }
            } else {
                Write-Verbose -Message "$($ModuleName) Missing, installing Module"
                Install-Module -Name $ModuleName -Force
                Import-Module -Name $ModuleName -Force -RequiredVersion $Version
            }
        }
    }
}

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

Resolve-Module Psake, PSDeploy, Pester, BuildHelpers

Set-BuildEnvironment -Force

Invoke-psake .\psake.ps1
exit ( [int]( -not $psake.build_success ) )
'@

    ############################################################
    # deploy.psdeploy.ps1 file contents
    static [string]$PsDeploy = @'
# Generic module deployment.
# This stuff should be moved to psake for a cleaner deployment view

# ASSUMPTIONS:

# folder structure of:
# - RepoFolder
#   - This PSDeploy file
#   - ModuleName
#     - ModuleName.psd1

# Nuget key in $ENV:NugetApiKey

# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName

# Publish to gallery with a few restrictions
if (
    $env:BHPSModulePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy'
) {
    Deploy Module {
        By PSGalleryModule {
            FromSource $ENV:BHPSModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
} else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
# You can use this to test a build from AppVeyor before pushing to psgallery
# https://psdeploy.readthedocs.io/en/latest/Example-AppVeyorModule-Deployment/

if (
    $env:BHPSModulePath -and
    $env:BHBuildSystem -eq 'AppVeyor'
) {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHPSModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}
'@

    ############################################################
    # deploy.psdeploy.ps1 file contents
    static [string]$LicenseMit = @'
MIT License

Copyright (c) 2018 Brian Addicks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'@

    ############################################################
    # psake.ps1 file contents
    static [string]$Psake = @'
# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    $ProjectRoot = $ENV:BHProjectPath
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $CoverageFile = "cov.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if ($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }
}

Task Default -Depends Deploy

Task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
}

Task Test -Depends Init {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $CodeCoverageFiles = (Get-ChildItem "$ProjectRoot/$($ENV:BHProjectName)" -Recurse -File -Filter *.ps1).FullName
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile" -CodeCoverage $CodeCoverageFiles -CodeCoverageOutputFile "$ProjectRoot\$CoverageFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If ($ENV:BHBuildSystem -eq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile" )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

Task Build -Depends Test {
    $lines

    If ($ENV:BHBuildSystem -eq 'AppVeyor') {
        # Load the module, read the exported functions, update the psd1 FunctionsToExport
        Set-ModuleFunctions
    }

    If ($ENV:BHBuildSystem -ne 'AppVeyor') {
        # Bump the module version
        Update-Metadata -Path $env:BHPSModuleManifest
    }
}

Task Deploy -Depends Build {
    $lines

    $Params = @{
        Path    = $ProjectRoot
        Force   = $true
        Recurse = $false # We keep psdeploy artifacts, avoid deploying those : )
    }
    Invoke-PSDeploy @Verbose @Params
}
'@

    ############################################################
    # appveyor.yml basic contents
    static [string]$AppVeyorBasic = @'


# See http://www.appveyor.com/docs/appveyor-yml for many more options

# Skip on updates to the readme.
# We can force this by adding [skip ci] or [ci skip] anywhere in commit message
skip_commits:
    message: /updated readme.*|update readme.*s/

# Don't use a build system, our test_script does that
build: false

# Kick off the CI/CD pipeline
test_script:
    - ps: . ./build.ps1


'@

    ############################################################
    # appveyor.yml PsGallery contents
    [string] AppVeyorPsGallery($ApiKey) {
        $ReturnString = @"
# Publish to PowerShell Gallery with this key
environment:
    NuGetApiKey:
    secure: $ApiKey
"@
        return $ReturnString
    }

    ############################################################
    # appveyor.yml Slack contents
    [string] AppVeyorSlack($ApiKey) {
        $ReturnString = @"
# Notify Slack
notifications:
- provider: Slack
    incoming_webhook:
    secure: $ApiKey
    on_build_success: true
    on_build_failure: true
    on_build_status_changed: true
"@
        return $ReturnString
    }

    # Constructor
    HelperStrings () {
    }
}