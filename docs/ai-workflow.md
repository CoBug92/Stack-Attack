# StackAttack AI workflow

Документ помогает быстрее ориентироваться в проекте во время следующих AI-сессий. Он не заменяет `AGENTS.md`, `README.md`, `docs/game-rules.md` и `docs/project-guidelines.md`.

Если документы расходятся с кодом, агент обязан явно разделять:

- подтверждённый факт реализации;
- задуманный контракт;
- неизвестное или непроверенное runtime-наблюдением.

Для сводки состояния используйте [implementation-status.md](implementation-status.md).

## Источники истины

1. `AGENTS.md` — рабочие ограничения, запреты и формат отчёта.
2. `README.md` — назначение проекта, запуск и навигация по документации.
3. `docs/game-rules.md` — целевой игровой контракт.
4. `docs/project-guidelines.md` — архитектурные и инженерные правила.
5. `scripts/xcodegen/project.yml` и `scripts/xcodegen/Application.yml` — фактическая конфигурация проекта.
6. Код и тесты — фактически реализованное состояние.

## Карта проекта

### Основные директории

- `StackAttack/App/` — точка входа приложения.
- `StackAttack/Common/` — типографика, отступы и мелкие UI helpers.
- `StackAttack/Flow/` — SwiftUI-экран, HUD, overlay и экранные controls.
- `StackAttack/Game/` — сцена, контроллер, игровые enum и интеграция слоёв.
- `StackAttack/Game/Domain/` — `GameWorld` и доменная симуляция.
- `StackAttack/Game/Rendering/` — визуальные сборщики фона, грузчика, груза и носителей.
- `StackAttack/Infrastructure/` — `UserDefaults` и музыка.
- `StackAttack/Resources/` — ассеты, аудио, локализации и generated resources.
- `UnitTests/` — unit-тесты доменной модели.
- `scripts/` — bootstrap, генерация, lint и Fastlane.

### Ответственность типов

- `GameController` — публикуемое UI-состояние, фазы игры, настройки, high score, музыка и координация со сценой.
- `GameScene` — SpriteKit orchestration: update loop, delivery state machine, рендер snapshot и эффекты.
- `GameWorld` — авторитетные правила движения, прыжка, столкновений, толкания, очистки рядов и game over.
- `SceneBackgroundRenderer` — фон и верхний рельс.
- `PlayerVisualRenderer` — визуальный облик грузчика и позы.
- `DeliveryVisualRenderer` — внешний вид `gantry`, `magnetic` и `drone`.
- `CargoVisualRenderer` — crate-ноды.

## Подтверждённые UX-решения

- Верхний HUD содержит кнопку паузы.
- Нижняя панель содержит только `влево`, `прыжок`, `вправо`.
- Настройки живут внутри overlay и доступны в `ready` и `paused`.
- Игрок отдельно выбирает грузчика, манипулятор и фон.
- Доступны два встроенных музыкальных трека.
- Музыку и haptics можно отключать независимо.
- При `knockedOut` игра идёт в `gameOver`, а не в восстановление.

## Что проверять перед документированием

### Если меняется логика игры

- Сначала сверять `GameWorld`.
- Проверять, не описывает ли `docs/game-rules.md` желаемое поведение как уже реализованное.
- Если наблюдаемое поведение не подтверждено кодом и не проверялось вручную, помечать его как неизвестное.

### Если меняется UI

- Сначала сверять `ContentView`, `GameHeaderView`, `GameControlsView`, overlay-компоненты и `GameAreaView`.
- Не путать текущий layout с желаемыми UX-правилами из документации.

### Если меняется release-поток

- Проверять `scripts/.env`, `scripts/fastlane/*` и `.github/workflows/*` вместе.
- Не описывать внешние секреты, App Store Connect поля и публичные URL как подтверждённые, если они не лежат в репозитории.

## Практические ограничения для AI

- Не использовать Code Reviewer и Verifier, пока это запрещено `AGENTS.md`.
- Не редактировать исходный код, если задача ограничена документацией.
- Не считать сборку доказательством качества анимации и ввода.
- Не дублировать авторитетное состояние одновременно в документах как “реализовано” и “нужно реализовать”.

## Полезные ориентиры

- Для запуска и обзора проекта: `README.md`
- Для фактического состояния реализации: `docs/implementation-status.md`
- Для целевого игрового контракта: `docs/game-rules.md`
- Для архитектурных ограничений: `docs/project-guidelines.md`
- Для скриптов, CI и release: `docs/scripts.md`
