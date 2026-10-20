---
description: "Перевір комплектність C++ проєкту, збірку, тест, Git ignore і CI workflow без редагування файлів."
agent: agent
---

# check

Ця команда нічого не змінює у вихідних файлах і конфігураціях. Запуск збірки може створити або оновити лише згенерований каталог `build/`.

## Передумови

- Поточний робочий каталог — корінь Git-репозиторію.
- Наявні CMake, компілятор C++17 і середовище для запуску відповідного скрипта.
- Для перевірки YAML доступний `actionlint` або локально встановлений YAML-парсер; не встановлюй залежності та не змінюй файли.

## Дії

1. Перевір наявність `.github/agents/build-engineer.agent.md`.
2. Перевір наявність skills: `.github/skills/project-scaffold/SKILL.md`, `.github/skills/build-and-test/SKILL.md`, `.github/skills/github-actions/SKILL.md`.
3. Перевір наявність усіх commands: `.github/prompts/git-init.prompt.md`, `create-project.prompt.md`, `create-build.prompt.md`, `create-actions.prompt.md`, `check.prompt.md`, `init.prompt.md`.
4. Перевір наявність каталогів `src/`, `tests/` і `docs/`.
5. Запусти `bash ci.sh` на Linux/macOS або `ci.bat` на Windows; зафіксуй успіх або помилку команди.
6. Переконайся, що виконуваний файл існує (`build/hello` на Linux/macOS або `build/Release/hello.exe` на Windows).
7. Запусти `ctest --test-dir build -C Release --output-on-failure`; перевір, що CTest знайшов і пройшов саме `BasicAddition`.
8. Переконайся, що `build/` не відстежується Git: `git check-ignore build/` має підтвердити ігнорування, а `git ls-files build/` не має виводити відстежуваних файлів.
9. Перевір YAML-синтаксис `.github/workflows/ci.yml` доступним локальним валідатором. Переконайся, що файл містить `ubuntu-latest`, `windows-latest` і `macos-latest`.
10. Виведи підсумкову таблицю зі стовпцями `Перевірка` і `Результат`, позначивши кожен пункт `PASS` або `FAIL`. Заверш команду помилкою, якщо будь-який пункт має `FAIL`.

## Очікувані файли

- Не створюй і не змінюй файли проєкту, manifest, skills або prompts.
- Збірка може створити чи оновити лише згенеровані артефакти в `build/`; каталог має залишатися ігнорованим і невідстежуваним.
- Результат — підсумкова таблиця `PASS`/`FAIL` у відповіді.

## Команди перевірки

- Наявність файлів і каталогів: `Test-Path` у PowerShell або `test -e` у Bash.
- Linux/macOS збірка: `bash ci.sh`; Windows збірка: `ci.bat`.
- Тест: `ctest --test-dir build -C Release --output-on-failure`.
- Git ignore: `git check-ignore build/` і `git ls-files build/`.
- YAML і runner-и: `actionlint .github/workflows/ci.yml` (якщо доступний), або інший локальний YAML-валідатор та пошук трьох назв runner-ів.

## Повідомлення про помилку

Якщо будь-яка перевірка не пройшла чи її неможливо виконати, познач її як `FAIL`, виведи причину й команду, що завершилася помилкою, та поверни ненульовий статус. Не приховуй пропуски перевірок і не оголошуй загальний успіх за наявності `FAIL`.
