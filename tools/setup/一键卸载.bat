@echo off
setlocal enabledelayedexpansion
set "NSSM_PATH=%~dp0nssm.exe"
set "LOG_DIR=%~dp0logs"
set "SOFT_ROOT=d:\env_soft"

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



:uninstall_all
echo [!] ����ж�����з���...
echo.
set /p confirm=ȷ��ж�����з��������� "yes" ȷ�ϣ����������ȡ��: 
if /i not "%confirm%"=="yes" (
    echo ж����ȡ����
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
