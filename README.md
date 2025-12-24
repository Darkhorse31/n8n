# n8n Docker Deployment

Complete Docker setup for deploying n8n workflow automation platform with PostgreSQL database.

## Features

- ✅ n8n latest version with workflow renderer
- ✅ PostgreSQL 15 database for persistent storage
- ✅ Docker Compose orchestration
- ✅ Volume mounts for data persistence
- ✅ Health checks for all services
- ✅ Basic authentication
- ✅ Encryption key support
- ✅ Custom nodes support
- ✅ Production-ready configuration

## Prerequisites

- Docker Engine 20.10+ 
- Docker Compose 2.0+
- At least 2GB RAM available
- Port 5678 available (or customize in .env)

## Quick Start

### 1. Clone and Setup

```bash
# Copy environment template
cp .env.example .env

# Generate encryption key (Windows PowerShell)
$key = -join ((48..57) + (97..102) | Get-Random -Count 64 | ForEach-Object {[char]$_})
Write-Host $key

# Or use online generator: https://www.random.org/strings/

# Edit .env and update:
# - POSTGRES_PASSWORD
# - N8N_BASIC_AUTH_USER
# - N8N_BASIC_AUTH_PASSWORD
# - N8N_ENCRYPTION_KEY (paste generated key)
```

### 2. Start Services

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f n8n

# Check status
docker-compose ps
```

### 3. Access n8n

Open your browser and navigate to:
- Local: `http://localhost:5678`
- Login with credentials from `.env`

## Configuration

### Environment Variables

Edit `.env` file to customize:

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_PASSWORD` | Database password | (required) |
| `N8N_PORT` | n8n port | 5678 |
| `N8N_BASIC_AUTH_USER` | Login username | admin |
| `N8N_BASIC_AUTH_PASSWORD` | Login password | (required) |
| `N8N_ENCRYPTION_KEY` | Encryption key | (required) |
| `TIMEZONE` | System timezone | UTC |
| `WEBHOOK_URL` | Webhook base URL | http://localhost:5678/ |

### Custom Nodes

Place custom nodes in `./custom-nodes/` directory. They will be automatically loaded.

### Workflow Backups

Workflows are stored in the database and n8n data volume. Export workflows manually or use the backup script.

## Production Deployment

### 1. Enable HTTPS with Nginx

Uncomment nginx service in `docker-compose.yml` and configure:

```bash
# Create SSL directory
mkdir nginx/ssl

# Add your SSL certificates
# nginx/ssl/cert.crt
# nginx/ssl/cert.key
```

Update `.env`:
```env
N8N_HOST=your-domain.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-domain.com/
```

### 2. Queue Mode (Multiple Workers)

For high-load environments, uncomment Redis service and update n8n environment:

```yaml
QUEUE_BULL_REDIS_HOST: redis
EXECUTIONS_MODE: queue
```

## Management Commands

### Start/Stop Services

```bash
# Start
docker-compose up -d

# Stop
docker-compose stop

# Restart
docker-compose restart

# Stop and remove
docker-compose down
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f n8n
docker-compose logs -f postgres
```

### Database Backup

```bash
# Backup
docker-compose exec postgres pg_dump -U n8n n8n > backup_$(Get-Date -Format "yyyyMMdd").sql

# Restore
Get-Content backup_20251224.sql | docker-compose exec -T postgres psql -U n8n n8n
```

### Update n8n

```bash
# Pull latest image
docker-compose pull n8n

# Restart with new image
docker-compose up -d n8n
```

## Volumes

Data is persisted in Docker volumes:

- `n8n_data`: n8n workflows, credentials, and settings
- `postgres_data`: PostgreSQL database

To backup volumes:
```bash
docker run --rm -v n8n_data:/data -v ${PWD}:/backup alpine tar czf /backup/n8n_backup.tar.gz /data
```

## Troubleshooting

### n8n won't start
- Check logs: `docker-compose logs n8n`
- Verify database is healthy: `docker-compose ps`
- Ensure encryption key is set in `.env`

### Can't access n8n
- Check if port 5678 is available: `netstat -an | findstr 5678`
- Verify container is running: `docker ps`
- Check firewall settings

### Database connection errors
- Ensure postgres container is running
- Verify credentials in `.env`
- Check network: `docker network ls`

### Reset Everything

```bash
# Stop and remove all containers, volumes
docker-compose down -v

# Start fresh
docker-compose up -d
```

## Security Recommendations

1. **Change default passwords** in `.env`
2. **Use strong encryption key** (32+ random characters)
3. **Enable HTTPS** for production
4. **Restrict port access** with firewall
5. **Regular backups** of database and volumes
6. **Keep Docker images updated**
7. **Use secrets management** for sensitive data

## Support

- n8n Documentation: https://docs.n8n.io/
- n8n Community: https://community.n8n.io/
- Docker Documentation: https://docs.docker.com/

## License

This deployment configuration is provided as-is. n8n is licensed under the Sustainable Use License and n8n Enterprise License.
