# App Store Connect — Stack Attack (Russian + English)

Пакет для первого релиза iOS `1.0.0 (1)`. Тексты ниже основаны на текущем
исходном коде и конфигурации проекта на 7 августа 2026 года.

## Важное ограничение локализации

**Подтверждённый факт:** для интерфейса существуют файлы `ru.lproj` и
`en.lproj`, но текущий Swift-код выводит игровые строки на русском напрямую.
Следовательно, английская карточка в App Store будет локализована, но сам
интерфейс приложения пока нельзя честно заявлять как английский.

В App Store Connect добавьте две **App Store Localization**:

| Локализация карточки | Назначение |
| --- | --- |
| Russian | Русскоязычная витрина |
| English (U.S.) | Англоязычная витрина |

Не добавляйте English в список поддерживаемых языков приложения до отдельной
проверки реальной локализации интерфейса. Это не блокирует английскую витрину,
но исключает ложное ожидание у пользователя.

## Общие поля — заполняются один раз

| Поле App Store Connect | Значение |
| --- | --- |
| Platform | iOS |
| Bundle ID | `com.kostyuchenko.stack-attack` |
| SKU | `stack-attack-ios-001` (уникальность проверить в аккаунте) |
| Primary category | Games → Puzzle |
| Secondary category | Games → Casual |
| Age Rating | Пройти актуальную анкету; предварительно 4+ |
| Availability | Выбрать владельцу; для первого релиза — Free, без In-App Purchases |
| Copyright | `© 2026 Bogdan Kostyuchenko` |
| Version | `1.0.0` |
| Build | `1` |
| App encryption | `No` — в Xcode уже задано `ITSAppUsesNonExemptEncryption = false`; подтвердить по финальному архиву |

## Russian — App Store Localization

| Поле | Текст для вставки |
| --- | --- |
| Name | `Stack Attack` |
| Subtitle | `Наведи порядок на складе` |
| Promotional Text | `Толкай падающие ящики, заполняй ряды и не дай складу переполниться. Одна смена — один новый рекорд.` |
| Keywords | `головоломка,аркада,ящики,склад,платформер,ряды,пазл,рекорды,казуальная,офлайн` |
| What's New in This Version | `Первая версия Stack Attack.` |

### Russian — Description

> Stack Attack — аркадная головоломка о работе на перегруженном складе.
>
> Управляй грузчиком, перемещай ящики и заполняй горизонтальные ряды. Когда
> ряд собран, он исчезает и приносит очки. Но кран не ждёт: груз прибывает всё
> быстрее, а неудачно упавший ящик заканчивает смену.
>
> В Stack Attack тебя ждут:
>
> • Плавное управление: двигайся, прыгай и толкай ящики.
> • Простая цель с растущей сложностью: собирай полные ряды и улучшай результат.
> • Выбор внешнего вида грузчика, манипулятора и фона.
> • Настраиваемый тактильный отклик.
> • Локальный рекорд, который сохраняется на устройстве.
>
> Начинай новую смену и наведи порядок на складе.

## English (U.S.) — App Store Localization

| Field | Copy to paste |
| --- | --- |
| Name | `Stack Attack` |
| Subtitle | `Clear the warehouse` |
| Promotional Text | `Push falling crates, clear rows, and keep the warehouse from overflowing. Every shift is a chance for a new high score.` |
| Keywords | `puzzle,arcade,crates,warehouse,platformer,rows,casual,offline,highscore` |
| What's New in This Version | `Welcome to the first release of Stack Attack.` |

### English — Description

> Stack Attack is an arcade puzzle game set in an overcrowded warehouse.
>
> Guide a loader, move crates, and fill horizontal rows. A completed row clears
> for points, but the crane never waits: cargo arrives faster and faster, and a
> badly placed crate can end the shift.
>
> In Stack Attack, you can:
>
> • Move, jump, and push crates with responsive on-screen controls.
> • Clear complete rows as the pace increases.
> • Choose the look of your loader, cargo manipulator, and background.
> • Enable or disable haptic feedback.
> • Keep a high score saved locally on your device.
>
> Start a new shift and bring order to the warehouse.

## Public URLs — required before submission

| App Store Connect field | Russian page | English page |
| --- | --- | --- |
| Privacy Policy URL | `https://[your-domain]/privacy.html` | `https://[your-domain]/privacy-en.html` |
| Support URL | `https://[your-domain]/support.html` | Same page; it contains Russian and English support information |
| Marketing URL | Optional — leave blank unless a real landing page is published |

The repository contains the sources for these pages:

- [`privacy.html`](privacy.html) — Russian policy
- [`privacy-en.html`](privacy-en.html) — English policy
- [`support.html`](support.html) — bilingual support page

They must be deployed at public HTTPS URLs without sign-in. Update the example
URLs above to the actual host before submitting. The URLs cannot be inferred
from the repository.

## App Privacy

Current source code uses local `UserDefaults` only for the high score,
appearance choices, and haptics preference. The code search found no network,
advertising, analytics, account, or third-party data SDK.

For the current release select **Data Not Collected**. Recheck the final
archived build before submission; this answer becomes incorrect if analytics,
crash reporting, ads, attribution, a backend, or another data SDK is added.

## Age Rating questionnaire

Preliminary answers: select **None / No** for all content categories. The
current game has no user-generated content, chat, ads, purchases, gambling,
medical information, sexual content, weapons, or realistic violence. The final
rating is calculated by App Store Connect from the current questionnaire.

## App Review Information

| Field | Value |
| --- | --- |
| Sign-in required | No |
| Demo account | Not required |
| Contact first name / last name | `Bogdan Kostyuchenko` |
| Contact email | `b.kostyuchenko@gmail.com` |
| Contact phone | `[enter a reachable phone number]` |
| Notes | `The app works fully offline. No account, payment, or external hardware is required. Gameplay controls are on screen: left, jump, right; the pause button is at the top.` |

## Screenshots and preview

Use only screenshots from the final build. Prepare the same three scenarios for
each App Store localization; their text must match the selected language:

1. Start screen and the shift settings.
2. Gameplay: falling crate, stack, score, and level.
3. Appearance choices: another background and cargo manipulator.

The project declares both iPhone and iPad. Upload every device-size set required
by App Store Connect, and do not submit iPad screenshots until the release build
has been checked on iPad. An App Preview is optional for version 1.0.

## Submission checklist

- [ ] Create the app record using the bundle ID and SKU above.
- [ ] Add Russian and English (U.S.) App Store localizations and paste the copy.
- [ ] Publish the privacy and support pages over HTTPS; replace `[your-domain]`.
- [ ] Verify the two policy pages show the real contact email and copyright holder.
- [ ] Upload a signed `1.0.0 (1)` archive and select it for the version.
- [ ] Complete pricing, territories, tax/banking agreements, and App Review phone number.
- [ ] Complete App Privacy and Age Rating using the **final archive**, not this document.
- [ ] Add final screenshots for all required device classes and both localizations.
- [ ] Test the release build on iPhone and iPad before pressing Submit for Review.
