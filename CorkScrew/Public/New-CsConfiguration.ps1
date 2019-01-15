function New-CsConfiguration {
    [CmdletBinding()]

    Param (
        [Parameter(ParameterSetName = "hash", Mandatory = $true, Position = 0)]
        [hashtable]$HashTable,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Path,

        [Parameter(ParameterSetName = "example", Mandatory = $true, Position = 0)]
        [string]$ExamplePath
    )

    BEGIN {
    }

    PROCESS {
        switch ($PsCmdlet.ParameterSetName) {
            'hash' {
                $ExportConfig = $HashTable | ConvertTo-Json -Depth 10
            }
            'example' {
                Write-Verbose "$VerbosePrefix checking that Path exists: $ExamplePath"
                try {
                    $ExamplePath = Resolve-Path -Path $ExamplePath -ErrorAction Stop
                } catch {
                    Throw "Path does not exist: $ExamplePath"
                }
                $ExportConfig = @{}
                $ExampleConfig = Get-CsConfiguration -Path $ExamplePath
                foreach ($key in $ExampleConfig.GetEnumerator()) {
                    $KeyName = $key.Name
                    $ExportConfig.$KeyName = Read-Host -Prompt $key.Value
                }
            }
        }
    }

    END {
        $ExportConfig | Out-File $Path
    }
}
