@echo off
setlocal

:: �����������
set "SCRIPT_DIR=%~dp0"
set "MYSQL_HOME=%SCRIPT_DIR%..\mysql8"
set "SERVICE_NAME=ChengPinMySQL"
set "MYSQL_INI=%MYSQL_HOME%\my.ini"
set "MYSQLD_EXE=%MYSQL_HOME%\bin\mysqld.exe"

:: ȥ��·����β���෴б��
if "%MYSQL_HOME:~-1%"=="\" set "MYSQL_HOME=%MYSQL_HOME:~0,-1%"
:: ������Զ�ģʽ����������ʽ�˵�
if "%1"=="auto" goto install

:menu
cls
echo.
echo ===== MySQL������� =====
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
echo ���ڰ�װ MySQL ����...
:: ��� mysqld.exe
if not exist "%MYSQLD_EXE%" (
    echo [��] ����δ�ҵ� mysqld.exe������·����%MYSQLD_EXE%
    pause
    goto menu
)

:: ��� my.ini
if not exist "%MYSQL_INI%" (
    echo [��] ����δ�ҵ� my.ini �����ļ�������·����%MYSQL_INI%
    pause
    goto menu
)

:: ��װ MySQL ����
"%MYSQLD_EXE%" --install %SERVICE_NAME% --defaults-file="%MYSQL_INI%"

:: ��鰲װ�Ƿ�ɹ�
if %errorlevel% equ 0 (
    echo [��] MySQL �����ѳɹ�ע��
) else (
    echo [��] MySQL ����ע��ʧ�ܣ����������Ϣ
    pause
    goto menu
)

:: ���� MySQL ����
net start %SERVICE_NAME%
if %errorlevel% equ 0 (
    echo [��] MySQL �����ѳɹ�����
) else (
    echo [��] MySQL ��������ʧ�ܣ����ֶ����
)
:: ������Զ�ģʽ����������ʽ�˵�
if "%1"=="auto" exit /b
pause
goto menu

:uninstall
echo ����ж�� MySQL ����...

:: ֹͣ����
net stop %SERVICE_NAME% >nul 2>&1

:: ɾ������
sc delete %SERVICE_NAME% >nul 2>&1

:: ����Ƿ����ж��
sc query %SERVICE_NAME% >nul 2>&1
if %errorlevel% equ 1060 (
    echo [��] MySQL �����ѳɹ�ж��
) else (
    echo [��] MySQL ����ж��ʧ�ܣ����ֶ����
)

pause
goto menu
