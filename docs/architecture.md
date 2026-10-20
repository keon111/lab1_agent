# Архітектура агента Build Engineer

## Проблеми, які вирішує агент

Build Engineer автоматизує повторювані завдання підготовки кросплатформного навчального C++ проєкту:

- створення базового Hello World із передбачуваною структурою каталогів;
- конфігурацію CMake для C++17, статичної бібліотеки й виконуваного файла;
- підключення GoogleTest та реєстрацію тестів у CTest;
- створення скриптів збірки з коректним кодом завершення при помилках;
- налаштування GitHub Actions для Windows, Linux і macOS;
- перевірку структури, збірки, тестів і стану Git, зокрема наявності випадково відстежуваних секретів.

Повторний запуск має зберігати наявний вміст і не дублювати правила чи конфігурації.

## Skills

Skills описують багаторазові процедури та критерії якості для окремих областей:

| Skill | Призначення |
|---|---|
| [project-scaffold](../.github/skills/project-scaffold/SKILL.md) | Створює `src/main.cpp`, кореневі `README.md` і `.gitignore`. |
| [build-and-test](../.github/skills/build-and-test/SKILL.md) | Описує CMake, `math_lib`, GoogleTest/CTest, unit-тест і скрипти `ci.sh`/`ci.bat`. |
| [github-actions](../.github/skills/github-actions/SKILL.md) | Визначає CI workflow, матрицю ОС, запуск скрипту та завантаження артефактів. |

## Commands

Commands — це сфокусовані prompt-файли у `.github/prompts/`, які можна викликати зі slash-команд у Copilot Chat:

| Command | Призначення |
|---|---|
| [git-init](../.github/prompts/git-init.prompt.md) | Перевіряє Git-репозиторій, ідемпотентно доповнює `.gitignore` і показує стан та гілку. |
| [create-project](../.github/prompts/create-project.prompt.md) | Застосовує `project-scaffold`. |
| [create-build](../.github/prompts/create-build.prompt.md) | Застосовує `build-and-test`. |
| [create-actions](../.github/prompts/create-actions.prompt.md) | Застосовує `github-actions`. |
| [check](../.github/prompts/check.prompt.md) | Перевіряє комплектність, збірку, CTest, Git ignore, секрети та CI. |
| [init](../.github/prompts/init.prompt.md) | Оркеструє команди підготовки та фінальну перевірку. |

## Передавання даних між етапами

Команда `init` виконує етапи послідовно, передаючи далі результати попередніх:

1. `git-init` передає стан репозиторію й оновлений `.gitignore`.
2. `create-project` створює базову структуру, зокрема `src/main.cpp`, і передає її збірковому етапу.
3. `create-build` додає CMake-конфігурацію, код `math_lib`, тест `BasicAddition` та скрипти `ci.sh`/`ci.bat`.
4. `create-actions` використовує скрипт збірки та визначені шляхи виконуваних файлів для формування workflow й артефактів.
5. `check` отримує повний результат: перевіряє файли, виконує збірку й тести, перевіряє Git та CI й формує таблицю `PASS`/`FAIL`.

## Обробка помилок оркестратором

`init` перевіряє результат кожної команди перед переходом до наступної. При першій помилці він зупиняється, повідомляє назву етапу та причину, а також зазначає, які кроки не виконані. Оркестратор не оголошує успіх і не друкує фінальний звіт про завершення, якщо `check` не закінчився успішно з усіма результатами `PASS`. Помилки конфігурації, компіляції, тестів чи workflow мають залишатися явними; їх не можна маскувати успішним статусом.

## Файли формату GitHub Copilot

Налаштування агента використовують формат GitHub Copilot у стандартних каталогах `.github/agents`, `.github/skills` і `.github/prompts`.

| Файл | Роль |
|---|---|
| [.github/agents/build-engineer.agent.md](../.github/agents/build-engineer.agent.md) | Custom agent: визначає роль Build Engineer, інструменти, область відповідальності, обмеження та критерії завершення. |
| [.github/skills/project-scaffold/SKILL.md](../.github/skills/project-scaffold/SKILL.md) | Skill із процедурою створення базової структури C++ проєкту. |
| [.github/skills/build-and-test/SKILL.md](../.github/skills/build-and-test/SKILL.md) | Skill для конфігурації збірки, тестів та скриптів перевірки. |
| [.github/skills/github-actions/SKILL.md](../.github/skills/github-actions/SKILL.md) | Skill для побудови кросплатформного CI workflow. |
| [.github/prompts/git-init.prompt.md](../.github/prompts/git-init.prompt.md) | Prompt-команда для перевірки Git і `.gitignore`. |
| [.github/prompts/create-project.prompt.md](../.github/prompts/create-project.prompt.md) | Prompt-команда для створення стартових файлів проєкту. |
| [.github/prompts/create-build.prompt.md](../.github/prompts/create-build.prompt.md) | Prompt-команда для конфігурації збірки та тестування. |
| [.github/prompts/create-actions.prompt.md](../.github/prompts/create-actions.prompt.md) | Prompt-команда для створення CI workflow. |
| [.github/prompts/check.prompt.md](../.github/prompts/check.prompt.md) | Prompt-команда перевірки безпеки й готовності проєкту. |
| [.github/prompts/init.prompt.md](../.github/prompts/init.prompt.md) | Prompt-команда оркестрації повного процесу. |
