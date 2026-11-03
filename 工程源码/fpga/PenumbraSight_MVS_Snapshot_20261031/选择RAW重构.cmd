@echo off
chcp 65001 >nul
set "PYTHONUTF8=1"
set "SNAPSHOT_ROOT=F:\fpga\PenumbraSight_MVS_Snapshot_20261031"
set "SNAPSHOT_PYTHONW=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\pythonw.exe"
if not exist "%SNAPSHOT_ROOT%\manual_gui.py" (
  echo ERROR: Manual app is missing.
  pause
  exit /b 1
)
if not exist "%SNAPSHOT_PYTHONW%" (
  echo ERROR: Python is missing.
  pause
  exit /b 1
)
cd /d "%SNAPSHOT_ROOT%"
if errorlevel 1 exit /b 1
start "" "%SNAPSHOT_PYTHONW%" "%SNAPSHOT_ROOT%\manual_gui.py"
