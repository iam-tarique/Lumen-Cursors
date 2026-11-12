@echo off
setlocal
echo ==================================================
echo         Lumen Cursors Uninstaller (Windows)
echo ==================================================
echo.

:: Remove scheme from current user registry
echo Removing 'Lumen' cursor scheme from Registry...
reg delete "HKCU\Control Panel\Cursors\Schemes" /v "Lumen" /f >nul 2>&1

:: Remove cursor files from C:\Windows\Cursors\Lumen_Cursors
if exist "%SystemRoot%\Cursors\Lumen_Cursors" (
    echo Deleting cursor files from %SystemRoot%\Cursors\Lumen_Cursors...
    rmdir /s /q "%SystemRoot%\Cursors\Lumen_Cursors" >nul 2>&1
    if exist "%SystemRoot%\Cursors\Lumen_Cursors" (
        echo [!] Note: Some files could not be deleted.
        echo     Run this script as Administrator to remove system cursor files.
    ) else (
        echo Cursor files removed successfully.
    )
) else (
    echo Cursor files folder already removed.
)

echo.
echo ==================================================
echo Lumen Cursors has been uninstalled!
echo If Lumen is still active on your screen:
echo   1. Open Mouse Settings -> Pointers tab
echo   2. Switch Scheme to 'Windows Default' and click Apply.
echo ==================================================
echo.
pause
