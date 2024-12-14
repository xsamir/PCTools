@echo off

whoami /groups | find "S-1-5-32-544" >nul 2>&1
if errorlevel 1 (
    echo This script requires administrator privileges.
    pause
    exit /b
)

:menu
cls
color 0a
echo ==============================================
echo         RAM Cache Cleaner Script
echo ==============================================
echo.
echo 1. Set cache cleaning interval and start task
echo 2. Cancel the scheduled cleaning task
echo 3. Exit
echo ==============================================
set /p choice=Select an option [1-3]: 

if "%choice%"=="1" goto set_interval
if "%choice%"=="2" goto cancel_task
if "%choice%"=="3" exit

goto menu

:set_interval
cls
color 0e
set /p interval=Please enter the cache cleaning interval in minutes (e.g., 60 for 1 hour): 

if "%interval%"=="" goto set_interval
if not "%interval%" geq "1" goto set_interval

set /a interval_sec=%interval%*60
set task_name=RAMCacheCleaner
schtasks /query /tn %task_name% >nul 2>&1
if not errorlevel 1 (
    schtasks /delete /tn %task_name% /f
)

schtasks /create /tn %task_name% /tr "%~f0" /sc minute /mo %interval% /rl highest /f
if errorlevel 1 (
    echo Failed to create a scheduled task. Ensure you have administrative privileges.
    pause
    exit /b
)

cls
color 0a
echo ==============================================
echo Task successfully created.
echo The script will run automatically every %interval% minute(s).
echo ==============================================
pause
exit

:cancel_task
cls
color 0c
set task_name=RAMCacheCleaner
schtasks /query /tn %task_name% >nul 2>&1
if errorlevel 1 (
    echo No scheduled task found to cancel.
    pause
    goto menu
)

schtasks /delete /tn %task_name% /f
if errorlevel 1 (
    echo Failed to delete the scheduled task.
    pause
    goto menu
)

cls
color 0a
echo ==============================================
echo Scheduled cleaning task successfully canceled.
echo ==============================================
pause
goto menu
