function Send-LogDnaMessage {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $ApiKey,

        # TODO: need to ensure that message and or application fields do NOT contain restricted chars, specifically colons (:). also including words like "error" in non-error messages can get weird
        [Parameter(Mandatory = $true)]
        [string] $Message,

        [Parameter(Mandatory = $true)]
        [string] $Application,

        [Parameter(Mandatory = $true)]
        [ValidateSet('CRITICAL', 'DEBUG', 'EMERGENCY', 'ERROR', 'FATAL', 'INFO', 'SEVERE', 'TRACE', 'WARN')]
        [string] $Level,

        [Parameter(Mandatory = $true)]
        [string] $Environment
    )

    $Uri = 'https://logs.logdna.com/logs/ingest?'

    # Hostname, adds the localhost hostname if none specified
    if ($Hostname) {
        $Uri += 'hostname=' + $Hostname
    } else {
        $Uri += 'hostname=' + (hostname)
    }

    # Add ApiKey
    $Uri += '&apikey=' + $ApiKey

    $Uri += '&now=' + ([DateTimeOffset]::UtcNow).ToUnixTimeMilliseconds()

    $Body = @{}
    $Body.lines = @()
    $Body.lines += @{
        "line"  = $Message
        "app"   = $Application
        "level" = $Level
        "env"   = $Environment
    }
    $Body = $Body | ConvertTo-Json

    $WebParams = @{
        Method      = 'POST'
        Uri         = $Uri
        Body        = $Body
        ContentType = 'application/json'
    }

    $IngestStatus = Invoke-WebRequest @webparams -Verbose:$False

    $IngestStatus = $IngestStatus.Content | ConvertFrom-Json
    if ($IngestStatus.error) {
        Throw $IngestStatus.error
    }

    $true
}