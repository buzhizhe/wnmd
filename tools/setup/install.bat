@echo off
setlocal enabledelayedexpansion
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"
set "SOFT_ROOT=d:\env_soft"

:: �����壨���Ƴ� mqtt/emqx/modbus��
set "SERVICES[1].name=mysql"
set "SERVICES[1].display=MySQL����"
set "SERVICES[1].service_name=ChengPinMySQL"

set "SERVICES[2].name=nginx"
set "SERVICES[2].display=Nginx����"
set "SERVICES[2].service_name=nginx"

set "SERVICES[3].name=web"
set "SERVICES[3].display=Web����"
set "SERVICES[3].service_name=cpWeb"


:menu
cls
echo.
echo ===== һ���������˵� =====
for /l %%i in (1,1,3) do (
    echo %%i. ��װ !SERVICES[%%i].display!
)
echo -----------------
echo 4. �鿴���з���״̬
echo 5. һ����װ���з���
echo 6. һ��ж�����з���
echo 0. �˳�
echo.
set /p choice=������������ (0-6): 

if %choice% gtr 0 if %choice% leq 3 (
    call :install_service %choice%
    pause
    goto menu
)
if "%choice%"=="4" goto check_status
if "%choice%"=="5" goto install_all
if "%choice%"=="6" goto uninstall_all
if "%choice%"=="0" exit
echo ��Ч���룬������ѡ�� 
pause
goto menu


:check_status
echo.
echo ===== ����״̬��� =====
for /l %%i in (1,1,3) do (
    sc query !SERVICES[%%i].service_name! >nul 2>&1
    if !errorlevel! equ 0 (
        echo [��] !SERVICES[%%i].display! �Ѱ�װ
    ) else (
        echo [��] !SERVICES[%%i].display! δ��װ
    )
)
pause
goto menu


:install_all
echo ���ڰ�װ���з���...
for /l %%i in (1,1,3) do (
    call :auto_install_service %%i
)
goto menu


:auto_install_service
echo.
echo [���ڰ�װ !SERVICES[%1].display!...]
call "%~dp0install_!SERVICES[%1].name:~0,6!.bat" auto
if %errorlevel% equ 0 (
    echo [��] !SERVICES[%1].display! ��װ�ɹ�
) else (
    echo [��] !SERVICES[%1].display! ��װʧ�ܣ��鿴��־��ȡ������Ϣ��
    pause
)
goto :eof


:install_service
echo.
echo [���ڰ�װ !SERVICES[%1].display!...]
call "%~dp0install_!SERVICES[%1].name:~0,6!.bat"
if %errorlevel% equ 0 (
    echo [��] !SERVICES[%1].display! ��װ�ɹ�
) else (
    echo [��] !SERVICES[%1].display! ��װʧ�ܣ��鿴��־��ȡ������Ϣ��
    pause
)
goto :eof


:uninstall_all
echo [!] ����ж�����з���...
for /l %%i in (1,1,3) do (
    call :uninstall_service !SERVICES[%%i].service_name! "!SERVICES[%%i].display!"
)
goto menu


:uninstall_service
echo.
echo [����ж�� %2...]
net stop %1 >nul 2>&1
"%NSSM_PATH%" stop %1 >nul 2>&1 || echo (����ֹͣʧ��)

:: �жϷ����Ƿ��� nssm ����ķ���
sc qc %1 >nul 2>&1
if %errorlevel% equ 1060 (
    echo ���� %1 �����ڣ�����...
) else (
    "%NSSM_PATH%" remove %1 confirm >nul 2>&1 || echo (����ж��ʧ��)
    sc delete %1 >nul 2>&1 || echo (����ɾ��ʧ��)
)

sc query %1 >nul 2>&1
if %errorlevel% equ 1060 (
    echo [��] %2 ��ж��
) else (
    echo [!] %2 ж�ؿ���ʧ�ܣ�����
)

goto :eof