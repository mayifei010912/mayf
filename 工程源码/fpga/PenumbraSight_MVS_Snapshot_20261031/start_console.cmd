@echo off
chcp 65001 >nul
set "PYTHONUTF8=1"
set "SNAPSHOT_ROOT=F:\fpga\PenumbraSight_MVS_Snapshot_20261031"
set "SNAPSHOT_PYTHON=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
if not exist "%SNAPSHOT_ROOT%\app.py" (
  echo ERROR: Program missing: "%SNAPSHOT_ROOT%\app.py"
  pause
  exit /b 1
)
if not exist "%SNAPSHOT_PYTHON%" (
  echo ERROR: Python missing: "%SNAPSHOT_PYTHON%"
  pause
  exit /b 1
)
cd /d "%SNAPSHOT_ROOT%"
if errorlevel 1 (
  echo ERROR: Cannot open program folder.
  pause
  exit /b 1
)
"%SNAPSHOT_PYTHON%" -u "%SNAPSHOT_ROOT%\app.py"
if errorlevel 1 pause
