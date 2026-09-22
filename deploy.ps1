# One button: build APK + push to GitHub
# VS Code: Ctrl+Shift+B  or  powershell -ExecutionPolicy Bypass -File deploy.ps1
# Custom message: .\deploy.ps1 -Message "feat: something"

param([string]$Message = "")

$ErrorActionPreference = "Stop"

# Find gui folder dynamically (avoids hardcoding Cyrillic+CJK chars)
$src = $null
$raw = [System.IO.Directory]::GetDirectories("c:\Users\kosty\Desktop")
foreach ($d in $raw) {
  if (Test-Path (Join-Path $d "gui\pubspec.yaml")) {
    $src = Join-Path $d "gui"
    break
  }
}
if (-not $src) { throw "Cannot find gui folder under Desktop" }

$tmp = "c:\temp\gui_build"
$apkSrc = "$tmp\build\app\outputs\flutter-apk\app-release.apk"
$parentDir = [System.IO.Directory]::GetParent($src).FullName
$apkDst = Join-Path $parentDir "Nexora.apk"

Write-Host "Source: $src" -ForegroundColor DarkGray
Write-Host "APK destination: $apkDst" -ForegroundColor DarkGray

# --- Step 1: build APK ---
Write-Host "1/4 Copying project to $tmp ..." -ForegroundColor Cyan
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
Copy-Item $src $tmp -Recurse
if (Test-Path "$tmp\build") { Remove-Item "$tmp\build" -Recurse -Force }
if (Test-Path "$tmp\.vscode") { Remove-Item "$tmp\.vscode" -Recurse -Force }

Write-Host "2/4 Building APK (flutter build apk --release) ..." -ForegroundColor Cyan
Push-Location $tmp
& C:\src\flutter\bin\flutter.bat build apk --release
if ($LASTEXITCODE -ne 0) { Pop-Location; throw "Build failed with code $LASTEXITCODE" }
Pop-Location

Write-Host "3/4 Copying APK ..." -ForegroundColor Cyan
Copy-Item $apkSrc $apkDst -Force
$size = [math]::Round((Get-Item $apkDst).Length / 1MB, 2)
Write-Host "Done: Nexora.apk ($size MB)" -ForegroundColor Green

# --- Step 2: push to GitHub ---
Push-Location $src
try {
  $staged = git diff --cached --name-only
  $unstaged = git diff --name-only
  $untracked = git ls-files --others --exclude-standard
  $hasChanges = ($staged -or $unstaged -or $untracked)

  if ($hasChanges) {
    if (-not $Message) {
      $ts = (Get-Date).ToString('yyyy-MM-dd HH:mm')
      $Message = Read-Host "Commit message (Enter = feat: update $ts)"
      if (-not $Message) { $Message = "feat: update $ts" }
    }
    Write-Host "4/4 Commit + push: $Message" -ForegroundColor Cyan
    git add -A
    git commit -m $Message
  } else {
    Write-Host "4/4 No changes, pushing ..." -ForegroundColor Cyan
  }

  git push origin main
  Write-Host "Pushed to origin/main" -ForegroundColor Green
} finally {
  Pop-Location
}

Write-Host "All done!" -ForegroundColor Green
