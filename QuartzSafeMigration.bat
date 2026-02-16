@echo off
chcp 65001 >nul
title Quartz v4 Minimal Clean Rebuild (Synology‑Safe)

echo.
echo ============================================
echo   Quartz v4 Minimal Clean Rebuild
echo ============================================
echo.

:: ---------------------------------------------------------
:: STEP 1 — Create clean working directory
:: ---------------------------------------------------------
set DEST=C:\Quartz\WestgateClean

echo Creating clean folder: %DEST%
if exist "%DEST%" rmdir /s /q "%DEST%"
mkdir "%DEST%"
echo ✔️  Clean folder created.
echo.

:: ---------------------------------------------------------
:: STEP 2 — Copy ONLY essential files (no recursion)
:: ---------------------------------------------------------
echo Copying essential project files...
copy "%~dp0quartz.config.ts" "%DEST%" >nul
copy "%~dp0quartz.layout.ts" "%DEST%" >nul
copy "%~dp0package.json" "%DEST%" >nul
copy "%~dp0package-lock.json" "%DEST%" >nul
copy "%~dp0tsconfig.json" "%DEST%" >nul
echo ✔️  Core files copied.
echo.

:: ---------------------------------------------------------
:: STEP 3 — Copy content folder using xcopy (safe)
:: ---------------------------------------------------------
echo Copying content folder...
xcopy "%~dp0content" "%DEST%\content" /E /I /H >nul
echo ✔️  Content copied.
echo.

:: ---------------------------------------------------------
:: STEP 4 — Initialize fresh Git repo
:: ---------------------------------------------------------
cd /d "%DEST%"
git init >nul
git remote add origin https://github.com/theo-blogical/WestgateSmallGroup.git
git checkout -b v4
echo ✔️  Git repo initialized.
echo.

:: ---------------------------------------------------------
:: STEP 5 — Install dependencies
:: ---------------------------------------------------------
echo Installing dependencies...
npm ci
if errorlevel 1 (
    echo ❌ npm ci failed.
    pause
    exit /b
)
echo ✔️  Dependencies installed.
echo.

:: ---------------------------------------------------------
:: STEP 6 — Install Quartz
:: ---------------------------------------------------------
echo Installing Quartz...
npm install quartz@latest
if errorlevel 1 (
    echo ❌ Quartz install failed.
    pause
    exit /b
)
echo ✔️  Quartz installed.
echo.

:: ---------------------------------------------------------
:: STEP 7 — Build Quartz
:: ---------------------------------------------------------
echo Building Quartz...
npx quartz build
if errorlevel 1 (
    echo ❌ Quartz build failed.
    pause
    exit /b
)
echo ✔️  Quartz build complete.
echo.

:: ---------------------------------------------------------
:: STEP 8 — Verify CSS exists
:: ---------------------------------------------------------
if not exist "%DEST%\public\index.css" (
    echo ❌ CSS missing — build incomplete.
    pause
    exit /b
)

echo ✔️  CSS found — layout restored.
echo.

:: ---------------------------------------------------------
:: STEP 9 — Commit + push
:: ---------------------------------------------------------
echo Committing and pushing...
git add -A
git commit -m "Clean Quartz rebuild"
git push -u origin v4 --force
echo ✔️  Push complete.
echo.

echo ============================================
echo   Clean rebuild complete!
echo   New working folder:
echo     %DEST%
echo ============================================
echo.
pause
exit /b