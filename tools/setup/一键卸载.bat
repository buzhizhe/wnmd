@echo off
setlocal enabledelayedexpansion
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"
set "SOFT_ROOT=d:\env_soft"

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



:uninstall_all
echo [!] 即将卸载所有服务...
echo.
set /p confirm=确认卸载所有服务？请输入 "yes" 确认，其他任意键取消: 
if /i not "%confirm%"=="yes" (
    echo 卸载已取消！
	pause
	exit /b
)

for /l %%i in (1,1,3) do (
    call :uninstall_service !SERVICES[%%i].service_name! "!SERVICES[%%i].display!"
)
pause
exit /b

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
