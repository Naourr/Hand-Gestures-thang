@echo off
set VENV_NAME=.venv

:: 1. Trying to find the best Python version (3.12, 3.11, 3.10, or 3.9)
echo Checking Python versions...

py -3.12 -0 >nul 2>&1 && set PY_VER=-3.12 && goto :found
py -3.11 -0 >nul 2>&1 && set PY_VER=-3.11 && goto :found
py -3.10 -0 >nul 2>&1 && set PY_VER=-3.10 && goto :found
py -3.9 -0 >nul 2>&1 && set PY_VER=-3.9 && goto :found

echo ERROR: Compatible Python (3.9-3.12) not found!
echo Please install Python 3.12 from python.org.
pause
exit /b

:found
echo Found Python %PY_VER%!

:: 2. Create the venv if it doesn't exist
if not exist %VENV_NAME% (
    echo Creating virtual environment with %PY_VER%...
    py %PY_VER% -m venv %VENV_NAME%
)

:: 3. Install and Run
echo Updating libraries...
%VENV_NAME%\Scripts\python -m pip install --upgrade pip
%VENV_NAME%\Scripts\python -m pip install -r requirements.txt

echo Starting Hand Tracker...
%VENV_NAME%\Scripts\python main.py
pause