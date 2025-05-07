@echo off
setlocal

set "SERVICE_NAME=nginx"
set "SERVICE_DISPLAY=ChengPinNginx"
set "SCRIPT_DIR=%~dp0"
set "NGINX_PATH=%SCRIPT_DIR%..\nginx1.28"
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"

:: 去掉路径结尾多余反斜杠
if "%NGINX_PATH:~-1%"=="\" set "NGINX_PATH=%NGINX_PATH:~0,-1%"

:: 检查管理员权限
net session >nul 2>&1 || (
    echo 请以管理员身份运行！
    pause
    exit /b
)
:: 如果是自动模式，跳过交互式菜单
if "%1"=="auto" goto install

:menu
cls
echo.
echo ===== Nginx 服务管理 =====
echo 1. 安装服务
echo 2. 卸载服务
echo 3. 返回主菜单
echo.
set /p choice=请选择 (1-3): 

if "%choice%"=="1" goto install
if "%choice%"=="2" goto uninstall
if "%choice%"=="3" exit /b
echo 无效输入
pause
goto menu

:install
echo 正在安装 Nginx 服务...

:: 检查 nginx.exe
if not exist "%NGINX_PATH%\nginx.exe" (
    echo [×] 错误：未找到 nginx.exe，请检查路径：%NGINX_PATH%
    pause
    goto menu
)

:: 确保 logs 目录存在
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

"%NSSM_PATH%" install "%SERVICE_NAME%" "%NGINX_PATH%\nginx.exe"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppDirectory "%NGINX_PATH%"
"%NSSM_PATH%" set "%SERVICE_NAME%" DisplayName "%SERVICE_DISPLAY%"
"%NSSM_PATH%" set "%SERVICE_NAME%" Description "Nginx代理服务器"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStdout "%LOG_DIR%\nginx.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStderr "%LOG_DIR%\nginx_error.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" Start SERVICE_AUTO_START

:: 启动服务
net start "%SERVICE_NAME%"
if %errorlevel% equ 0 (
    echo [√] Nginx 安装成功！访问 http://localhost 测试
) else (
    echo [×] 启动失败！检查 %LOG_DIR%\nginx_error.log
)
:: 如果是自动模式，跳过交互式菜单
if "%1"=="auto" exit /b
pause
goto menu

:uninstall
echo 正在卸载 Nginx 服务...
net stop "%SERVICE_NAME%" 2>nul
"%NSSM_PATH%" remove "%SERVICE_NAME%" confirm
echo [√] 已卸载 Nginx 服务
pause
goto menu
