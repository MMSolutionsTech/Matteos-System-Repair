@echo off
title Matteo's System Repair and Health Checks
color 0A
mode con: cols=90 lines=35

:: Check for Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:MENU
cls
echo ============================================================
echo        Matteo's System Repair and Health Checks
echo ============================================================
echo.
echo   1. Run CHKDSK Scan Only
echo   2. Run CHKDSK Repair
echo   3. Run SFC /scannow
echo   4. Run DISM CheckHealth
echo   5. Run DISM ScanHealth
echo   6. Run DISM RestoreHealth
echo   7. Run Full Repair Sequence
echo   8. Exit
echo.
echo ============================================================
set /p choice="Choose an option: "

if "%choice%"=="1" goto CHKDSKSCAN
if "%choice%"=="2" goto CHKDSKREPAIR
if "%choice%"=="3" goto SFC
if "%choice%"=="4" goto DISMCHECK
if "%choice%"=="5" goto DISMSCAN
if "%choice%"=="6" goto DISMRESTORE
if "%choice%"=="7" goto FULL
if "%choice%"=="8" exit

echo.
echo Invalid choice.
pause
goto MENU

:CHKDSKSCAN
cls
echo Running CHKDSK scan...
echo.
chkdsk C: /scan
echo.
pause
goto MENU

:CHKDSKREPAIR
cls
echo Running CHKDSK repair...
echo.
echo NOTE: If C: is in use, Windows may schedule this for next reboot.
echo.
chkdsk C: /f
echo.
pause
goto MENU

:SFC
cls
echo Running SFC /scannow...
echo.
sfc /scannow
echo.
pause
goto MENU

:DISMCHECK
cls
echo Running DISM CheckHealth...
echo.
DISM /Online /Cleanup-Image /CheckHealth
echo.
pause
goto MENU

:DISMSCAN
cls
echo Running DISM ScanHealth...
echo.
DISM /Online /Cleanup-Image /ScanHealth
echo.
pause
goto MENU

:DISMRESTORE
cls
echo Running DISM RestoreHealth...
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
pause
goto MENU

:FULL
cls
echo Running Full Repair Sequence...
echo.

echo Step 1: CHKDSK Scan
chkdsk C: /scan
echo.
set /p found="Did CHKDSK find problems? (Y/N): "

if /I "%found%"=="Y" (
    echo.
    echo Running CHKDSK Repair...
    chkdsk C: /f
) else (
    echo.
    echo Skipping CHKDSK Repair...
)

echo.
echo Step 2: SFC Pass 1
sfc /scannow

echo.
echo Step 3: DISM CheckHealth
DISM /Online /Cleanup-Image /CheckHealth

echo.
echo Step 4: DISM ScanHealth
DISM /Online /Cleanup-Image /ScanHealth

echo.
echo Step 5: DISM RestoreHealth
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo Step 6: SFC Pass 2
sfc /scannow

echo.
echo ============================================================
echo Full repair sequence completed.
echo ============================================================
pause
goto MENU