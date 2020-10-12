function Copy-PsObjectWithNewProperty {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        $PsObject,

        [Parameter(Mandatory = $True, Position = 1)]
        [string[]]$NewProperty
    )

    BEGIN {
        $VerbosePrefix = "Copy-PsObjectWithNewProperty:"
    }

    PROCESS {
        $Properties = ($PsObject | Get-Member -MemberType *Property).Name
        $AllProperties = $Properties + $NewProperty

        $ReturnObject = "" | Select-Object $AllProperties

        foreach ($property in $Properties) {
            $ReturnObject.$property = $PsObject.$property
        }
    }

    END {
        $ReturnObject
    }
}