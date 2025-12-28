# LinkedIn Auto-Apply Workflow - Quick Start Script
# Run this to set up and start the workflow

Write-Host "================================================" -ForegroundColor Cyan
Write-Host " LinkedIn Auto-Apply Workflow - Quick Setup" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "[1/8] Checking Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if .env file exists
Write-Host ""
Write-Host "[2/8] Checking environment configuration..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Write-Host "✗ .env file not found" -ForegroundColor Red
    Write-Host "Creating .env from template..." -ForegroundColor Yellow
    
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "✓ Created .env file from template" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  IMPORTANT: Edit .env file and add your:" -ForegroundColor Yellow
        Write-Host "   - OPENROUTER_API_KEY" -ForegroundColor Yellow
        Write-Host "   - N8N_BASIC_AUTH_PASSWORD" -ForegroundColor Yellow
        Write-Host "   - POSTGRES_PASSWORD" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Press any key after updating .env file..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } else {
        Write-Host "✗ .env.example template not found" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✓ .env file exists" -ForegroundColor Green
}

# Check for OpenRouter API key in .env
Write-Host ""
Write-Host "[3/8] Verifying OpenRouter API key..." -ForegroundColor Yellow
$envContent = Get-Content ".env" -Raw
if ($envContent -match "OPENROUTER_API_KEY=sk-or-v1-\w+") {
    Write-Host "✓ OpenRouter API key found" -ForegroundColor Green
} else {
    Write-Host "⚠️  OpenRouter API key not configured in .env" -ForegroundColor Yellow
    Write-Host "   Get your key from: https://openrouter.ai/keys" -ForegroundColor Cyan
    Write-Host "   Add it to .env: OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY" -ForegroundColor Cyan
}

# Create necessary directories
Write-Host ""
Write-Host "[4/8] Creating directories..." -ForegroundColor Yellow
$directories = @("workflows", "custom-nodes")
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✓ Created $dir directory" -ForegroundColor Green
    } else {
        Write-Host "✓ $dir directory exists" -ForegroundColor Green
    }
}

# Copy workflow file to workflows directory
Write-Host ""
Write-Host "[5/8] Copying workflow file..." -ForegroundColor Yellow
if (Test-Path "linkedin_auto_apply_workflow.json") {
    Copy-Item "linkedin_auto_apply_workflow.json" "workflows/" -Force
    Write-Host "✓ Workflow file copied to workflows directory" -ForegroundColor Green
} else {
    Write-Host "⚠️  linkedin_auto_apply_workflow.json not found" -ForegroundColor Yellow
    Write-Host "   You'll need to import it manually in n8n" -ForegroundColor Yellow
}

# Stop existing containers
Write-Host ""
Write-Host "[6/8] Stopping existing n8n containers..." -ForegroundColor Yellow
docker-compose down 2>$null
Write-Host "✓ Containers stopped" -ForegroundColor Green

# Start n8n
Write-Host ""
Write-Host "[7/8] Starting n8n..." -ForegroundColor Yellow
docker-compose up -d

# Wait for n8n to be ready
Write-Host ""
Write-Host "[8/8] Waiting for n8n to be ready..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
$ready = $false

while ($attempt -lt $maxAttempts -and -not $ready) {
    Start-Sleep -Seconds 2
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5678/healthz" -Method GET -TimeoutSec 2 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            $ready = $true
        }
    } catch {
        $attempt++
        Write-Host "." -NoNewline -ForegroundColor Gray
    }
}

Write-Host ""
if ($ready) {
    Write-Host "✓ n8n is ready!" -ForegroundColor Green
} else {
    Write-Host "⚠️  n8n is taking longer than expected to start" -ForegroundColor Yellow
    Write-Host "   Check logs with: docker logs n8n" -ForegroundColor Yellow
}

# Display summary
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host " Setup Complete!" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 n8n URL:" -ForegroundColor Green
Write-Host "   http://localhost:5678" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Default Credentials (from .env):" -ForegroundColor Green
Write-Host "   Username: admin" -ForegroundColor White
Write-Host "   Password: (check .env file)" -ForegroundColor White
Write-Host ""
Write-Host "📁 Next Steps:" -ForegroundColor Green
Write-Host "   1. Open http://localhost:5678 in your browser" -ForegroundColor White
Write-Host "   2. Login with credentials from .env" -ForegroundColor White
Write-Host "   3. Import linkedin_auto_apply_workflow.json" -ForegroundColor White
Write-Host "   4. Configure Gmail and Google Sheets credentials" -ForegroundColor White
Write-Host "   5. Update your profile in 'Load Profile & API Key' node" -ForegroundColor White
Write-Host "   6. Test the workflow manually" -ForegroundColor White
Write-Host "   7. Activate for automatic runs" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Green
Write-Host "   See LINKEDIN_AUTO_APPLY_SETUP.md for detailed setup" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Useful Commands:" -ForegroundColor Green
Write-Host "   View logs:    docker logs n8n -f" -ForegroundColor White
Write-Host "   Restart:      docker-compose restart n8n" -ForegroundColor White
Write-Host "   Stop:         docker-compose down" -ForegroundColor White
Write-Host "   Start:        docker-compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Ask if user wants to open browser
$openBrowser = Read-Host "Would you like to open n8n in your browser now? (y/n)"
if ($openBrowser -eq "y" -or $openBrowser -eq "Y") {
    Start-Process "http://localhost:5678"
    Write-Host "✓ Opening n8n in browser..." -ForegroundColor Green
}

Write-Host ""
Write-Host "Happy job hunting! 🚀" -ForegroundColor Cyan
Write-Host ""
