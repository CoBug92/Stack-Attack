# Скрипты, CI и release

Документ описывает фактическую роль каталога `scripts/`, подтверждённые части CI/release-контура и отдельно помечает то, что зависит от внешнего состояния.

## Общая идея

### Подтверждённый факт реализации

- `scripts/` содержит локальные entrypoint-скрипты, SwiftGen, SwiftLint, XcodeGen и Fastlane.
- Единый источник не-секретных проектных переменных — tracked файл `scripts/.env`.

### Неизвестное

- Наличие корректного `scripts/.env` в репозитории не гарантирует, что локальное окружение пользователя уже содержит все внешние зависимости для release.

## Структура

```text
scripts/
  .env
  bootstrap.sh
  generate.sh
  fastlane/
  swiftgen/
  swiftlint/
  xcodegen/
```

## `scripts/.env`

### Подтверждённый факт реализации

Файл содержит:

```sh
PROJECT_NAME="StackAttack"
APP_DISPLAY_NAME="Stack Attack"
TARGET_NAME="StackAttack"
TEAM_ID="Q9WXSNT6UT"
BUNDLE_ID="com.kostyuchenko.stack-attack"
```

Эти значения реально используются XcodeGen и Fastlane.

### Архитектурный контракт

- В `scripts/.env` должны жить только не-секретные значения.
- App Store Connect API keys, `MATCH_PASSWORD` и `MATCH_GIT_PRIVATE_KEY` должны оставаться во внешних секретах.

## Локальные entrypoint-скрипты

### `scripts/bootstrap.sh`

#### Подтверждённый факт реализации

- Проверяет наличие Homebrew.
- Устанавливает зависимости из `Brewfile`, если он существует.
- При наличии `bundle` ставит Ruby-зависимости.
- Проверяет наличие `scripts/.env`.
- Просит пользователя подтвердить, что `.env` настроен.
- Запускает `./generate.sh`.
- Открывает `../StackAttack.xcodeproj`.

#### Неизвестное

- Этот аудит не проверял выполнение `open` и интерактивный prompt в конкретном локальном окружении.

### `scripts/generate.sh`

#### Подтверждённый факт реализации

- Документация и соседние конфиги используют его как штатную точку входа генерации проекта.

#### Неизвестное

- В этом аудите скрипт не запускался, поэтому успешность конкретной локальной генерации не подтверждена.

## XcodeGen

### Подтверждённый факт реализации

- Корневой spec `scripts/xcodegen/project.yml` включает `Application.yml`.
- `Application.yml` определяет app target и unit test target.
- В generated project добавляются build scripts для `./scripts/swiftgen/swiftgen.sh` и `./scripts/swiftlint/swiftlint.sh`.
- `MARKETING_VERSION = 1.0.0`, `CURRENT_PROJECT_VERSION = 6`.
- Unit tests подключены как `${TARGET_NAME}UnitTests`.

### Архитектурный контракт

- Канонический источник конфигурации проекта — именно XcodeGen-спека, а не случайно присутствующий `.xcodeproj`.

## Fastlane

### Подтверждённый факт реализации

Fastlane расположен в `scripts/fastlane` и содержит lanes:

- `generate`
- `lint`
- `test`
- `build`
- `deploy`
- `tag_release`

Дополнительно подтверждено по коду:

- `Appfile` читает `BUNDLE_ID` из `scripts/.env`;
- `Matchfile` использует `TEAM_ID`, `BUNDLE_ID` и Match-репозиторий `ssh://git@ssh.github.com:443/SE-Kostyuchenko/Apple-Certificates.git`;
- `deploy` разрешён только из `master`;
- `deploy` вычисляет следующий TestFlight build number;
- `deploy` умеет записывать release metadata в файл для следующего шага workflow;
- `tag_release` создаёт annotated git tag локально.

### Неизвестное

- Этот аудит не проверял доступность TestFlight, App Store Connect API и Match в реальном окружении.

## CI

### Подтверждённый факт реализации

`.github/workflows/verify.yml`:

- запускается на `pull_request` в `master`;
- может вызываться как reusable workflow;
- содержит jobs `generate`, `lint`, `tests`.

`generate`:

- checkout;
- выбор Xcode через `DEVELOPER_DIR`;
- установка зависимостей;
- запуск `bundle _2.5.3_ exec fastlane ios generate`;
- публикация артефакта с `.xcodeproj` и generated resources.

`lint`:

- скачивает артефакт generated project;
- устанавливает зависимости;
- запускает `bundle _2.5.3_ exec fastlane ios lint`.

`tests`:

- требует успешных `generate` и `lint`;
- скачивает generated project;
- устанавливает зависимости;
- запускает `bundle _2.5.3_ exec fastlane ios test`.

### Неизвестное

- Аудит не подтверждает длительность, стабильность и производительность этих jobs на self-hosted runner.

## TestFlight deploy

### Подтверждённый факт реализации

`.github/workflows/testflight-deploy.yml`:

- запускается на `push` в `master`;
- сначала вызывает reusable `verify`;
- затем выполняет job `deploy`;
- затем выполняет job `tag`.

`deploy`:

- экспортирует App Store Connect и Match секреты в env;
- настраивает временный SSH-ключ для Match;
- вызывает `bundle _2.5.3_ exec fastlane ios deploy`;
- экспортирует `MARKETING_VERSION`, `BUILD_NUMBER`, `TAG_NAME`.

`tag`:

- checkout с `fetch-depth: 0`;
- настраивает git author;
- вызывает `bundle _2.5.3_ exec fastlane ios tag_release`;
- пушит tag в `origin`.

### Важно

- Workflow не коммитит изменения обратно в `master`.
- Публикация tag действительно происходит в job `tag`, а не внутри lane `deploy`.

### Неизвестное

- Этот аудит не подтверждает валидность конкретных секретов и доступность внешних сервисов на момент будущего релиза.

## Практические правила изменения

- При изменении проектных переменных синхронно проверяйте `scripts/.env`, XcodeGen и Fastlane.
- Не заводите второй расходящийся контур генерации.
- Для новых CI-stage команд расширяйте существующие lanes и wrapper-скрипты, а не создавайте дубли логики.
- Если меняется структура исходников или XcodeGen-спека, после этого требуется `scripts/generate.sh`.
