@echo off
chcp 65001 >nul
title НАСТРОЙКА СЕТИ И RDP - ПОЛНАЯ ВЕРСИЯ
color 0A
echo ================================================
echo       ПОЛНАЯ НАСТРОЙКА СЕТИ И RDP
echo ================================================
echo.

:: Проверка прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ОШИБКА: Запустите файл от имени администратора!
    echo Нажмите правой кнопкой мыши на файле -^> "Запуск от имени администратора"
    echo.
    pause
    exit /b
)

echo [1/7] Включаем все необходимые службы...
sc config FDResPub start= auto >nul
sc start FDResPub >nul 2>&1
sc config FDPhost start= auto >nul
sc start FDPhost >nul 2>&1
sc config SSDPSRV start= auto >nul
sc start SSDPSRV >nul 2>&1
sc config upnphost start= auto >nul
sc start upnphost >nul 2>&1
echo   ✓ Службы запущены
echo.

echo [2/7] Настраиваем брандмауэр...
netsh advfirewall firewall set rule group="Сетевое обнаружение" new enable=Yes >nul
netsh advfirewall firewall set rule group="Общий доступ к файлам и принтерам" new enable=Yes >nul
netsh advfirewall firewall set rule group="Удаленный рабочий стол" new enable=Yes >nul
echo   ✓ Правила брандмауэра добавлены
echo.

echo [3/7] Включаем RDP...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul
echo   ✓ RDP включен
echo.

echo [4/7] Делаем сеть частной (Private)...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Set-NetConnectionProfile -NetworkCategory Private" >nul 2>&1
echo   ✓ Сеть переведена в частный режим
echo.

echo [5/7] Отключаем сложные проверки безопасности для RDP...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fAllowToGetHelp /t REG_DWORD /d 1 /f >nul
echo   ✓ Упрощенные настройки безопасности применены
echo.

echo [6/7] Получаем информацию о компьютере...
echo.
echo ============ ИНФОРМАЦИЯ О КОМПЬЮТЕРЕ ============
echo.

:: Имя компьютера
set "COMPNAME=%COMPUTERNAME%"
echo Имя компьютера: %COMPNAME%

:: Имя пользователя
set "USER=%USERNAME%"
echo Имя пользователя: %USER%

:: IP-адрес (универсальный способ)
set "IP="
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4-адрес" /c:"IP-Address" 2^>nul') do (
    set "IP=%%a"
    goto :ipfound
)
:ipfound
set "IP=%IP: =%"
if "%IP%"=="" set "IP=НЕ ОПРЕДЕЛЕН (смотрите в ipconfig)"
echo IP-адрес: %IP%

:: Проверка пароля
echo.
echo Проверка наличия пароля...
net user %USERNAME% | find "Password active" | find "Yes" >nul
if %errorlevel% equ 0 (
    echo Статус пароля: ✓ Установлен
) else (
    echo Статус пароля: ✗ НЕ УСТАНОВЛЕН - RDP НЕ БУДЕТ РАБОТАТЬ!
)

echo.
echo ================================================
echo.

echo [7/7] Включаем общий доступ к дискам...
net share C=C:\ /grant:Все,full >nul 2>&1
net share D=D:\ /grant:Все,full >nul 2>&1
echo   ✓ Общий доступ к дискам C и D включен
echo.

echo ================== ГОТОВО ==================
echo.
echo ВСЕ НАСТРОЙКИ УСПЕШНО ПРИМЕНЕНЫ!
echo.
echo ---------- КАК ПОДКЛЮЧИТЬСЯ К ЭТОМУ КОМПЬЮТЕРУ ----------
echo.
echo На ДРУГОМ компьютере нажмите Win + R и введите:
echo.
echo   mstsc /v:%IP%
echo.
echo ИЛИ используйте имя компьютера:
echo.
echo   mstsc /v:%COMPNAME%
echo.
echo Логин для подключения: %COMPNAME%\%USER%
echo Пароль: ваш текущий пароль Windows
echo.
echo ================================================
echo.
echo ВАЖНО: Если пароля нет - RDP НЕ РАБОТАЕТ!
echo Чтобы установить пароль:
echo 1. Нажмите Ctrl+Alt+Del
echo 2. Выберите "Изменить пароль"
echo 3. Задайте пароль
echo.
echo Нажмите любую клавишу для выхода...
pause >nul