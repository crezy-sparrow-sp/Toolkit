@echo off
title JavaFX Toolkit Launcher - SP
cls
setlocal enabledelayedexpansion

set "PROJECT_DIR={your_project_folder_path}"
set "FX_LIB={your_javafx_lib_folder_path}"
@REM  you can copy and paste the path from any where also from downloads 

cd /d "%PROJECT_DIR%"
:menu
cls
echo ---------------------------------------
echo         JavaFX Toolkit Launcher        
echo ---------------------------------------
echo.

set /a INDEX=1

for %%f in (*.java) do (
    set "FILE[!INDEX!]=%%f"

    call :checkJavaFX "%%f"

    set "TYPE[!INDEX!]=!RET_TYPE!"

    echo [!INDEX!] %%f     !RET_TYPE!
    set /a INDEX+=1
)

goto :select

:checkJavaFX
set "RET_TYPE=Java"
findstr /i "javafx.application.Application" %~1 >nul 2>&1
set "ERR=!errorlevel!"
if !ERR! == 0 (
    set "RET_TYPE=JavaFX"
)
goto :eof

:select
echo.
set /p CHOICE="Enter number to run: "
echo.

set "SELECTED_FILE=!FILE[%CHOICE%]!"
set "SELECTED_TYPE=!TYPE[%CHOICE%]!"

@REM echo File: !SELECTED_FILE!
@REM echo Type: !SELECTED_TYPE!
@REM echo.

if not defined SELECTED_FILE (
    echo [ERROR] Invalid selection.
    pause
    exit /b
)

for %%x in (!SELECTED_FILE!) do set "CLASS=%%~nx"
set "CLASS=!CLASS:.java=!"

if "!SELECTED_TYPE!"=="JavaFX" (
    echo [INFO] Compiling JavaFX app...
    javac --module-path "!FX_LIB!" --add-modules javafx.controls,javafx.fxml "!SELECTED_FILE!"
    if !errorlevel! == 0 (
        echo [INFO] Running...
        java --module-path "!FX_LIB!" --add-modules javafx.controls,javafx.fxml !CLASS!
    ) else (
        echo [ERROR] Compilation failed.
    )
) else (
    echo [INFO] Compiling standard Java app...
    javac "!SELECTED_FILE!"
    if !errorlevel! == 0 (
        echo [INFO] Running...
        echo output :
        echo.
        echo.
        java !CLASS!
        echo.
        echo.
        echo [INFO] Finished running standard Java app.
        echo.
        echo.
    ) else (
        echo [ERROR] Compilation failed.
    )
)


echo press 0 to exit or any other key to continue
set /p CHOICE=""
if "%CHOICE%"=="0" (
    exit /b
) 
else (
    cls
    goto :menu
)
pause
