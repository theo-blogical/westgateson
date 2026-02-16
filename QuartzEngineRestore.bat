@echo off
title Quartz Engine Restore (SMB Safe Version)
echo.
echo ============================================
echo   QUARTZ ENGINE RESTORE (SMB SAFE VERSION)
echo ============================================
echo.
echo This script will:
echo   1. Delete the existing quartz/ engine folder
echo   2. Reinstall Quartz cleanly
echo   3. Rebuild your site
echo   4. Pause after each step
echo.
pause

echo.
echo STEP 1: Deleting old Quartz engine folder...
echo --------------------------------------------
if exist quartz (
    rmdir /S /Q quartz
    echo Deleted quartz/ folder.
) else (
    echo quartz/ folder not found. Skipping delete.
)
pause

echo.
echo STEP 2: Installing Quartz engine...
echo --------------------------------------------
npm install quartz@latest
echo.
echo Quartz install complete.
pause

echo.
echo STEP 3: Building Quartz site...
echo --------------------------------------------
npx quartz build
echo.
echo Build complete.
pause

echo.
echo STEP 4: Git add/commit/push
echo --------------------------------------------
echo Press any key to stage all changes...
pause >nul
git add -A

echo Press any key to commit...
pause >nul
git commit -m "Restore Quartz engine from SMB"

echo Press any key to push to GitHub...
pause >nul
git push

echo.
echo ============================================
echo   ALL DONE — Quartz engine restored!
echo ============================================
echo.
pause