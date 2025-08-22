$ErrorActionPreference = 'Stop'

param(
  [string]$DbName = 'delhi_metro'
)

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
  Write-Error 'psql not found. Install PostgreSQL client and add to PATH.'
}

Write-Host "Using database: $DbName"

psql -v ON_ERROR_STOP=1 -d "$DbName" -f "postgres/schema_postgres.sql"
psql -v ON_ERROR_STOP=1 -d "$DbName" -f "postgres/load_csv_postgres.sql"

# Outputs
psql -v ON_ERROR_STOP=1 -d "$DbName" -f "postgres/queries_postgres.sql" \ 
  -P pager=off -o "postgres/output_all.txt"

# Also export as CSV for selected queries
psql -v ON_ERROR_STOP=1 -d "$DbName" -c \
  ".\timing on" -c \
  "COPY (SELECT s.station_name, COUNT(*) AS total_trips FROM trips t JOIN stations s ON t.entry_station = s.station_id GROUP BY s.station_name ORDER BY total_trips DESC LIMIT 10) TO 'postgres/busiest_stations.csv' WITH (FORMAT csv, HEADER true)"

Write-Host 'Done. See postgres/output_all.txt and CSVs in postgres/.'


