@echo off
setlocal

set "SERVICE_NAME=nginx"
set "SERVICE_DISPLAY=ChengPinNginx"
set "SCRIPT_DIR=%~dp0"
set "NGINX_PATH=%SCRIPT_DIR%..\nginx1.28"
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"

:: ȥ��·����β���෴б��
if "%NGINX_PATH:~-1%"=="\" set "NGINX_PATH=%NGINX_PATH:~0,-1%"

:: ������ԱȨ��
net session >nul 2>&1 || (
    echo ���Թ���Ա������У�
    pause
    exit /b
)
:: ������Զ�ģʽ����������ʽ�˵�
if "%1"=="auto" goto install

:menu
cls
echo.
echo ===== Nginx ������� =====
echo 1. ��װ����
echo 2. ж�ط���
echo 3. �������˵�
echo.
set /p choice=��ѡ�� (1-3): 

if "%choice%"=="1" goto install
if "%choice%"=="2" goto uninstall
if "%choice%"=="3" exit /b
echo ��Ч����
pause
goto menu

:install
echo ���ڰ�װ Nginx ����...

:: ��� nginx.exe
if not exist "%NGINX_PATH%\nginx.exe" (
    echo [��] ����δ�ҵ� nginx.exe������·����%NGINX_PATH%
    pause
    goto menu
)

:: ȷ�� logs Ŀ¼����
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

"%NSSM_PATH%" install "%SERVICE_NAME%" "%NGINX_PATH%\nginx.exe"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppDirectory "%NGINX_PATH%"
"%NSSM_PATH%" set "%SERVICE_NAME%" DisplayName "%SERVICE_DISPLAY%"
"%NSSM_PATH%" set "%SERVICE_NAME%" Description "Nginx���������"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStdout "%LOG_DIR%\nginx.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStderr "%LOG_DIR%\nginx_error.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" Start SERVICE_AUTO_START

:: ��������
net start "%SERVICE_NAME%"
if %errorlevel% equ 0 (
    echo [��] Nginx ��װ�ɹ������� http://localhost ����
) else (
    echo [��] ����ʧ�ܣ���� %LOG_DIR%\nginx_error.log
)
:: ������Զ�ģʽ����������ʽ�˵�
if "%1"=="auto" exit /b
pause
goto menu

:uninstall
echo ����ж�� Nginx ����...
net stop "%SERVICE_NAME%" 2>nul
"%NSSM_PATH%" remove "%SERVICE_NAME%" confirm
echo [��] ��ж�� Nginx ����
pause
goto menu
