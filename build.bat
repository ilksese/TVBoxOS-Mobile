@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PARENT_DIR=%~dp0.."
set "BUILD_REPO=%PARENT_DIR%\MBox-Build"
set "KEYSTORE_SRC=%BUILD_REPO%\DIY\TVBoxOSC.jks"
set "KEYSTORE_DST=%SCRIPT_DIR%app\TVBoxOSC.jks"

echo ========================================
echo MBox 构建脚本 (Windows)
echo ========================================

rem 检查签名文件是否存在
if not exist "%KEYSTORE_SRC%" (
    echo [错误] 签名文件不存在: %KEYSTORE_SRC%
    echo 请确保 MBox-Build 仓库已克隆到父目录
    exit /b 1
)

rem 复制签名文件
echo [1/3] 复制签名文件...
copy /y "%KEYSTORE_SRC%" "%KEYSTORE_DST%" >nul

rem 构建 Debug APK
echo [2/3] 构建 Debug APK...
call gradlew.bat assembleDebug --no-daemon
if errorlevel 1 (
    echo [错误] Debug 构建失败
    del /f /q "%KEYSTORE_DST%" 2>nul
    exit /b 1
)

rem 构建 Release APK
echo [2/3] 构建 Release APK...
call gradlew.bat assembleRelease --no-daemon
if errorlevel 1 (
    echo [错误] Release 构建失败
    del /f /q "%KEYSTORE_DST%" 2>nul
    exit /b 1
)

rem 删除签名文件
echo [3/3] 清理签名文件...
del /f /q "%KEYSTORE_DST%" 2>nul

echo.
echo ========================================
echo 构建完成！
echo Debug:   app\build\outputs\apk\debug\MBox_v*.apk
echo Release: app\build\outputs\apk\release\MBox_v*.apk
echo ========================================

endlocal
pause
