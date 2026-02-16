@echo off
chcp 65001 >nul
title Quartz Utility Menu

:: -----------------------------------------
:: Resolve the project root (folder of this .bat)
:: -----------------------------------------
set PROJECT_ROOT=%~dp0
cd /d "%PROJECT_ROOT%"

:: Read current Git identity
for /f "delims=" %%A in ('git config user.name 2^>nul') do set GITUSER=%%A
for /f "delims=" %%A in ('git config user.email 2^>nul') do set GITEMAIL=%%A

:: Hard-coded identity
set EXPECTED_USER=theo-blogical
set EXPECTED_EMAIL=theoblogical@gmail.com

:menu
cls
echo.
echo ================================
echo   🪨 Quartz Project Utilities
echo ================================
echo.
echo   👤 Current Git Identity
echo   ------------------------
echo   🧑 user.name  : %GITUSER%
echo   📧 user.email : %GITEMAIL%
echo.
echo   🎯 Hard-Coded Identity (Will Apply)
echo   -----------------------------------
echo   🧑 user.name  : %EXPECTED_USER%
echo   📧 user.email : %EXPECTED_EMAIL%
echo.
echo   📋 Menu Options
echo   ------------------------
echo   1️⃣  Set LOCAL git config to theo-blogical
echo   2️⃣  Open Notepad
echo   3️⃣  (Removed — Quartz v3 sync)
echo   4️⃣  Refresh Git identity
echo   5️⃣  Run Quartz v4 build
echo   6️⃣  Rebuild public (build + force-add + commit + push)
echo   0️⃣  Exit
echo.
set /p choice="👉 Select an option: "

if "%choice%"=="1" goto setlocal
if "%choice%"=="2" goto notepad
if "%choice%"=="3" goto nosync
if "%choice%"=="4" goto refresh
if "%choice%"=="5" goto quartzbuild
if "%choice%"=="6" goto rebuildpublic
if "%choice%"=="0" goto end

echo ❌ Invalid choice. Try again.
pause
goto menu

:setlocal
echo.
echo ⚙️  Setting LOCAL git config to theo-blogical...
git config --local user.name "%EXPECTED_USER%"
git config --local user.email "%EXPECTED_EMAIL%"
echo ✔️  Local git identity updated.
pause
goto refresh

:notepad
echo.
echo 📝 Opening Notepad...
start notepad.exe
pause
goto menu

:nosync
echo.
echo ❌ Quartz v4 does not support 'quartz sync'.
echo    This option has been disabled.
pause
goto menu

:quartzbuild
echo.
echo 🏗️  Running Quartz v4 build...

cd /d "%PROJECT_ROOT%"
node quartz\bootstrap-cli.mjs build

echo.
echo ✔️  Build complete.
pause
goto menu

:rebuildpublic
echo.
echo 🏗️  Running Quartz v4 build...

pushd "%PROJECT_ROOT%"
node quartz\bootstrap-cli.mjs build

echo.
echo 📦  Force-adding public folder...
git add -A

echo.
echo 📝 Committing changes...
git commit -m "Rebuild public (Quartz v4 build + CSS/theme updates)"

echo.
echo 🚀 Pushing to GitHub...
git push

popd

echo.
echo ✔️  Public rebuild complete and deployed.
pause
goto menu

:refresh
echo.
echo 🔄 Refreshing Git identity...
for /f "delims=" %%A in ('git config user.name 2^>nul') do set GITUSER=%%A
for /f "delims=" %%A in ('git config user.email 2^>nul') do set GITEMAIL=%%A
echo ✔️  Updated.
pause
goto menu

:end
echo 👋 Goodbye.
exit