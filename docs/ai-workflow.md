# StackAttack AI workflow

Документ фиксирует практический контекст проекта для следующих AI-сессий. Он не заменяет `AGENTS.md`, `docs/game-rules.md` и `docs/project-guidelines.md`, а помогает быстрее ориентироваться в коде.

## Источники истины

1. `AGENTS.md` — рабочие ограничения, запреты и формат отчёта.
2. `docs/game-rules.md` — целевое поведение игры и UI.
3. `docs/project-guidelines.md` — архитектурные и инженерные правила.
4. Код и тесты — фактически реализованное состояние.
5. `README.md` — краткий запуск и описание управления.

Если документы расходятся с кодом, нужно явно разделять:

- что подтверждено текущей реализацией;
- что является целевым контрактом;
- что не проверено runtime-наблюдением.

## Карта проекта

### Основные директории

- `StackAttack/App/` — точка входа приложения.
- `StackAttack/UI/` — SwiftUI-экран, HUD, overlay-меню и on-screen controls.
- `StackAttack/Game/` — интеграция SpriteKit-сцены и контроллера.
- `StackAttack/Game/Domain/` — чистая игровая модель `GameWorld`, пригодная для unit-тестов.
- `StackAttack/Game/Rendering/` — визуальные билдеры сцены: фон, грузчик, груз и манипуляторы.
- `UnitTests/` — проверка доменной логики.
- `Scripts/` — генерация проекта, lint-скрипты и Fastlane.

### Ответственность типов

- `GameController` — публикуемое UI-состояние, переходы фаз, persistence выбранных скинов.
- `GameScene` — orchestration SpriteKit: update loop, crane pass, render snapshot, эффекты.
- `GameWorld` — авторитетные правила движения, прыжка, столкновений, толчка, рядов и game over.
- `SceneBackgroundRenderer` — задники и верхний рельс/трос.
- `PlayerVisualRenderer` — сборка грузчика и смена поз.
- `DeliveryVisualRenderer` — внешний вид манипуляторов.
- `CargoVisualRenderer` — сборка crate-ноды.

## Текущие UX-решения

- Верхний HUD содержит только кнопку паузы.
- Настройки находятся внутри overlay в состояниях `ready` и `paused`.
- Игрок отдельно выбирает грузчика, манипулятор и задний фон.
- `BackgroundAppearance.neonGrid` удалён; актуальные фоны перечислены в `GameController.BackgroundAppearance`.
- Прыжок должен срабатывать без input-delay; короткое приседание — только визуальная фаза.

## Как безопасно менять проект

### Если меняется логика игры

Сначала смотрите `GameWorld` и существующие unit-тесты. Новые правила лучше добавлять туда, а не напрямую в SpriteKit-узлы.

### Если меняется представление

- SpriteKit-отрисовку правьте в `GameScene` или `Game/Rendering/*`.
- SwiftUI/HUD/overlay правьте в `StackAttack/UI/`.
- Не смешивайте логику столкновений с кодом декоративной анимации.

### Если добавляете новые файлы

`Scripts/xcodegen/Application.yml` уже включает папку `StackAttack/` как source root, поэтому новые Swift-файлы в этих директориях обычно подхватываются без ручного редактирования Xcode-проекта. Перегенерация нужна, только если меняется сама спецификация проекта или структура таргетов.

## Проверки

Начинать стоит с самых узких проверок, потом расширять:

```sh
swiftlint lint --config Scripts/swiftlint/.swiftlint.yml --no-cache <changed-swift-files>
```

```sh
xcodebuild \
  -project StackAttack.xcodeproj \
  -scheme StackAttack \
  -destination "generic/platform=iOS Simulator" \
  CODE_SIGNING_ALLOWED=NO \
  build
```

Для поведения прыжка, паузы, multi-touch и читаемости анимации одной сборки недостаточно: нужен реальный smoke-check в Simulator.

## Частые ловушки

- Не считать сборку доказательством качества анимации.
- Не дублировать авторитетное состояние одновременно в `GameWorld`, `SKAction` и ручных правках координат.
- Не возвращать отдельный sheet/экран настроек, если задача касается start/pause overlay.
- Не использовать Code Reviewer и Verifier, пока это запрещено `AGENTS.md`.
- Не делать широкий рефакторинг без локальной границы ответственности; сначала найти естественный разрез по файлам.
