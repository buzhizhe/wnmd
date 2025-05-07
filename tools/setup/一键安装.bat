@echo off
setlocal enabledelayedexpansion
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"

:: ������
set "SERVICES[1].name=mysql"
set "SERVICES[1].display=MySQL����"
set "SERVICES[1].service_name=ChengPinMySQL"

set "SERVICES[2].name=nginx"
set "SERVICES[2].display=Nginx����"
set "SERVICES[2].service_name=nginx"

set "SERVICES[3].name=web"
set "SERVICES[3].display=Web����"
set "SERVICES[3].service_name=cpWeb"

:install_all
echo ���ڰ�װ���з���...
for /l %%i in (1,1,3) do (
    call :auto_install_service %%i
)
pause
exit /b

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