# Win-RDP-Network-Setup
# 🖥️ Win-RDP-Network-Setup

Автоматический скрипт (Batch) для быстрой настройки сети и включения удаленного рабочего стола (RDP) в Windows.

> **⚠️ ПРЕДУПРЕЖДЕНИЕ О БЕЗОПАСНОСТИ / SECURITY WARNING**
> Этот скрипт предназначен для использования **только в доверенных локальных сетях**.
> Он отключает проверку подлинности на уровне сети (NLA) и открывает общий доступ к дискам C: и D: для всех пользователей.
> **Не используйте этот скрипт на компьютерах, имеющих прямой доступ в Интернет без дополнительного фаервола!**
>
> *This script is intended for use in **trusted local networks only**. It disables Network Level Authentication (NLA) and shares C: and D: drives with Everyone. **Do not use on machines directly exposed to the Internet!***

---

## 📋 Описание / Description

Скрипт автоматизирует рутинные настройки Windows для обеспечения удаленного доступа и видимости в сети.

**Что делает скрипт / What the script does:**
1.  ✅ Проверяет права администратора / Checks Admin rights.
2.  ✅ Включает службы обнаружения сети (FDResPub, SSDP, UPnP) / Enables Network Discovery services.
3.  ✅ Настраивает правила Брандмауэра (RDP, Файлы, Принтеры) / Configures Firewall rules.
4.  ✅ Включает RDP и меняет профиль сети на "Частный" / Enables RDP & sets Network to Private.
5.  ✅ Отключает NLA для упрощенного подключения / Disables NLA for easier connection.
6.  ✅ Показывает IP, имя ПК и статус пароля / Shows IP, Hostname, and Password status.
7.  ✅ Открывает общий доступ к дискам C и D / Shares C and D drives.

---

## 🚀 Инструкция по запуску / Usage Instructions

### 🇷🇺 На русском
1.  Скачайте файл `setup_rdp_network.bat`.
2.  Нажмите на файл **правой кнопкой мыши**.
3.  Выберите **"Запуск от имени администратора"**.
4.  Дождитесь окончания настройки и запишите IP-адрес, который появится в окне.
5.  **Важно:** У вашей учетной записи должен быть установлен пароль, иначе RDP не подключится.

### 🇬🇧 In English
1.  Download the `setup_rdp_network.bat` file.
2.  **Right-click** on the file.
3.  Select **"Run as administrator"**.
4.  Wait for the configuration to finish and note the IP address displayed.
5.  **Important:** Your user account must have a password set, otherwise RDP will not work.

---

## 🔌 Как подключиться / How to Connect

После запуска скрипта, чтобы подключиться к этому компьютеру с другого устройства:

1.  Нажмите `Win + R`.
2.  Введите команду:
    ```cmd
    mstsc /v:IP_АДРЕС
    ```
    *(Замените `IP_АДРЕС` на цифры, показанные скриптом / Replace `IP_ADDRESS` with numbers shown by script)*
3.  Введите логин и пароль:
    *   **User:** `ИМЯ_КОМПЬЮТЕРА\ИМЯ_ПОЛЬЗОВАТЕЛЯ`
    *   **Password:** Ваш пароль от Windows

---

## 🛡️ Рекомендации по безопасности / Security Recommendations

Если вам не нужен общий доступ к файлам, откройте скрипт в Блокноте и закомментируйте (поставьте `::` в начале) строки в разделе `[7/7]`:
```batch
:: net share C=C:\ /grant:Все,full >nul 2>&1
:: net share D=D:\ /grant:Все,full >nul 2>&1
