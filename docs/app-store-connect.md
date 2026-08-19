# App Store Connect — Stack Attack

Документ собирает материалы для карточки приложения и submission checklist. Он разделяет:

- подтверждённое по репозиторию;
- рекомендованный текст для App Store Connect;
- внешние поля, которые нельзя считать подтверждёнными без доступа к аккаунту и финальному архиву.

Состояние исходников и конфигов сверено 19 августа 2026 года.

## Что подтверждено репозиторием

- Platform: iOS.
- Bundle ID: `com.kostyuchenko.stack-attack`.
- Текущая версия в XcodeGen-спеке: `1.0.0 (6)`.
- `ITSAppUsesNonExemptEncryption = false`.
- В проекте есть русская и английская локализации интерфейса.
- В коде не обнаружены сеть, аккаунты, аналитика, реклама, покупки и сторонние data SDK.
- В репозитории есть страницы `docs/privacy.html`, `docs/privacy-en.html` и `docs/support.html`.

## Что не подтверждено одним репозиторием

- SKU в App Store Connect.
- Уже созданная app record.
- Публичные HTTPS URL для privacy policy и support.
- Финальный build number, если он изменится после следующего deploy.
- Финальная анкета Age Rating и App Privacy по реально загруженному архиву.
- Контактный телефон и другие метаданные владельца аккаунта.

## Локализации карточки

Рекомендуемые App Store Localization:

| Локализация карточки | Назначение |
| --- | --- |
| Russian | Русскоязычная витрина |
| English (U.S.) | Англоязычная витрина |

### Комментарий по достоверности

- Наличие `ru.lproj` и `en.lproj` подтверждено.
- Отсутствие обрезания строк в финальной Release-сборке этим аудитом не подтверждено.

## Общие поля

### Подтверждено

| Поле | Значение |
| --- | --- |
| Platform | `iOS` |
| Bundle ID | `com.kostyuchenko.stack-attack` |
| Version | `1.0.0` |
| Build | `6` |
| App encryption | `No`, если финальный архив не меняет `ITSAppUsesNonExemptEncryption = false` |

### Требует решения владельца аккаунта

| Поле | Статус |
| --- | --- |
| SKU | Выбрать и проверить уникальность в App Store Connect |
| Primary category | Подтвердить в аккаунте |
| Secondary category | Подтвердить в аккаунте |
| Availability / Pricing | Подтвердить в аккаунте |
| Copyright | Подтвердить актуальную формулировку и правообладателя |
| Age Rating | Заполнить по финальной анкете |

## Russian — рекомендованный текст

| Поле | Текст |
| --- | --- |
| Name | `Stack Attack` |
| Subtitle | `Наведи порядок на складе` |
| Promotional Text | `Толкай падающие ящики, заполняй ряды и не дай складу переполниться. Одна смена — один новый рекорд.` |
| Keywords | `головоломка,аркада,ящики,склад,платформер,ряды,пазл,рекорды,казуальная,офлайн` |
| What's New in This Version | `Первая версия Stack Attack.` |

### Russian — Description

Stack Attack — аркадная головоломка о работе на перегруженном складе.

Управляй грузчиком, перемещай ящики и заполняй горизонтальные ряды. Когда ряд собран, он исчезает и приносит очки. Но склад не ждёт: груз прибывает всё быстрее, а неудачно упавший ящик завершает попытку.

В Stack Attack тебя ждут:

- плавное управление: двигайся, прыгай и толкай ящики;
- сбор полных рядов с растущей сложностью;
- выбор внешнего вида грузчика, манипулятора и фона;
- два встроенных музыкальных трека с возможностью отключения музыки;
- отключаемый тактильный отклик;
- локальный рекорд, который сохраняется на устройстве.

## English (U.S.) — recommended copy

