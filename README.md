# CorkScrew

Useful tools that I'm tired of writing over and over again.

## Current Cmdlets

* Write-CustomLog

## Planned Cmdlets

* Get-Uptime
* Get-OsVersion
* Get-UserSid
* Get-UsernameFromSid
* Translate-UserSid
* Get-LocalUsernameFromSid
* Invoke-NotepadPlusPlus (alias: npp)
* all of ipv4math
* Get-ElevationStatus
* Invoke-ElevatedProcess
* New-EncryptedString

## Contributing

### Creating a new Cmdlet

1. Create Test File in $ProjectRoot/Tests named YOUR-CMDLET-NAME.Test.ps1. Use the following as a template.

    ``` powershell
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

        Describe 'YOUR-CMDLET-NAME' {

        }
    }
    ```

1. Create your Cmdlet file in the appropriate directory.

    * $ProjectRoot/CorkScrew/Private: functions that will not be exposed to end users, would only be accessible inside other functions of the module.
    * $ProjectRoot/CorkScrew/Public: functions that will be exported by the module for end user consumption.
    Regardless of where you put the file, it should contain the following at minimum.

    ``` powershell
    function YOUR-CMDLET-NAME {
        [CmdletBinding()]
        Param (
        )
    }
    ```

1. Write your Code/Tests.
1. Using PlatyPS to write create your help files. There's good doc for this on github (https://github.com/PowerShell/platyPS), but here's a basic rundown.

    * Install platyPS Module from PSGallery

        ``` powershell
        Install-Module platyPS
        Import-Module platyPS
        ```

    * Create markdown help file (this will be what you can use for web-based documentation).

        ``` powershell
        Import-Module CorkScrew
        New-MarkdownHelp -Command YOUR-CMDLET-NAME -OutputFolder $ProjectRoot/docs
        ```

    * Edit the markdown file creates in $ProjectRoot/docs
    * Create External Help file from markdown.

        ``` powershell
        New-ExternalHelp -Path "$ProjectRoot/docs/YOUR-CMDLET-NAME.md" -OutputPath "$ProjectRoot/CorkScrew/en-US/"
        ```

    * If you change/add functionality to your cmdlet you can update it with the following. Note that this will update all help files for the module at the same time.

        ``` powershell
        Import-Module CorkScrew -Force
        Update-MarkdownHelp "$ProjectRoot/docs"
        New-ExternalHelp -Path "$ProjectRoot/docs" -OutputPath"$ProjectRoot/CorkScrew/en-US/"
        ```
1. Deploy the Module. We're using combination of PowerShell Modules (Psake, PSDeploy, Pester, BuildHelpers), AppVeyor, and Github to streamline testing and deployment of this module. Whenever a new commit is pushed to github, AppVeyor starts and automated "build" process. This isn't your typical build process like an application, as we don't need to compile anything. It does however, run through all tests, and depending on your options push the updated module to PSGallery or to a private NuGet repo for further testing. How you manage git is up to you, but here's a cli example.

    * Deploy to private NuGet Repo
        ``` bash
        git commit -am 'updated New-AwesomeCmdlet'
        git push
        ```

    * Deploy to PSGallery
        ``` bash
        git commit -am 'updated New-AwesomeCmdlet !deploy'
        git push
        ```
