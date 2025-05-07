@echo off
setlocal enabledelayedexpansion
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"

:: 服务定义
set "SERVICES[1].name=mysql"
set "SERVICES[1].display=MySQL服务"
set "SERVICES[1].service_name=ChengPinMySQL"

set "SERVICES[2].name=nginx"
set "SERVICES[2].display=Nginx服务"
set "SERVICES[2].service_name=nginx"

set "SERVICES[3].name=web"
set "SERVICES[3].display=Web服务"
set "SERVICES[3].service_name=cpWeb"

:install_all
echo 正在安装所有服务...
for /l %%i in (1,1,3) do (
    call :auto_install_service %%i
)
pause
exit /b

:auto_install_service
echo.
echo [正在安装 !SERVICES[%1].display!...]
call "%~dp0install_!SERVICES[%1].name:~0,6!.bat" auto
if %errorlevel% equ 0 (
    echo [√] !SERVICES[%1].display! 安装成功
) else (
    echo [×] !SERVICES[%1].display! 安装失败，查看日志获取更多信息。
    pause
)
goto :eof