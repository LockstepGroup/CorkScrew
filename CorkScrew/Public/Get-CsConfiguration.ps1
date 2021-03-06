function Get-CsConfiguration {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
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
        switch ($PSVersionTable.PSEdition) {
            'Core' {
                $ImportedContent = Get-Content -Path $Path -Raw | ConvertFrom-Json -AsHashtable
            }
            default {
                $ImportedContent = Get-Content -Path $Path -Raw | ConvertFrom-Json
            }
        }

    }

    END {
        $ImportedContent
    }
}
