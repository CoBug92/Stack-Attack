# Stack Attack: Новая смена — iOS

Нативный iOS-прототип по мотивам классической игры с телефонов Siemens. Интерфейс написан на SwiftUI, игровое поле — на SpriteKit.

## Запуск iOS-версии

Откройте `StackAttack.xcodeproj` в Xcode, выберите iPhone Simulator и нажмите Run.

Для первоначальной установки инструментов и Ruby-зависимостей выполните:

```sh
Scripts/bootstrap.sh
```

Параметры проекта лежат в `Scripts/project.env`. Сейчас там уже зафиксированы имя проекта, схема и bundle id; перед реальным release нужно заполнить `TEAM_ID`.

Если нужно заново сгенерировать проект после изменения XcodeGen-спецификации, Fastlane или `project.env`:

```sh
Scripts/generate.sh
```

Локальная проверка, равная GitHub CI:

```sh
cd Scripts/fastlane && bundle exec fastlane ios ci
```

## Release

Fastlane находится в `Scripts/fastlane`.

Для deploy в TestFlight нужны:

- `TEAM_ID` в `Scripts/project.env` или workflow env;
- `Scripts/fastlane/.env` на основе `.env.example` для локального запуска;
- App Store Connect API key переменные;
- доступ к match-репозиторию с сертификатами.

Локальный запуск deploy lane:

```sh
cd Scripts/fastlane && bundle exec fastlane ios deploy_to_tf
```

GitHub Actions deploy описан в `.github/workflows/deploy-testflight.yml`. Он собирает `Scripts/project.env` из secrets/vars и запускает тот же lane.

## Управление

- Кнопки `←` и `→` — движение и толкание ящиков.
- Кнопка `↑` — прыжок; удерживаемое направление задаёт боковое движение.
- `↑` вместе с направлением к стопке сдвигает доступный верхний ящик.
- Пауза находится в верхней части экрана.
- Настройки смены доступны в меню перед стартом и в меню паузы.
- Кнопки движения поддерживают удержание.

Задача — заполнять горизонтальные ряды. Полный ряд исчезает, а скорость крана постепенно растёт.

## Где что лежит

- `StackAttack/UI/` — SwiftUI-экран, HUD и overlay-меню.
- `StackAttack/Game/Domain/` — игровая логика `GameWorld`.
- `StackAttack/Game/` — контроллер и SpriteKit-сцена.
- `StackAttack/Game/Rendering/` — визуальные билдеры грузчика, грузов, фона и манипуляторов.
- `Scripts/xcodegen/` — XcodeGen-спецификация проекта; `Scripts/` содержит генерацию, lint и Fastlane.
- `docs/ai-workflow.md` — быстрый технический гид для будущих AI-правок.
- `docs/scripts.md` — подробный гид по локальным скриптам, env и release-инфраструктуре.

## Веб-прототип

Файлы `index.html`, `styles.css` и `game.js` сохранены как референс ранней версии. Для работы iOS-приложения они не используются.
