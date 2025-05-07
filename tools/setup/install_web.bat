@echo off
setlocal

:: 统一路径定义
set "SCRIPT_DIR=%~dp0"
set "SOFT_ROOT=%SCRIPT_DIR%.."
set "WEB_ROOT=%SOFT_ROOT%\..\web"
set "DOTNET_PATH=%SOFT_ROOT%\dotnet8\dotnet.exe"
set "NSSM_PATH=%~dp0nssm.exe"
set "SERVICE_NAME=cpWeb"
set "SERVICE_DISPLAY=ChengPinWeb"
set "LOG_DIR=%~dp0logs"

:: 去掉路径尾部反斜杠
if "%SOFT_ROOT:~-1%"=="\" set "SOFT_ROOT=%SOFT_ROOT:~0,-1%"
if "%WEB_ROOT:~-1%"=="\" set "WEB_ROOT=%WEB_ROOT:~0,-1%"

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
echo ===== .NET Web 服务管理 =====
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
echo 正在安装 Web 服务...

:: 检查关键文件
if not exist "%DOTNET_PATH%" (
    echo [×] 错误：未找到 dotnet.exe，请检查路径 %DOTNET_PATH%
    pause
    goto menu
)

if not exist "%NSSM_PATH%" (
    echo [×] 错误：未找到 nssm.exe，请检查路径 %NSSM_PATH%
    pause
    goto menu
)

if not exist "%WEB_ROOT%\API.dll" (
    echo [×] 错误：未找到 API.dll，请检查路径 %WEB_ROOT%
    pause
    goto menu
)

:: 确保日志目录存在
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

:: 停止并移除旧服务
echo 正在清理旧服务...
net stop "%SERVICE_NAME%" >nul 2>&1
"%NSSM_PATH%" remove "%SERVICE_NAME%" confirm >nul 2>&1

:: 安装新服务
echo 正在注册服务...
"%NSSM_PATH%" install "%SERVICE_NAME%" "%DOTNET_PATH%" "API.dll --urls http://localhost:5000"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppDirectory "%WEB_ROOT%"
"%NSSM_PATH%" set "%SERVICE_NAME%" DisplayName "%SERVICE_DISPLAY%"
"%NSSM_PATH%" set "%SERVICE_NAME%" Description "ASP.NET Core 站点"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStdout "%LOG_DIR%\web.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStderr "%LOG_DIR%\web-error.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" Start SERVICE_AUTO_START

:: 启动服务
echo 正在启动 Web 服务...
net start "%SERVICE_NAME%"

if %errorlevel% equ 0 (
    echo [√] Web 服务安装成功！访问 http://localhost:5000 测试
    echo 日志文件目录：%LOG_DIR%
) else (
    echo [×] 启动失败，请检查日志！
)
:: 如果是自动模式，跳过交互式菜单
if "%1"=="auto" exit /b
 pause
goto menu

:uninstall
echo 正在卸载 Web 服务...
net stop "%SERVICE_NAME%" 2>nul
"%NSSM_PATH%" remove "%SERVICE_NAME%" confirm
echo [√] 已卸载 Web 服务
pause
goto menu
