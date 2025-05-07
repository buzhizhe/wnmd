@echo off
setlocal

:: ͳһ·������
set "SCRIPT_DIR=%~dp0"
set "SOFT_ROOT=%SCRIPT_DIR%.."
set "WEB_ROOT=%SOFT_ROOT%\..\web"
set "DOTNET_PATH=%SOFT_ROOT%\dotnet8\dotnet.exe"
set "NSSM_PATH=%~dp0nssm.exe"
set "SERVICE_NAME=cpWeb"
set "SERVICE_DISPLAY=ChengPinWeb"
set "LOG_DIR=%~dp0logs"

:: ȥ��·��β����б��
if "%SOFT_ROOT:~-1%"=="\" set "SOFT_ROOT=%SOFT_ROOT:~0,-1%"
if "%WEB_ROOT:~-1%"=="\" set "WEB_ROOT=%WEB_ROOT:~0,-1%"

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
echo ===== .NET Web ������� =====
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
echo ���ڰ�װ Web ����...

:: ���ؼ��ļ�
if not exist "%DOTNET_PATH%" (
    echo [��] ����δ�ҵ� dotnet.exe������·�� %DOTNET_PATH%
    pause
    goto menu
)

if not exist "%NSSM_PATH%" (
    echo [��] ����δ�ҵ� nssm.exe������·�� %NSSM_PATH%
    pause
    goto menu
)

if not exist "%WEB_ROOT%\API.dll" (
    echo [��] ����δ�ҵ� API.dll������·�� %WEB_ROOT%
    pause
    goto menu
)

:: ȷ����־Ŀ¼����
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

:: ֹͣ���Ƴ��ɷ���
echo ��������ɷ���...
net stop "%SERVICE_NAME%" >nul 2>&1
"%NSSM_PATH%" remove "%SERVICE_NAME%" confirm >nul 2>&1

:: ��װ�·���
echo ����ע�����...
"%NSSM_PATH%" install "%SERVICE_NAME%" "%DOTNET_PATH%" "API.dll --urls http://localhost:5000"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppDirectory "%WEB_ROOT%"
"%NSSM_PATH%" set "%SERVICE_NAME%" DisplayName "%SERVICE_DISPLAY%"
"%NSSM_PATH%" set "%SERVICE_NAME%" Description "ASP.NET Core վ��"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStdout "%LOG_DIR%\web.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" AppStderr "%LOG_DIR%\web-error.log"
"%NSSM_PATH%" set "%SERVICE_NAME%" Start SERVICE_AUTO_START

:: ��������
echo �������� Web ����...
net start "%SERVICE_NAME%"

if %errorlevel% equ 0 (
    echo [��] Web ����װ�ɹ������� http://localhost:5000 ����
    echo ��־�ļ�Ŀ¼��%LOG_DIR%
) else (
    echo [��] ����ʧ�ܣ�������־��
)
:: ������Զ�ģʽ����������ʽ�˵�
if "%1"=="auto" exit /b
 pause
goto menu

:uninstall
echo ����ж�� Web ����...
net stop "%SERVICE_NAME%" 2>nul
"%NSSM_PATH%" remove "%SERVICE_NAME%" confirm
echo [��] ��ж�� Web ����
pause
goto menu
