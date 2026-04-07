
# ============================================
# Setup Claude Code - Windows
# ============================================

Write-Host "Iniciando setup do ambiente..." -ForegroundColor Cyan

# 1. Git
Write-Host "`nInstalando Git..." -ForegroundColor Yellow
winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements

# 2. Claude Code
Write-Host "`nInstalando Claude Code..." -ForegroundColor Yellow
winget install Anthropic.ClaudeCode --accept-package-agreements --accept-source-agreements

# 3. GitHub CLI
Write-Host "`nInstalando GitHub CLI..." -ForegroundColor Yellow
winget install GitHub.cli --accept-package-agreements --accept-source-agreements

# 4. Cursor
Write-Host "`nInstalando Cursor..." -ForegroundColor Yellow
winget install Cursor.Cursor --accept-package-agreements --accept-source-agreements

# 5. Bun
Write-Host "`nInstalando Bun..." -ForegroundColor Yellow
winget install Oven-sh.Bun --accept-package-agreements --accept-source-agreements

# 6. Corrigir PATH do Claude Code
Write-Host "`nConfigurando PATH..." -ForegroundColor Yellow
$claudePath = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Anthropic.ClaudeCode_Microsoft.Winget.Source_8wekyb3d8bbwe"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*ClaudeCode*") {
    [Environment]::SetEnvironmentVariable("PATH", $currentPath + ";$claudePath", "User")
    Write-Host "PATH atualizado!" -ForegroundColor Green
} else {
    Write-Host "PATH ja configurado!" -ForegroundColor Green
}

# 7. Aliases estilo Mac no perfil do PowerShell
Write-Host "`nConfigurando aliases..." -ForegroundColor Yellow
$profileDir = Split-Path $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
}
if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Force -Path $PROFILE | Out-Null
}

$aliases = @'

# Aliases estilo Mac/Linux
Set-Alias ll Get-ChildItem
function ls { Get-ChildItem -Force }
function .. { cd .. }
function ... { cd ../.. }
function grep { Select-String $args }
function touch { New-Item -ItemType File -Name $args }
function which { Get-Command $args }
function open { explorer $args }
'@

Add-Content -Path $PROFILE -Value $aliases
Write-Host "Aliases configurados!" -ForegroundColor Green

# 8. Configurar Git
Write-Host "`nConfigurando Git..." -ForegroundColor Yellow
$nome = Read-Host "Digite seu nome completo"
$email = Read-Host "Digite seu email do GitHub"
git config --global user.name "$nome"
git config --global user.email "$email"
Write-Host "Git configurado!" -ForegroundColor Green

# 9. Login GitHub
Write-Host "`nFazendo login no GitHub..." -ForegroundColor Yellow
gh auth login

# Resumo
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Setup concluido!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "
Proximos passos:
1. Feche e reabra o terminal
2. Rode: claude (para fazer login no Claude Code)
3. Rode: gh auth status (para verificar GitHub)
" -ForegroundColor White
