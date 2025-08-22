param(
  [string]$DbName = 'delhi_metro'
)

# Ensure script stops on errors
$ErrorActionPreference = 'Stop'

# Ensure outputs directory exists
$outputsDir = Join-Path -Path (Get-Location) -ChildPath 'outputs'
if (-not (Test-Path $outputsDir)) { New-Item -ItemType Directory -Path $outputsDir | Out-Null }

$sqlDir = Join-Path -Path (Get-Location) -ChildPath 'sql'
$tempDir = Join-Path -Path $outputsDir -ChildPath '_tmp'
if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir | Out-Null }

$files = Get-ChildItem -Path $sqlDir -Filter *.sql | Sort-Object Name
if (-not $files) { Write-Error "No .sql files found in $sqlDir" }

foreach ($file in $files) {
  $inPath = $file.FullName
  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  $outPath = Join-Path -Path $outputsDir -ChildPath ("$baseName.txt")
  $tmpPath = Join-Path -Path $tempDir -ChildPath ("$baseName.postgres.sql")

  $sql = Get-Content -Raw -Path $inPath

  # Minimal compatibility fixes for Postgres
  # Replace SQLite strftime hour extraction with Postgres to_char
  $sql = $sql -replace "strftime\(\s*'%H'\s*,\s*trip_datetime\s*\)", "to_char(trip_datetime, 'HH24')"

  Set-Content -Path $tmpPath -Value $sql -NoNewline

  Write-Host "Running $($file.Name) -> outputs/$baseName.txt"
  psql -v ON_ERROR_STOP=1 -d "$DbName" -P pager=off -f "$tmpPath" -o "$outPath"
}

Write-Host "Done. Outputs saved in: $outputsDir"


