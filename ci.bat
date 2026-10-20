@echo off
setlocal

cd /d "%~dp0"
if errorlevel 1 exit /b 1

if not exist build mkdir build
if errorlevel 1 exit /b 1

cd build
if errorlevel 1 exit /b 1

cmake ..
if errorlevel 1 exit /b 1

cmake --build . --config Release
if errorlevel 1 exit /b 1

ctest -C Release --output-on-failure
if errorlevel 1 exit /b 1

exit /b 0
