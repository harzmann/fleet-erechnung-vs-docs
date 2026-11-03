param(
    [string] $ProductProject = (Join-Path $PSScriptRoot '../../../ehfleet_vb6guidll/EHWinFormViews/EHFleetXRechnung.Viewer.vbproj')
)
$ErrorActionPreference = 'Stop'
$docsRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$productPath = (Resolve-Path -LiteralPath $ProductProject).Path
$hostOutput = Join-Path $docsRoot '.qa/screenshot-host'
$hostProject = Join-Path $PSScriptRoot 'ScreenshotHost/ScreenshotHost.csproj'
dotnet restore $hostProject --source https://api.nuget.org/v3/index.json --ignore-failed-sources "-p:ProductProjectPath=$productPath"
if ($LASTEXITCODE -ne 0) { throw 'Abhängigkeiten fehlen; Produkt-Entwicklungsumgebung und Paketcache prüfen.' }
dotnet build $hostProject --no-restore -c Release -p:EnableComHosting=false "-p:ProductProjectPath=$productPath" -o $hostOutput
if ($LASTEXITCODE -ne 0) { throw 'Screenshot-Host konnte nicht gebaut werden.' }
# Absichtlich sichtbares interaktives Fenster für die angeforderten Originalaufnahmen.
& (Join-Path $hostOutput 'ScreenshotHost.exe') $hostOutput
