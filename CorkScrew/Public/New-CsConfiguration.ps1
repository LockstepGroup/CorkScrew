function New-CsConfiguration {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [hashtable]$HashTable,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Path
    )

    BEGIN {
        Write-Verbose "$VerbosePrefix checking that Path exists: $Path"
        try {
            $Path = Resolve-Path -Path $Path -ErrorAction Stop
        } catch {
            Throw "Path does not exist: $Path"
        }
    }

    PROCESS {
        $ExportConfig = $HashTable | ConvertTo-Json -Depth 10
    }

    END {
        $ExportConfig | Out-File $Path
    }
}
