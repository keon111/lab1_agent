---
description: "Створи кросплатформний GitHub Actions workflow за skill github-actions."
agent: agent
---

# create-actions

Виконуй усі дії ідемпотентно: повторний запуск не руйнує і не дублює файли чи конфігурації.

## Передумови

- Поточний робочий каталог — корінь проєкту.
- Кореневий `ci.sh` виконує конфігурацію, збірку та тести й повертає ненульовий код при помилці.
- Прочитай наявний `.github/workflows/ci.yml`, якщо він існує, перш ніж вносити зміни.
- Доступний skill [github-actions](../skills/github-actions/SKILL.md).

## Дії

1. Застосуй вимоги й перевірки skill [github-actions](../skills/github-actions/SKILL.md).
2. Створи або безпечно доповни `.github/workflows/ci.yml`. Збережи наявні тригери й matrix; не створюй другого workflow для тієї самої задачі.
3. У workflow використовуй лише кроки checkout через `actions/checkout@v4`, запуску `bash ci.sh` із `shell: bash` та Deploy через `actions/upload-artifact@v4`.
4. Не додавай команди CMake/CTest, крок встановлення CMake або окремий крок тестів: усе це виконує `ci.sh`.
5. Для артефакту вкажи `name: hello-${{ matrix.os }}`, `if-no-files-found: error` і шляхи `build/hello` та `build/Release/hello.exe`.

## Очікувані файли

- `.github/workflows/ci.yml` з тригерами `push` і `pull_request`, наявною matrix Ubuntu/Windows/macOS та описаними кроками.

## Команди перевірки

- Перевір YAML-синтаксис за допомогою наявного валідатора, наприклад `actionlint` або доступного YAML-парсера.
- Переконайся, що workflow містить `ubuntu-latest`, `windows-latest`, `macos-latest`, `bash ci.sh`, `actions/checkout@v4`, `actions/upload-artifact@v4`, `hello-${{ matrix.os }}` і `if-no-files-found: error`.
- Переконайся, що workflow не має окремих команд CMake/CTest або кроку встановлення CMake.

## Повідомлення про помилку

Якщо workflow має конфлікт із наявними тригерами чи matrix, зупинись і поясни його, не видаляючи та не замінюючи наявні налаштування. Якщо валідатор відсутній або YAML некоректний, повідом про це явно.
