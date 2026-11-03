param(
    [string] $ProductProject = (Join-Path $PSScriptRoot '../../../ehfleet_vb6guidll/EHWinFormViews/EHFleetXRechnung.Viewer.vbproj'),
    [ValidateSet('Overview','Report','Log')]
    [string] $CaptureKind = 'Overview'
)
$ErrorActionPreference = 'Stop'
$docsRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$productPath = (Resolve-Path -LiteralPath $ProductProject).Path
$folderName = switch ($CaptureKind) { 'Report' { 'report-host' } 'Log' { 'log-host' } default { 'screenshot-host' } }
$executable = switch ($CaptureKind) { 'Report' { 'ReportScreenshotHost.exe' } 'Log' { 'LogScreenshotHost.exe' } default { 'ScreenshotHost.exe' } }
$hostOutput = Join-Path $docsRoot ".qa/$folderName"
$hostProject = Join-Path $PSScriptRoot 'ScreenshotHost/ScreenshotHost.csproj'
dotnet restore $hostProject --source https://api.nuget.org/v3/index.json --ignore-failed-sources "-p:ProductProjectPath=$productPath"
if ($LASTEXITCODE -ne 0) { throw 'Abhängigkeiten fehlen; Produkt-Entwicklungsumgebung und Paketcache prüfen.' }
dotnet build $hostProject --no-restore -c Release -p:EnableComHosting=false "-p:ProductProjectPath=$productPath" "-p:CaptureKind=$CaptureKind" -o $hostOutput
if ($LASTEXITCODE -ne 0) { throw 'Screenshot-Host konnte nicht gebaut werden.' }
# Absichtlich sichtbares interaktives Fenster für die angeforderten Originalaufnahmen.
if ($CaptureKind -eq 'Report') {
    SqlLocalDB start EHFleetDocs | Out-Null
    $pipeLine = (SqlLocalDB info EHFleetDocs | Select-String -Pattern 'np:').Line
    $demoPipe = [regex]::Match($pipeLine, 'np:.*').Value.Trim()
    if (-not $demoPipe.StartsWith('np:\\.\pipe\LOCALDB#')) { throw 'Unerwartete Demo-Pipe' }
    [System.IO.File]::WriteAllText((Join-Path $hostOutput 'localdb-pipe.txt'), $demoPipe)
}
& (Join-Path $hostOutput $executable) $hostOutput
