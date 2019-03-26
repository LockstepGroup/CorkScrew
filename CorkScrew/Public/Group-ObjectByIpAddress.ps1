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
        $ReturnObject = @()
    }

    PROCESS {
        $ReturnObject += $InputObject | Select-Object -Property *, `
        @{ Name = 'DecimalIpAddressAddedByCorkScrew'; Expression = { ConvertTo-DecimalIP -IPAddress $_.$Property } }
    }

    END {
        $InputObjectWithDecimalIp | Sort-Object -Property 'DecimalIpAddressAddedByCorkScrew' | Select-Object -Property * -ExcludeProperty DecimalIpAddressAddedByCorkScrew
    }
}
