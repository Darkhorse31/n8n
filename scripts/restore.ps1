# n8n Restore Script for Windows PowerShell
# Restores PostgreSQL database and n8n data volume from backups

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupDate
)

$ErrorActionPreference = "Stop"

$BACKUP_DIR = ".\backups"
$DB_BACKUP = "$BACKUP_DIR\n8n_db_$BackupDate.sql"
$VOLUME_BACKUP = "$BACKUP_DIR\n8n_data_$BackupDate.tar.gz"

# Check if backups exist
if (-not (Test-Path $DB_BACKUP)) {
    Write-Host "Error: Database backup not found: $DB_BACKUP" -ForegroundColor Red
    Write-Host ""
    Write-Host "Available backups:" -ForegroundColor Yellow
    Get-ChildItem -Path $BACKUP_DIR -Filter "n8n_db_*.sql" -ErrorAction SilentlyContinue | 
        ForEach-Object { $_.Name -replace 'n8n_db_', '' -replace '.sql', '' }
    exit 1
}

if (-not (Test-Path $VOLUME_BACKUP)) {
    Write-Host "Error: Volume backup not found: $VOLUME_BACKUP" -ForegroundColor Red
    exit 1
}

# Confirmation
$CONFIRM = Read-Host "This will overwrite existing data. Continue? (yes/no)"
if ($CONFIRM -ne "yes") {
    Write-Host "Restore cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host "Starting n8n restore..." -ForegroundColor Green

# Stop n8n service
Write-Host "Stopping n8n..." -ForegroundColor Yellow
docker-compose stop n8n

# Restore database
Write-Host "Restoring PostgreSQL database..." -ForegroundColor Yellow
docker-compose exec -T postgres psql -U n8n -c "DROP DATABASE IF EXISTS n8n;"
docker-compose exec -T postgres psql -U n8n -c "CREATE DATABASE n8n;"
Get-Content $DB_BACKUP | docker-compose exec -T postgres psql -U n8n n8n
Write-Host "Database restored from: $DB_BACKUP" -ForegroundColor Green

# Restore volume
Write-Host "Restoring n8n data volume..." -ForegroundColor Yellow
docker run --rm `
    -v n8n_data:/data `
    -v "${PWD}\${BACKUP_DIR}:/backup" `
    alpine sh -c "rm -rf /data/* && tar xzf /backup/n8n_data_$BackupDate.tar.gz -C /"
Write-Host "Volume restored from: $VOLUME_BACKUP" -ForegroundColor Green

# Start n8n
Write-Host "Starting n8n..." -ForegroundColor Yellow
docker-compose start n8n

Write-Host "Restore completed successfully!" -ForegroundColor Green
Write-Host "n8n should be accessible at http://localhost:5678" -ForegroundColor Cyan
