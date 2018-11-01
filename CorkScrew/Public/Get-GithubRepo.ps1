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
        try {
            $ResolvedTargetPath = Resolve-Path -Path $TargetPath
            $LocalFile = Join-Path -Path $ResolvedTargetPath -ChildPath "$Repository.zip"
            $ExtractDirectory = Join-Path -Path $ResolvedTargetPath -ChildPath $Repository
        } catch [System.Management.Automation.SessionStateException] {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([ItemNotFoundException]"TargetPath not found."),
                    'TargetPathNotFound',
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
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

        $InitialUrl = 'https://api.github.com/repos/' + $Owner + "/" + $Repository
        try {
            $RepoInfo = Invoke-WebRequest -Uri $InitialUrl -Headers $Headers
        } catch [System.Net.Http.HttpRequestException] {
            $ErrorMessage = ($_.ErrorDetails.Message | ConvertFrom-Json).message
            switch -Regex ($ErrorMessage) {
                'two-factor' {
                    $MfaCode = Read-Host -Prompt "Two-Factor Code" -AsSecureString
                    $Headers.'X-GitHub-OTP' = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($MfaCode))
                    $RepoInfo = (Invoke-WebRequest -Uri $InitialUrl -Headers $Headers).Content | ConvertFrom-Json
                    $global:RepoInfo = $RepoInfo
                    $Owner = $RepoInfo.full_name.Split('/')[0]
                    $Repository = $RepoInfo.full_name.Split('/')[1]
                    continue
                }
                default {
                    $PSCmdlet.ThrowTerminatingError(
                        [System.Management.Automation.ErrorRecord]::new(
                            ([System.Net.Http.HttpRequestException]"URL not found. If this is a private repo, specify -Credential,"),
                            'RepoUrlNotFound',
                            [System.Management.Automation.ErrorCategory]::InvalidOperation,
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
                $LatestRelease = Invoke-WebRequest -Uri $Url -Headers $Headers
                $Content = ConvertFrom-Json $LatestRelease.Content
                $DownloadUrl = $Content.zipball_url
            } catch {
                $PSCmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        ([System.Net.Http.HttpRequestException]"URL not found. If this is a private repo, specify -Credential,"),
                        'RepoUrlNotFound',
                        [System.Management.Automation.ErrorCategory]::InvalidOperation,
                        $Url
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
            $DownloadFile = Invoke-WebRequest -Uri $DownloadUrl -OutFile $LocalFile -Headers $Headers
        } catch [System.Net.Http.HttpRequestException] {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([System.Net.Http.HttpRequestException]"URL not found. If this is a private repo, specify -Credential,"),
                    'RepoUrlNotFound',
                    [System.Management.Automation.ErrorCategory]::InvalidOperation,
                    $Url
                )
            )
        }

        # Expand File
        Expand-Archive -Path $LocalFile -DestinationPath $ExtractDirectory

        # Move Files to root of targer directory
        $ExtraDirectory = $Repository + '-*'
        $ExtractedFolder = (Get-ChildItem -Path $ExtractDirectory -Filter $ExtraDirectory).FullName
        $Move = Move-Item -Path "$ExtractedFolder/*" -Destination $ExtractDirectory
        $RemoveExtraFolder = Remove-Item -Path $ExtractedFolder -Recurse -Force

    }
}

New-Alias -Name ggh -Value Get-GithubRepo