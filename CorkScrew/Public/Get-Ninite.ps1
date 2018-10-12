function Get-Ninite {
    [CmdletBinding()]
    Param()

    DynamicParam {
        $NiniteUrl = "https://ninite.com/"
        $NiniteExe = "ninite.exe"
        try {
            $ThisOS = (Get-Item -Path env:os -ErrorAction Stop).Value     # did it this way so I could Mock Get-Item with Pester
        } catch {
            $ThisOS = $null
        }
        if ($ThisOS -eq 'Windows_NT') {
            $LocalSavePath = Join-Path $env:TEMP $NiniteExe
        }
        $Regex = [regex]'(?<=type="checkbox" class="js-homepage-app-checkbox" name="apps" value=")[^\"]+(?=")'

        try {
            $WebClient = New-Object System.Net.WebClient
            $DataSource = $WebClient.DownloadString($NiniteUrl)
        } catch {
            Write-Error "Unable to contact URL $NiniteUrl to pull application list."
            return $false
        }

        $ValidApps = $Regex.Matches($DataSource) | Select-Object -ExpandProperty Value | Sort-Object

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Position = 0
        $ParameterAttribute.Mandatory = $false

        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $AttributeCollection.Add($ParameterAttribute)
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidApps)
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter('Apps', [string[]], $AttributeCollection)
        $ParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $ParameterDictionary.Add('Apps', $RuntimeParameter)

        return $ParameterDictionary
    }

    Process {
        try {
            $ThisOS = (Get-Item -Path env:os -ErrorAction Stop).Value     # did it this way so I could Mock Get-Item with Pester
        } catch {
            Throw "Ninite is only support on Windows."
        }
        if ($ThisOS -ne 'Windows_NT') {
            Throw "Ninite is only support on Windows."
        }

        if ($PSBoundParameters.Apps.Count -gt 0) {
            $DownloadUrl = $NiniteUrl + ( $PSBoundParameters.Apps -join '-' ) + "/" + $NiniteExe
            $DownloadUrl
            $WebClient.DownloadFile($DownloadUrl, $LocalSavePath)
            Invoke-Expression $LocalSavePath
        } else {
            $ValidApps
        }
    }
}

New-Alias -Name nn -Value Get-Ninite