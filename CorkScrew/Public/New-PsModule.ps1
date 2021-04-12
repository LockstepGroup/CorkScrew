function New-PsModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Path = (Resolve-Path ./),

        [Parameter(Mandatory = $false)]
        [switch]$Force,

        [parameter(Mandatory = $false)]
        [string]$SecureNuGetApiKey = $global:SecureNuGetApiKey,

        [parameter(Mandatory = $false)]
        [string]$SecureSlackApiKey = $global:SecureSlackApiKey
    )

    BEGIN {
        $VerbosePrefix = "New-PsModule:"
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix checking that Path exists: $Path"
        try {
            $Path = Resolve-Path -Path $Path -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $Path"
        }

        Write-Verbose "$VerbosePrefix creating file structure"
        $RootPath = Join-Path -Path $Path -ChildPath $Name
        $VsCodePath = Join-Path -Path $RootPath -ChildPath '.vscode'
        $ModulePath = Join-Path -Path $RootPath -ChildPath $Name
        $DocsPath = Join-Path -Path $RootPath -ChildPath 'docs'
        $TestsPath = Join-Path -Path $RootPath -ChildPath 'Tests'

        # Create Root
        if (Test-Path $RootPath) {
            if ($Force) {
            } else {
                Throw "Path already exists: $Path. Use -Force to overwrite"
            }
        } else {
            Write-Verbose "$VerbosePrefix creating root directory"
            New-Item -Path $RootPath -ItemType Directory | Out-Null
        }

        # Create .vscode and apply settings
        Write-Verbose "$VerbosePrefix creating .vscode directory"
        New-Item -Path $VsCodePath -ItemType Directory | Out-Null
        [HelperStrings]::VsCodeSettings | Out-File (Join-Path -Path $VsCodePath -ChildPath 'settings.json')

        # Create Module Directory
        Write-Verbose "$VerbosePrefix creating module directory"
        New-Item -Path $ModulePath -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $ModulePath -ChildPath 'en-US') -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $ModulePath -ChildPath 'Classes') -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $ModulePath -ChildPath 'Private') -ItemType Directory | Out-Null
        New-Item -Path (Join-Path -Path $ModulePath -ChildPath 'Public') -ItemType Directory | Out-Null
        [HelperStrings]::Psm1File | Out-File (Join-Path -Path $ModulePath -ChildPath "$Name`.psm1")
        if ($global:NewModuleManifestParams) {
            $NewModuleManifestParams.Guid = New-Guid
            $NewModuleManifestParams.RootModule = $Name
            $NewModuleManifestParams.Path = (Join-Path -Path $ModulePath -ChildPath "$Name`.psd1")
            New-ModuleManifest @NewModuleManifestParams
        }

        # Create Tests directory
        New-Item -Path $TestsPath -ItemType Directory | Out-Null

        # Create docs directory
        New-Item -Path $DocsPath -ItemType Directory | Out-Null

        # Creating .gitignore
        [HelperStrings]::GitIgnore | Out-File (Join-Path -Path $RootPath -ChildPath ".gitignore")

        # Creating build.ps1
        [HelperStrings]::BuildPs1 | Out-File (Join-Path -Path $RootPath -ChildPath "build.ps1")

        # Creating deploy.psdeploy.ps1
        [HelperStrings]::PsDeploy | Out-File (Join-Path -Path $RootPath -ChildPath "deploy.psdeploy.ps1")

        # Creating LICENSE
        [HelperStrings]::LicenseMit | Out-File (Join-Path -Path $RootPath -ChildPath "LICENSE")

        # Creating psake.ps1
        [HelperStrings]::Psake | Out-File (Join-Path -Path $RootPath -ChildPath "psake.ps1")

        # Creating appveyor.yml PsGallery Settings
        $AppVeyorString = ""
        if ($SecureNuGetApiKey) {
            $HelperStrings = [HelperStrings]::new()
            $AppVeyorString += $HelperStrings.AppVeyorPsGallery($SecureNuGetApiKey)
        }

        $AppVeyorString += [HelperStrings]::AppVeyorBasic

        # Creating appveyor.yml Slack Settings
        if ($SecureSlackApiKey) {
            $HelperStrings = [HelperStrings]::new()
            $AppVeyorString += $HelperStrings.AppVeyorSlack($SecureSlackApiKey)
        }

        $AppVeyorString | Out-File (Join-Path -Path $RootPath -ChildPath "appveyor.yml")

        # Create README.md
        "# $Name" | Out-File (Join-Path -Path $RootPath -ChildPath "README.md")

    }

    END {
    }
}