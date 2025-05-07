@echo off
setlocal enabledelayedexpansion
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"
set "SOFT_ROOT=d:\env_soft"

:: 服务定义（已移除 mqtt/emqx/modbus）
set "SERVICES[1].name=mysql"
set "SERVICES[1].display=MySQL服务"
set "SERVICES[1].service_name=ChengPinMySQL"

set "SERVICES[2].name=nginx"
set "SERVICES[2].display=Nginx服务"
set "SERVICES[2].service_name=nginx"

set "SERVICES[3].name=web"
set "SERVICES[3].display=Web服务"
set "SERVICES[3].service_name=cpWeb"


:menu
cls
echo.
echo ===== 一键部署管理菜单 =====
for /l %%i in (1,1,3) do (
    echo %%i. 安装 !SERVICES[%%i].display!
)
echo -----------------
echo 4. 查看所有服务状态
echo 5. 一键安装所有服务
echo 6. 一键卸载所有服务
echo 0. 退出
echo.
set /p choice=请输入操作序号 (0-6): 

if %choice% gtr 0 if %choice% leq 3 (
    call :install_service %choice%
    pause
    goto menu
)
if "%choice%"=="4" goto check_status
if "%choice%"=="5" goto install_all
if "%choice%"=="6" goto uninstall_all
if "%choice%"=="0" exit
echo 无效输入，请重新选择！ 
pause
goto menu


:check_status
echo.
echo ===== 服务状态检查 =====
for /l %%i in (1,1,3) do (
    sc query !SERVICES[%%i].service_name! >nul 2>&1
    if !errorlevel! equ 0 (
        echo [√] !SERVICES[%%i].display! 已安装
    ) else (
        echo [×] !SERVICES[%%i].display! 未安装
    )
)
pause
goto menu


:install_all
echo 正在安装所有服务...
for /l %%i in (1,1,3) do (
    call :auto_install_service %%i
)
goto menu


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


:install_service
echo.
echo [正在安装 !SERVICES[%1].display!...]
call "%~dp0install_!SERVICES[%1].name:~0,6!.bat"
if %errorlevel% equ 0 (
    echo [√] !SERVICES[%1].display! 安装成功
) else (
    echo [×] !SERVICES[%1].display! 安装失败，查看日志获取更多信息。
    pause
)
goto :eof


:uninstall_all
echo [!] 即将卸载所有服务...
for /l %%i in (1,1,3) do (
    call :uninstall_service !SERVICES[%%i].service_name! "!SERVICES[%%i].display!"
)
goto menu


:uninstall_service
echo.
echo [正在卸载 %2...]
net stop %1 >nul 2>&1
"%NSSM_PATH%" stop %1 >nul 2>&1 || echo (忽略停止失败)

:: 判断服务是否是 nssm 管理的服务
sc qc %1 >nul 2>&1
if %errorlevel% equ 1060 (
    echo 服务 %1 不存在，跳过...
) else (
    "%NSSM_PATH%" remove %1 confirm >nul 2>&1 || echo (忽略卸载失败)
    sc delete %1 >nul 2>&1 || echo (忽略删除失败)
)

sc query %1 >nul 2>&1
if %errorlevel% equ 1060 (
    echo [√] %2 已卸载
) else (
    echo [!] %2 卸载可能失败，请检查
)

goto :eof