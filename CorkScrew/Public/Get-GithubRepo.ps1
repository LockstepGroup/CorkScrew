function Get-GithubRepo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Owner,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Repository,

        [Parameter(Mandatory = $false)]
        [string]$TargetPath = (Get-Location).Path,

        [Parameter(ParameterSetName = "Credential", Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = $global:GithubCredential,

        [Parameter(Mandatory = $false)]
        [switch]$Release
    )

    Begin {
        $VerbosePrefix = "Get-GithubRepo:"
        try {
            $ResolvedTargetPath = Resolve-Path -Path $TargetPath -ErrorAction Stop
            $LocalFile = Join-Path -Path $ResolvedTargetPath -ChildPath "$Repository.zip"
            $ExtractDirectory = Join-Path -Path $ResolvedTargetPath -ChildPath $Repository
        } catch [System.Management.Automation.SessionStateException] {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([System.ArgumentException]"TargetPath not found."),
                    'TargetPathNotFound',
                    [System.Management.Automation.ErrorCategory]::CloseError,
                    $TargetPath
                )
            )
        }

        if ($Credential) {
            $NetworkCredential = $Credential.GetNetworkCredential()
            $Headers = @{
                Authorization = 'Basic ' + [System.Convert]::ToBase64String(
                    [System.Text.Encoding]::ASCII.GetBytes(
                        "$($NetworkCredential.UserName):$($NetworkCredential.Password)"
                    )
                )
            }
        } else {
            $Headers = @{}
        }

        # Legacy PowerShell config
        # Enable TLS1.2 for Invoke-WebRequest
        # Enable -UseBasicParsing for Invoke-WebRequest
        if ($global:PSVersionTable.PSEdition -ne 'Core') {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $InvokeWebRequestParams = @{ 'UseBasicParsing' = $true }
        } else {
            $InvokeWebRequestParams = @{}
        }

        $InitialUrl = 'https://api.github.com/repos/' + $Owner + "/" + $Repository
        try {
            $RepoInfo = Invoke-WebRequest -Uri $InitialUrl -Headers $Headers @InvokeWebRequestParams
        } catch {
            $ErrorMessage = ($_.ErrorDetails.Message | ConvertFrom-Json).message
            switch -Regex ($ErrorMessage) {
                'two-factor' {
                    $MfaCode = Read-Host -Prompt "Two-Factor Code" -AsSecureString
                    $Headers.'X-GitHub-OTP' = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($MfaCode))
                    $RepoInfo = (Invoke-WebRequest -Uri $InitialUrl -Headers $Headers @InvokeWebRequestParams).Content | ConvertFrom-Json
                    $global:RepoInfo = $RepoInfo
                    $Owner = $RepoInfo.full_name.Split('/')[0]
                    $Repository = $RepoInfo.full_name.Split('/')[1]
                    continue
                }
                default {
                    $PSCmdlet.ThrowTerminatingError(
                        [System.Management.Automation.ErrorRecord]::new(
                            ([System.ArgumentException]"URL not found. If this is a private repo, specify -Credential,"),
                            'RepoUrlNotFound',
                            [System.Management.Automation.ErrorCategory]::CloseError,
                            $InitialUrl
                        )
                    )
                }
            }

        }

        if ($Release) {
            $Url = $RepoInfo.releases_url -replace '{/id}', '/latest'
            try {
                # Get latest release zipfile url
                $LatestRelease = Invoke-WebRequest -Uri $Url -Headers $Headers @InvokeWebRequestParams
                $Content = ConvertFrom-Json $LatestRelease.Content
                $DownloadUrl = $Content.zipball_url
            } catch {
                $PSCmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        ([System.ArgumentException]"URL not found. If this is a private repo, specify -Credential,"),
                        'RepoUrlNotFound',
                        [System.Management.Automation.ErrorCategory]::CloseError,
                        $InitialUrl
                    )
                )
            }
        } else {
            $DownloadUrl = "https://github.com/" + $Owner + "/" + $Repository + "/archive/master.zip"
        }

    }

    Process {
        # Download zip file
        try {
            $DownloadFile = Invoke-WebRequest -Uri $DownloadUrl -OutFile $LocalFile -Headers $Headers @InvokeWebRequestParams
        } catch {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([System.ArgumentException]"URL not found. If this is a private repo, specify -Credential,"),
                    'RepoUrlNotFound',
                    [System.Management.Automation.ErrorCategory]::CloseError,
                    $InitialUrl
                )
            )
        }

        # Expand File
        Write-Verbose "Extracting Zip: $LocalFile -> $ExtractDirectory"
        Expand-Archive -Path $LocalFile -DestinationPath $ExtractDirectory


        # Move Files to root of targer directory
        $ExtraDirectory = $Repository + '-*'
        $ExtractedFolder = (Get-ChildItem -Path $ExtractDirectory -Filter $ExtraDirectory).FullName
        Write-Verbose "ExtractedFolder: $ExtractedFolder"
        $ExtractedDirectories = Get-ChildItem -Path $ExtractedFolder -Recurse -Directory
        foreach ($directory in $ExtractedDirectories) {
            $thisSource = $directory.FullName
            Write-Verbose "$VerbosePrefix checking for directory: $thisSource"
            $thisDestination = ($directory.FullName).Replace($ExtractedFolder, $ExtractDirectory)
            if (!(Test-Path -Path $thisDestination)) {
                New-Item -Path $thisDestination -ItemType Directory | Out-Null
            }
        }
        $ExtractedFiles = Get-ChildItem -Path $ExtractedFolder -Recurse -File
        foreach ($file in $ExtractedFiles) {
            $thisSource = $file.FullName
            $thisDestination = ($file.FullName).Replace($ExtractedFolder, $ExtractDirectory)
            $Move = Move-Item -Path $thisSource -Destination $thisDestination -Force
        }
        $RemoveExtraFolder = Remove-Item -Path $ExtractedFolder -Recurse -Force

        # Delete zip file
        Remove-Item -Path $LocalFile | Out-Null

    }
}

New-Alias -Name ggh -Value Get-GithubRepo