| Field | Copy |
| --- | --- |
| Name | `Stack Attack` |
| Subtitle | `Clear the warehouse` |
| Promotional Text | `Push falling crates, clear rows, and keep the warehouse from overflowing. Every shift is a chance for a new high score.` |
| Keywords | `puzzle,arcade,crates,warehouse,platformer,rows,casual,offline,highscore` |
| What's New in This Version | `Welcome to the first release of Stack Attack.` |

### English — Description

Stack Attack is an arcade puzzle game set in an overcrowded warehouse.

Guide a loader, move crates, and fill horizontal rows. A completed row clears for points, but cargo arrives faster and faster, and a badly placed crate can end the shift.

In Stack Attack, players can:

- move, jump, and push crates with on-screen controls;
- clear full rows as the pace increases;
- choose the look of the loader, cargo manipulator, and background;
- switch between two built-in music tracks or turn music off;
- enable or disable haptic feedback;
- keep a local high score on the device.

## Public URLs

В репозитории есть только исходники страниц:

- `docs/privacy.html`
- `docs/privacy-en.html`
- `docs/support.html`

Для submission нужны реальные публичные HTTPS URL без sign-in. Пример placeholders:

| Field | Placeholder |
| --- | --- |
| Privacy Policy URL (RU) | `https://[your-domain]/privacy.html` |
| Privacy Policy URL (EN) | `https://[your-domain]/privacy-en.html` |
| Support URL | `https://[your-domain]/support.html` |

Эти URL нельзя вывести из одного лишь репозитория.

## App Privacy

### Подтверждено кодом

- Сохраняются локально только high score и пользовательские настройки.
- По исходникам не видно сбора персональных данных, сетевых вызовов, аналитики и рекламных SDK.

### Рекомендация

Для текущей конфигурации кода базовая гипотеза — **Data Not Collected**.

### Ограничение

Это утверждение нужно перепроверить по финальному архиву перед отправкой. Оно перестанет быть верным, если до релиза добавятся analytics, crash reporting, ads, attribution или любой внешний data SDK.

## Age Rating

### Рабочая гипотеза

По текущему репозиторию нет признаков:

- user-generated content;
- чата;
- азартных механик;
- рекламы;
- покупок;
- реалистичного насилия;
- сексуального контента;
- медицинской информации.

### Ограничение

Финальный возрастной рейтинг определяется актуальной анкетой App Store Connect, а не этим документом.

## App Review Information

### Подтверждено

- Sign-in required: `No`
- Demo account: `Not required`
- Приложение работает офлайн и использует экранные controls

### Требует ручного заполнения

- Contact first name / last name
- Contact email
- Contact phone
- Review notes в финальной формулировке владельца аккаунта

Рабочая заметка для review:

`The app works fully offline. No account, payment, or external hardware is required. Gameplay controls are on screen: left, jump, right; the pause button is at the top.`

## Скриншоты

Рекомендуемые сценарии для каждой локализации:

1. Стартовый overlay и настройки смены.
2. Геймплей: ящики, счёт, уровень, пауза в верхнем HUD.
3. Выбор внешнего вида или другой фон/манипулятор.

### Подтверждённый факт реализации

- В Debug есть аргумент `--screenshot-mode`.
- В Debug также есть `--auto-start` и `--auto-play`.

### Неизвестное

- Этот аудит не подтверждает, что текущая iPad-верстка и все необходимые screenshot size classes уже визуально готовы к загрузке в App Store Connect.

## Submission checklist

- [ ] Подтвердить или создать app record в App Store Connect.
- [ ] Выбрать и проверить уникальность SKU.
- [ ] Проверить, что финальная версия и build совпадают с загруженным архивом.
- [ ] Опубликовать `privacy.html`, `privacy-en.html` и `support.html` по реальным HTTPS URL.
- [ ] Перепроверить App Privacy и Age Rating по финальному архиву.
- [ ] Подтвердить категории, pricing, territories и review contact.
- [ ] Подготовить финальные скриншоты для обязательных device classes.
- [ ] Проверить Release-сборку на iPhone и iPad перед Submit for Review.
