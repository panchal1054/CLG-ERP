@echo off
TITLE College ERP System - Server Launcher
color 0A

echo =====================================================================
echo                COLLEGE ERP SYSTEM - LAUNCHER
echo =====================================================================
echo.

cd /d "%~dp0"

:: 1. Ensure PHP is available (check PATH, fallback to XAMPP)
where php >nul 2>nul
if %errorlevel% neq 0 (
    if exist "C:\xampp\php\php.exe" (
        set "PATH=C:\xampp\php;%PATH%"
        echo [*] Added C:\xampp\php to PATH.
    ) else (
        echo [ERROR] PHP is not found in PATH or at C:\xampp\php\php.exe.
        echo Please ensure PHP is installed and accessible.
        pause
        exit /b 1
    )
)

:: 2. Check if MySQL is running (port 3306)
echo [*] Checking MySQL service...
powershell -Command "if (!(Test-NetConnection -ComputerName 127.0.0.1 -Port 3306 -InformationLevel Quiet)) { exit 1 }" >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] MySQL is not running on port 3306.
    echo [*] Attempting to start MySQL service...
    net start mysql >nul 2>nul
    timeout /t 2 >nul
    powershell -Command "if (!(Test-NetConnection -ComputerName 127.0.0.1 -Port 3306 -InformationLevel Quiet)) { exit 1 }" >nul 2>nul
    if %errorlevel% neq 0 (
        echo [WARNING] Could not connect to MySQL on port 3306.
        echo Please make sure MySQL is started in XAMPP Control Panel.
        echo.
    ) else (
        echo [*] MySQL service started successfully!
    )
) else (
    echo [*] MySQL is active and running.
)

:: 3. Prepare application environment
echo [*] Preparing application environment...
php artisan storage:link >nul 2>nul

:: 4. Open Default Browser
echo [*] Opening application in default browser...
start http://127.0.0.1:8000/login

echo.
echo =====================================================================
echo   Application URL: http://127.0.0.1:8000
echo   Default Password for ALL users: 123456
echo =====================================================================
echo   Key Logins:
echo   - Super Admin: admin@college.edu       (Pass: 123456)
echo   - Principal:   principal@college.edu   (Pass: 123456)
echo   - Faculty:     teacher1@erp.edu        (Pass: 123456 / Code: FAC-BCA-01)
echo   - Student:     student1@erp.edu        (Pass: 123456 / Roll: 101)
echo   - Parent:      suresh.parent@gmail.com (Pass: 123456)
echo   - Librarian:   librarian@college.edu   (Pass: 123456)
echo =====================================================================
echo   Server is running. Press Ctrl+C in this window to stop.
echo =====================================================================
echo.

php artisan serve --host=127.0.0.1 --port=8000

pause
