function New-EncryptionKey {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [int]$Size = 32
    )

    BEGIN {
        $VerbosePrefix = "New-LtgEncryptionKey:"
    }

    PROCESS {
        Write-Verbose "Generating New Key"

        $AesKey = New-Object Byte[] $Size
        [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AesKey)
    }

    END {
        $AesKey
    }
}