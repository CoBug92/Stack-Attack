# Scripts Directory Guide

Документ описывает назначение папки `Scripts`, entrypoint-скрипты и release-инфраструктуру проекта.

## Общая идея

`Scripts` содержит генерацию проекта, SwiftGen, SwiftLint, Fastlane и локальные entrypoint-команды. Базовый поток теперь такой: проверить `Scripts/project.env`, затем использовать `Scripts/bootstrap.sh`, `Scripts/generate.sh` или прямой запуск Fastlane из `Scripts/fastlane` в зависимости от задачи.

## Структура

```text
Scripts/
  bootstrap.sh
  generate.sh
  project.env
  project.env.example
  fastlane/
  swiftgen/
  swiftlint/
  xcodegen/
```

`Scripts/project.env` хранит не секреты, а параметры проекта. Секреты для deploy должны оставаться в GitHub Secrets или локальном `Scripts/fastlane/.env`.

## Environment

`Scripts/project.env` и `Scripts/project.env.example` используют такие переменные:

```sh
PROJECT_NAME="StackAttack"
APP_DISPLAY_NAME="Stack Attack"
TARGET_NAME=StackAttack
TEAM_ID=YOUR_APPLE_TEAM_ID
BUNDLE_ID=com.kostyuchenko.stack-attack
```

- `PROJECT_NAME` — имя `.xcodeproj`.
- `APP_DISPLAY_NAME` — отображаемое имя приложения.
- `TARGET_NAME` — имя основного app target и схемы.
- `TEAM_ID` — Apple Developer Team ID. Сейчас его нужно заполнить фактическим значением.
- `BUNDLE_ID` — bundle identifier приложения.

## Entrypoints

### `bootstrap.sh`

Устанавливает CLI-инструменты из `Brewfile`, пробует поставить Ruby-зависимости через `bundle install` и затем запускает `Scripts/generate.sh`.

### `generate.sh`

Загружает `Scripts/project.env`, создаёт `StackAttack/Resources/Generated`, запускает SwiftGen и XcodeGen.

## XcodeGen

`Scripts/xcodegen/Application.yml` теперь содержит версионные поля и переменные окружения, которые нужны и локальной генерации, и Fastlane deploy:

- `PRODUCT_BUNDLE_IDENTIFIER` берётся из `BUNDLE_ID`;
- `DEVELOPMENT_TEAM` берётся из `TEAM_ID`;
- `MARKETING_VERSION` и `CURRENT_PROJECT_VERSION` обновляются Fastlane lane при deploy.

## Fastlane

Fastlane находится в `Scripts/fastlane`:

- `Appfile` читает `BUNDLE_ID` из `Scripts/project.env`;
- `Fastfile` содержит lanes `ci` и `deploy_to_tf`;
- `Matchfile` использует `TEAM_ID`, `BUNDLE_ID`, `MATCH_GIT_URL` и `MATCH_GIT_BRANCH`;
- `.env.example` показывает обязательные deploy-переменные.

Перед реальным deploy нужно подтвердить:

- фактический `TEAM_ID` в `Scripts/project.env` или workflow env;
- корректный `MATCH_GIT_URL` и ветку сертификатов;
- App Store Connect API key переменные;
- `MATCH_PASSWORD`.

## CI и deploy

Локальный запуск `bundle exec fastlane ios ci` из `Scripts/fastlane` и GitHub Actions CI теперь опираются на один и тот же Fastlane lane `ios ci`.

Workflow `.github/workflows/deploy-testflight.yml`:

- собирает `Scripts/project.env` из workflow-переменных и secrets;
- выполняет `bundle install`;
- запускает `bundle exec fastlane ios deploy_to_tf` из `Scripts/fastlane`;
- повышает build number относительно TestFlight и коммитит обновлённые versioning-поля.

## Правила изменения

- Не дублируйте логику в нескольких местах: меняйте wrapper-скрипты и lanes, а не копии команд.
- При изменении env-переменных синхронно обновляйте `Scripts/project.env.example`, XcodeGen и Fastlane.
- Перед release-изменениями проверяйте, что `MARKETING_VERSION` и `CURRENT_PROJECT_VERSION` действительно правятся в `Scripts/xcodegen/Application.yml`.
