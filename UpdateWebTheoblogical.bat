@echo off
chcp 65001 >nul
title Quartz Utility Menu

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
echo   3️⃣  Run npx quartz sync
echo   4️⃣  Refresh Git identity
echo   0️⃣  Exit
echo.
set /p choice="👉 Select an option: "

if "%choice%"=="1" goto setlocal
if "%choice%"=="2" goto notepad
if "%choice%"=="3" goto quartzsync
if "%choice%"=="4" goto refresh
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

:quartzsync
echo.
echo 🔄 Running Quartz sync...
npx quartz sync
echo ✔️  Sync complete.
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