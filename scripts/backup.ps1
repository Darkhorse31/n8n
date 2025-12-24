# n8n Backup Script for Windows PowerShell
# Creates backups of PostgreSQL database and n8n data volume

$ErrorActionPreference = "Stop"

$BACKUP_DIR = ".\backups"
$DATE = Get-Date -Format "yyyyMMdd_HHmmss"
$DB_BACKUP = "$BACKUP_DIR\n8n_db_$DATE.sql"
$VOLUME_BACKUP = "$BACKUP_DIR\n8n_data_$DATE.tar.gz"

Write-Host "Starting n8n backup..." -ForegroundColor Green

# Create backup directory
New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null

# Backup PostgreSQL database
Write-Host "Backing up PostgreSQL database..." -ForegroundColor Yellow
docker-compose exec -T postgres pg_dump -U n8n n8n > $DB_BACKUP
Write-Host "Database backup saved to: $DB_BACKUP" -ForegroundColor Green

# Backup n8n data volume
Write-Host "Backing up n8n data volume..." -ForegroundColor Yellow
docker run --rm `
    -v n8n_data:/data `
    -v "${PWD}\${BACKUP_DIR}:/backup" `
    alpine tar czf "/backup/n8n_data_$DATE.tar.gz" /data
Write-Host "Volume backup saved to: $VOLUME_BACKUP" -ForegroundColor Green

# Remove backups older than 30 days
Write-Host "Cleaning old backups (older than 30 days)..." -ForegroundColor Yellow
Get-ChildItem -Path $BACKUP_DIR -Filter "n8n_*" -File | 
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | 
    Remove-Item -Force

Write-Host "Backup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To restore:" -ForegroundColor Cyan
Write-Host "  Database: Get-Content $DB_BACKUP | docker-compose exec -T postgres psql -U n8n n8n"
Write-Host "  Volume:   docker run --rm -v n8n_data:/data -v `${PWD}\${BACKUP_DIR}:/backup alpine tar xzf /backup/n8n_data_$DATE.tar.gz -C /"
