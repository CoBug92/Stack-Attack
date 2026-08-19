# Stack Attack

Stack Attack — нативная iOS-игра для iPhone и iPad по мотивам классической игры с телефонов Siemens. Игрок управляет грузчиком, двигает падающие ящики, собирает полные ряды и пытается продержаться, пока склад не переполнится.

Документация в репозитории разделяет три слоя:

- подтверждённый факт реализации — то, что можно проверить по коду и конфигам;
- задуманный контракт — целевое поведение, зафиксированное в правилах и гайдлайнах;
- неизвестное — то, что нельзя надёжно подтвердить без runtime-проверки или внешнего состояния.

Сводка текущего состояния: [docs/implementation-status.md](docs/implementation-status.md).

## Что подтверждено реализацией

- Приложение написано на SwiftUI, а игровая сцена рендерится через SpriteKit.
- Авторитетная игровая симуляция вынесена в `GameWorld` и не зависит от рендера.
- Игра поддерживает локальный high score, паузу, экранные кнопки `влево / прыжок / вправо`, выбор внешнего вида грузчика, манипулятора и фона.
- В настройках доступны два встроенных музыкальных трека, а также отдельные переключатели музыки и тактильного отклика.
- Локализации присутствуют для русского и английского интерфейса.
- Данные сохраняются локально через `UserDefaults`; в коде не обнаружены сеть, аккаунты, аналитика и сторонние SDK сбора данных.

## Что стоит считать целевым контрактом, а не гарантией

- Точное игровое поведение, UX составного ввода и поведение после оглушения описаны в [docs/game-rules.md](docs/game-rules.md), но отдельные пункты нужно считать целевым контрактом до runtime-проверки.
- Архитектурные и инженерные правила из [docs/project-guidelines.md](docs/project-guidelines.md) задают ожидаемый способ развития проекта, а не автоматически подтверждают текущее состояние каждого файла.
- Release-процесс и App Store-материалы зависят от внешних секретов, App Store Connect и опубликованных публичных URL.

## Требования

- macOS с Xcode и iOS SDK 17.0 или новее;
- Homebrew для `xcodegen`, `swiftgen` и `swiftlint`;
- Ruby/Bundler для Fastlane-команд;
- при локальном deploy в TestFlight дополнительно нужны учётные данные App Store Connect и Match.

## Запуск

В репозитории уже может присутствовать сгенерированный `StackAttack.xcodeproj`, но канонический способ привести проект в актуальное состояние — запуск генерации из `scripts/`.

Первичная подготовка локальной среды:

```sh
scripts/bootstrap.sh
```

Скрипт:

- устанавливает CLI-инструменты из `Brewfile`;
- ставит Ruby-зависимости, если доступен `bundle`;
- проверяет наличие `scripts/.env`;
- запускает `scripts/generate.sh`;
- открывает `.xcodeproj` в Xcode.

`scripts/.env` хранится в репозитории и является единым источником не-секретных переменных проекта для shell-скриптов, XcodeGen и Fastlane.

После изменений XcodeGen-спецификации, локализаций или структуры исходников перегенерируйте проект:

```sh
scripts/generate.sh
```

## Управление

Подтверждено кодом и документами:

- `←` и `→` отвечают за удерживаемое горизонтальное движение;
- `↑` запускает прыжок;
- пауза находится в верхнем HUD;
- настройки доступны из overlay в состояниях `ready` и `paused`.

Целевой игровой контракт и детали граничных сценариев описаны в [docs/game-rules.md](docs/game-rules.md).

## Архитектура

```text
StackAttack/
  App/                    точка входа приложения
  Common/                 общие UI-константы и helpers
  Flow/                   SwiftUI-экран, HUD, overlay и экранные controls
  Game/
    Domain/               GameWorld и доменная симуляция
    Rendering/            SpriteKit-рендереры сцены
    GameController.swift  связка UI, настроек и игровых фаз
    GameScene.swift       игровая сцена и цикл доставки
  Infrastructure/         UserDefaults и воспроизведение музыки
  Resources/              ассеты, аудио, локализации, generated-файлы
UnitTests/                unit-тесты доменной модели
scripts/                  XcodeGen, SwiftGen, SwiftLint, Fastlane и bootstrap
docs/                     проектная документация и App Store-материалы
```

Подробнее:

- [docs/project-guidelines.md](docs/project-guidelines.md)
- [docs/ai-workflow.md](docs/ai-workflow.md)

## Проверка

Локальные команды, подтверждённые скриптами и Fastlane:

```sh
cd scripts/fastlane
bundle exec fastlane ios generate
bundle exec fastlane ios lint
bundle exec fastlane ios test
bundle exec fastlane ios build
```

GitHub Actions в актуальном дереве репозитория:

- `.github/workflows/verify.yml` запускается для `pull_request` в `master` и как reusable workflow;
- `.github/workflows/testflight-deploy.yml` запускается на `push` в `master`, вызывает `verify`, затем `deploy`, затем создаёт и пушит annotated tag.

Важно: прохождение сборки или unit-тестов не подтверждает UX анимаций, multi-touch и читаемость игрового темпа. Для этого нужен отдельный smoke-check в Simulator.

## Скриншоты App Store

В Debug-сборке доступен аргумент запуска `--screenshot-mode`. По коду он отключает обычный `game over` от падения ящика на игрока и от достижения верхней границы стопкой. В Release-сборке этот режим не действует.

В Debug также есть аргументы `--auto-start` и `--auto-play`, которые автоматически запускают игру при открытии экрана.

## Release

Fastlane находится в `scripts/fastlane`, а параметры проекта — в `scripts/.env`.

Подтверждено кодом:

- lane `deploy` разрешён только из ветки `master`;
- build number вычисляется относительно TestFlight;
- `deploy` пишет release metadata для следующего шага;
- `tag_release` создаёт annotated tag локально;
- workflow `testflight-deploy` отдельно пушит tag в `origin`.

Что зависит от внешнего состояния:

- секреты GitHub Actions;
- доступность Match-репозитория сертификатов;
- существование app record, SKU и публичных URL в App Store Connect.

Подробности:

- [docs/scripts.md](docs/scripts.md)
- [docs/app-store-connect.md](docs/app-store-connect.md)

## Документация

- [Текущее состояние реализации](docs/implementation-status.md)
- [Игровые правила](docs/game-rules.md)
- [Архитектурные гайдлайны](docs/project-guidelines.md)
- [Скрипты, CI и release](docs/scripts.md)
- [Контекст для AI-сессий](docs/ai-workflow.md)
- [Подготовка App Store Connect](docs/app-store-connect.md)
- [Privacy Policy (RU)](docs/privacy.html)
- [Privacy Policy (EN)](docs/privacy-en.html)
- [Support](docs/support.html)
