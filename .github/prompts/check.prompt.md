---
description: "Перевір комплектність C++ проєкту, збірку, тест, Git ignore і CI workflow без редагування файлів."
agent: agent
---

# check

Ця команда нічого не змінює у вихідних файлах і конфігураціях. Запуск збірки може створити або оновити лише згенерований каталог `build/`.

## Передумови

- Поточний робочий каталог — корінь Git-репозиторію.
- Наявні CMake, компілятор C++17 і середовище для запуску відповідного скрипта.
- Для перевірки YAML має бути встановлений `actionlint`. Якщо його немає, користувач встановлює його сам командою `winget install rhysd.actionlint`; агент нічого не встановлює.

## Дії

1. Перевір наявність `.github/agents/build-engineer.agent.md`.
2. Перевір наявність skills: `.github/skills/project-scaffold/SKILL.md`, `.github/skills/build-and-test/SKILL.md`, `.github/skills/github-actions/SKILL.md`.
3. Перевір наявність усіх commands: `.github/prompts/git-init.prompt.md`, `create-project.prompt.md`, `create-build.prompt.md`, `create-actions.prompt.md`, `check.prompt.md`, `init.prompt.md`.
4. Перевір наявність каталогів `src/`, `tests/` і `docs/`.
5. Запусти `bash ci.sh` на Linux/macOS або `ci.bat` на Windows; зафіксуй успіх або помилку команди.
6. Переконайся, що виконуваний файл існує (`build/hello` на Linux/macOS або `build/Release/hello.exe` на Windows).
7. Запусти `ctest --test-dir build -C Release --output-on-failure`; перевір, що CTest знайшов і пройшов саме `BasicAddition`.
8. Переконайся, що `build/` не відстежується Git: `git check-ignore build/` має підтвердити ігнорування, а `git ls-files build/` не має виводити відстежуваних файлів.
9. Запусти `actionlint .github/workflows/ci.yml`; перевірка YAML успішна лише з кодом завершення `0`. Також переконайся, що файл містить `ubuntu-latest`, `windows-latest` і `macos-latest`. Якщо `actionlint` відсутній або команда повертає ненульовий код, познач перевірку як `FAIL`; за відсутності інструмента поясни, що користувач має встановити його командою `winget install rhysd.actionlint`, не встановлюй його самостійно.
10. Переглянь `git ls-files` і переконайся, що серед відстежуваних файлів немає `.env`, `.env.*`, `*.pem`, `*.key` або `id_rsa*`. Запусти `git grep -I -n -E 'ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----' -- . ':(exclude).github/prompts/check.prompt.md'`, щоб знаходити лише справжні токени та маркери приватних ключів у відстежуваних файлах, виключивши цей prompt із пошуку. Якщо знайдено чутливий шлях або вміст, познач перевірку як `FAIL`; нічого не видаляй і не виводь знайдені секрети у звіті.
11. Виведи підсумкову таблицю зі стовпцями `Перевірка` і `Результат`, позначивши кожен пункт `PASS` або `FAIL`, зокрема рядок `Відсутність секретів у Git`. Заверш команду помилкою, якщо будь-який пункт має `FAIL`.

## Очікувані файли

- Не створюй і не змінюй файли проєкту, manifest, skills або prompts.
- Збірка може створити чи оновити лише згенеровані артефакти в `build/`; каталог має залишатися ігнорованим і невідстежуваним.
- Результат — підсумкова таблиця `PASS`/`FAIL` у відповіді.

## Команди перевірки

- Наявність файлів і каталогів: `Test-Path` у PowerShell або `test -e` у Bash.
- Linux/macOS збірка: `bash ci.sh`; Windows збірка: `ci.bat`.
- Тест: `ctest --test-dir build -C Release --output-on-failure`.
- Git ignore: `git check-ignore build/` і `git ls-files build/`.
- YAML: `actionlint .github/workflows/ci.yml` — успіх лише за кодом завершення `0`; якщо `actionlint` відсутній, познач `FAIL` і поясни встановлення командою `winget install rhysd.actionlint` (виконує користувач).
- Runner-и: переконайся, що `.github/workflows/ci.yml` містить `ubuntu-latest`, `windows-latest` і `macos-latest`.
- Відстежувані чутливі файли: `git ls-files -- ':(glob)**/.env*' ':(glob)**/*.pem' ':(glob)**/*.key' ':(glob)**/id_rsa*'`.
- Ознаки секретів і приватних ключів у відстежуваних файлах: `git grep -I -n -E 'ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----' -- . ':(exclude).github/prompts/check.prompt.md'`. Код завершення `1` означає, що збігів немає; якщо збіг є, познач `FAIL`, не повторюй секретне значення у звіті.

## Повідомлення про помилку

Якщо будь-яка перевірка не пройшла чи її неможливо виконати, познач її як `FAIL`, виведи причину й команду, що завершилася помилкою, та поверни ненульовий статус. Не приховуй пропуски перевірок і не оголошуй загальний успіх за наявності `FAIL`.
