@echo off
set VENV_NAME=.venv

echo Testing for Python...

:: 1. Try 'python' first, then 'py' as a backup
python --version >nul 2>&1
if %errorlevel% equ 0 (
    set PY_CMD=python
    goto :found
)

py --version >nul 2>&1
if %errorlevel% equ 0 (
    set PY_CMD=py
    goto :found
)

echo ERROR: Python not found! 
echo Please install Python 3.12 and check "Add Python to PATH"
pause
exit /b

:found
echo Using command: %PY_CMD%

:: 2. Create the venv if it doesn't exist
if not exist %VENV_NAME% (
    echo Creating virtual environment...
    %PY_CMD% -m venv %VENV_NAME%
)

:: 3. Install and Run
echo Installing/Updating libraries...
%VENV_NAME%\Scripts\python -m pip install -r requirements.txt

echo Starting Hand Tracker...
%VENV_NAME%\Scripts\python main.py
pause