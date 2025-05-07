@echo off
setlocal

:: 定义基本参数
set "SCRIPT_DIR=%~dp0"
set "MYSQL_HOME=%SCRIPT_DIR%..\mysql8"
set "SERVICE_NAME=ChengPinMySQL"
set "MYSQL_INI=%MYSQL_HOME%\my.ini"
set "MYSQLD_EXE=%MYSQL_HOME%\bin\mysqld.exe"

:: 去掉路径结尾多余反斜杠
if "%MYSQL_HOME:~-1%"=="\" set "MYSQL_HOME=%MYSQL_HOME:~0,-1%"
:: 如果是自动模式，跳过交互式菜单
if "%1"=="auto" goto install

:menu
cls
echo.
echo ===== MySQL服务管理 =====
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
echo 正在安装 MySQL 服务...
:: 检查 mysqld.exe
if not exist "%MYSQLD_EXE%" (
    echo [×] 错误：未找到 mysqld.exe，请检查路径：%MYSQLD_EXE%
    pause
    goto menu
)

:: 检查 my.ini
if not exist "%MYSQL_INI%" (
    echo [×] 错误：未找到 my.ini 配置文件，请检查路径：%MYSQL_INI%
    pause
    goto menu
)

:: 安装 MySQL 服务
"%MYSQLD_EXE%" --install %SERVICE_NAME% --defaults-file="%MYSQL_INI%"

:: 检查安装是否成功
if %errorlevel% equ 0 (
    echo [√] MySQL 服务已成功注册
) else (
    echo [×] MySQL 服务注册失败，请检查错误信息
    pause
    goto menu
)

:: 启动 MySQL 服务
net start %SERVICE_NAME%
if %errorlevel% equ 0 (
    echo [√] MySQL 服务已成功启动
) else (
    echo [×] MySQL 服务启动失败，请手动检查
)
:: 如果是自动模式，跳过交互式菜单
if "%1"=="auto" exit /b
pause
goto menu

:uninstall
echo 正在卸载 MySQL 服务...

:: 停止服务
net stop %SERVICE_NAME% >nul 2>&1

:: 删除服务
sc delete %SERVICE_NAME% >nul 2>&1

:: 检查是否真的卸载
sc query %SERVICE_NAME% >nul 2>&1
if %errorlevel% equ 1060 (
    echo [√] MySQL 服务已成功卸载
) else (
    echo [×] MySQL 服务卸载失败，请手动检查
)

pause
goto menu
