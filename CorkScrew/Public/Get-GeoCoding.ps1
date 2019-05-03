function Get-GeoCoding {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ValueFromPipeLine = $true, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [string]$Address
    )

    BEGIN {
        $VerbosePrefix
        $BaseUri = 'https://nominatim.openstreetmap.org/search?format=json&q='
        $ReturnObject = @()
    }

    PROCESS {
        $Uri = $BaseUri + $Address
        $Response = Invoke-RestMethod -Uri $Uri

        $New = "" | Select-Object 'PlaceId', 'OsmType', 'OsmId', 'BoundingBox', 'Latitude', 'Longitude', 'DisplayName', 'Class', 'Type', 'Importance'
        $ReturnObject += $New

        $New.PlaceId = $Response.place_id
        $New.OsmType = $Response.osm_type
        $New.OsmId = $Response.osm_id
        $New.BoundingBox = $Response.boundingbox
        $New.Latitude = $Response.lat
        $New.Longitude = $Response.lon
        $New.DisplayName = $Response.display_name
        $New.Class = $Response.class
        $New.Type = $Response.type
        $New.Importance = $Response.importance
    }

    END {
        $ReturnObject
    }
}
