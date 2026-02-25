@echo off
set VENV_NAME=.venv
title Hand Tracker Setup

echo ========================================
echo   HAND TRACKER AUTO-INSTALLER
echo ========================================

:: 1. Find Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    set PY_CMD=python
) else (
    py --version >nul 2>&1
    if %errorlevel% equ 0 (
        set PY_CMD=py
    ) else (
        echo ERROR: Python not found!
        echo Please install Python 3.12 from python.org and check "Add Python to PATH".
        pause
        exit /b
    )
)

:: 2. Check Version (3.9 to 3.12)
%PY_CMD% -c "import sys; v=sys.version_info; sys.exit(0 if (v.major==3 and 9<=v.minor<=12) else 1)"
if %errorlevel% neq 0 (
    echo ERROR: Incompatible Python version.
    %PY_CMD% --version
    echo Please use Python 3.9, 3.10, 3.11, or 3.12.
    pause
    exit /b
)
echo [OK] Python version is compatible.

:: 3. Create Virtual Environment
if not exist %VENV_NAME% (
    echo [..] Creating virtual environment...
    %PY_CMD% -m venv %VENV_NAME%
    echo [OK] Virtual environment created.
)

:: 4. Install Requirements
echo [..] Installing/Updating libraries (this may take a minute)...
%VENV_NAME%\Scripts\python -m pip install --quiet -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install libraries. Check your internet connection.
    pause
    exit /b
)
echo [OK] Libraries ready.

:: 5. Run the script
echo ========================================
echo   STARTING HAND TRACKER...
echo   (Press 'q' in the video window to exit)
echo ========================================
%VENV_NAME%\Scripts\python main.py

pause