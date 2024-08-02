@echo off
setlocal enabledelayedexpansion

:: Check if argument is provided. will be file name of properties file
:: e.g. For DEV.properties, will input "read_properties.bat DEV"  

if "%~1"=="" (
    echo Usage: %0 PROPERTY_FILE_BASE_NAME
    exit /b 1
)

set "PROP_FILE=%~1.properties"

if not exist "%PROP_FILE%" (
    echo Property file %PROP_FILE% does not exist.
    exit /b 1
)

for /f "tokens=1,* delims==" %%a in ('type "%PROP_FILE%"') do (
	set "%%a=%%b"
)

:: Print out DB_HOST and DB_PORT
echo DB_HOST: %DB_HOST%
echo DB_PORT: %DB_PORT%
echo DB_USER: %DB_USER%
echo DB_PASS: %DB_PASS%

endlocal