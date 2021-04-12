function New-EncryptedString {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$PlainTextString,

        [Parameter(Mandatory = $False, Position = 1)]
        [alias("Key")]
        [Array]$AesKey
    )

    BEGIN {
        $VerbosePrefix = "New-EncryptedString:"
    }

    PROCESS {
        $SecureString = $PlainTextString | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $AesKey
    }

    END {
        $SecureString
    }
}
