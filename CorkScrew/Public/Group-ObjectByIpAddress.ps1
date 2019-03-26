function Group-ObjectByIpAddress {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $True)]
        [Alias('IpAddress')]
        [string]$Property,

        [Parameter(Mandatory = $false, ValueFromPipeline = $True)]
        [psobject]$InputObject
    )

    BEGIN {
        $VerbosePrefix = "Group-ObjectByIpAddress:"
        $ReturnObject = @()
        Write-Verbose "$VerbosePrefix InputObject Count: $($InputObject.Count)"
        Write-Verbose "$VerbosePrefix Property: $Property"
    }

    PROCESS {
        $ReturnObject += $InputObject | Select-Object -Property *, `
        @{ Name = 'DecimalIpAddressAddedByCorkScrew'; Expression = { ConvertTo-DecimalIP -IPAddress $_.$Property } }
    }

    END {
        $ReturnObject | Sort-Object -Property 'DecimalIpAddressAddedByCorkScrew' | Select-Object -Property * -ExcludeProperty DecimalIpAddressAddedByCorkScrew
    }
}
