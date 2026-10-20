# Лог запитів до GitHub Copilot

Лабораторна робота №1, варіант 1. Режим Copilot: Agent.

## Запит 1. Manifest агента

**Промпт:**

```
Створи файл .github/agents/build-engineer.agent.md. Це AI-агент, який автоматизує створення кросплатформного C++ проєкту Hello World (CMake, GoogleTest, CTest, GitHub Actions на Windows/Linux/macOS). Manifest має містити: роль, область відповідальності, правила роботи з файлами (повторний запуск не руйнує і не дублює існуюче), заборонені дії (видалення файлів, force push, секрети, зміна захисту гілок), список skills і критерії успішного завершення (cmake збирає виконуваний файл hello, тест BasicAddition проходить у ctest, каталог build/ не в Git).
```

**Результат:** створено `.github/agents/build-engineer.agent.md` з секціями: роль, область відповідальності, правила роботи з файлами, заборонені дії, skills, критерії успішного завершення.

**Зауваження:** у frontmatter не було поля `tools`, тому агент міг не отримати доступу до файлів і терміналу. Секція Skills містила загальні вміння, а не посилання на конкретні skill-файли, і не було секції Commands.

## Запит 1.1. Виправлення manifest

**Промпт:**

```
Онови .github/agents/build-engineer.agent.md: (1) у frontmatter додай поле tools зі списком інструментів, потрібних для роботи з файлами, терміналом і пошуком по репозиторію; (2) заміни секцію Skills на список трьох конкретних skills із посиланнями на файли: .github/skills/project-scaffold/SKILL.md, .github/skills/build-and-test/SKILL.md, .github/skills/github-actions/SKILL.md, з одним реченням про призначення кожного; (3) додай секцію Commands зі списком prompt-файлів у .github/prompts/ (git-init, create-project, create-build, create-actions, check, init) та поясненням, що init запускає їх послідовно; (4) переконайся, що файл починається з --- і не містить службових обгорток типу ```chatagent. Решту вмісту не змінюй.
```

**Результат:** у frontmatter додано `tools: ["read", "edit", "search", "runInTerminal"]`, секцію Skills замінено на три посилання з описами, додано секцію Commands із шістьма prompt-файлами. Решту вмісту збережено.

## Запит 2. Skills

**Промпт:**

```
Створи три skills: .github/skills/project-scaffold/SKILL.md, .github/skills/build-and-test/SKILL.md, .github/skills/github-actions/SKILL.md. Кожен SKILL.md має починатися з YAML frontmatter з полями name (збігається з назвою папки) і description. У кожному: коли застосовувати, вхідні дані, вихідні файли, перевірки, приклад входу, типовий сценарій помилки. project-scaffold створює main.cpp з Hello World, README.md і .gitignore (build/). build-and-test створює CMakeLists.txt (C++17, виконуваний файл hello, статична бібліотека math_lib, GoogleTest через FetchContent v1.14.0, gtest_force_shared_crt ON, enable_testing, gtest_discover_tests), math_operations.h і math_operations.cpp з функцією int add(int a, int b), tests/unit_tests.cpp з тестом BasicAddition, ci.sh і ci.bat (mkdir build, cd build, cmake .., cmake --build . --config Release, ctest -C Release --output-on-failure; без параметрів). github-actions створює .github/workflows/ci.yml: тригер push і pull_request для гілок із develop або master у назві, одна job cross_build з matrix ubuntu-latest/windows-latest/macos-latest і fail-fast false, кроки: actions/checkout@v4, встановлення CMake, запуск bash ci.sh (shell: bash), крок Run Unit Tests через ctest, крок Deploy через actions/upload-artifact@v4 з виконуваним файлом hello (build/hello та build/Release/hello.exe).
```

**Результат:** створено три файли `SKILL.md` (project-scaffold, build-and-test, github-actions) з YAML frontmatter і розділами: коли застосовувати, вхідні дані, вихідні файли, перевірки, приклад входу, типовий сценарій помилки.

**Зауваження:**
1. Вихідні файли C++ розміщені в корені, а за методичкою вони мають лежати в `src/`.
2. Skill github-actions описує окремі кроки встановлення CMake і запуску тестів у `ci.yml`, а за методичкою workflow має лише запускати скрипт збірки.
3. Не вказано унікальну назву артефакту для кожної ОС: у `actions/upload-artifact@v4` однакові назви в matrix-job'ах спричиняють конфлікт, і CI впав би на двох з трьох ОС.

## Запит 2.2. Узгодження skills з вимогами методички

**Промпт:**

```
Онови skills відповідно до нової структури репозиторію та вимог до CI. (1) project-scaffold/SKILL.md: main.cpp створюється в src/main.cpp, README.md і .gitignore лишаються в корені; перевірка наявності src/main.cpp та команда запуску: ./build/hello (Linux/macOS) і build\Release\hello.exe (Windows). (2) build-and-test/SKILL.md: math_operations.h і math_operations.cpp лежать у src/, тест у tests/unit_tests.cpp; CMakeLists.txt у корені збирає hello з src/main.cpp і статичну math_lib з src/math_operations.cpp з PUBLIC include-каталогом src/; ci.sh і ci.bat у корені виконують конфігурацію, збірку та запуск ctest і повертають ненульовий код при будь-якій помилці. (3) github-actions/SKILL.md: ci.yml не містить власних команд cmake/ctest, кроку встановлення CMake та окремого кроку Run Unit Tests; лише checkout через actions/checkout@v4, запуск скрипта (bash ci.sh, shell: bash) і actions/upload-artifact@v4 з виконуваним файлом hello (шляхи build/hello та build/Release/hello.exe); всю збірку і тестування виконує ci.sh. Назва артефакту унікальна для кожної ОС: name: hello-${{ matrix.os }}, і if-no-files-found: error. Тригери та matrix не змінюй. Онови розділи "Вихідні файли", "Перевірки" і "Типовий сценарій помилки", додай другий сценарій помилки: "Failed to CreateArtifact: artifact name conflict" при однакових назвах артефактів, з рішенням. Решту вмісту не змінюй.
```

**Причина:** за методичкою вихідний код має лежати в

## Запит 3. Commands

**Промпт:**

```
Створи в .github/prompts/ шість файлів: git-init.prompt.md, create-project.prompt.md, create-build.prompt.md, create-actions.prompt.md, check.prompt.md, init.prompt.md. Кожен починається з YAML frontmatter (description, agent: agent). У кожному: передумови, дії, очікувані файли, команди перевірки, повідомлення про помилку. Усі commands ідемпотентні: повторний запуск не руйнує і не дублює файли чи конфігурації. git-init: перевіряє, що каталог є Git-репозиторієм, створює або доповнює .gitignore (build/, кеші, тимчасові файли), показує git status і поточну гілку, нічого не видаляє. create-project: застосовує skill project-scaffold. create-build: застосовує skill build-and-test. create-actions: застосовує skill github-actions. check: нічого не змінює; перевіряє наявність manifest, skills, commands і каталогів src/, tests/, docs/; запускає ci.sh або ci.bat; переконується, що створено виконуваний файл hello, що ctest знайшов і пройшов BasicAddition, що build/ не відстежується Git, що ci.yml є валідним YAML і містить ubuntu-latest, windows-latest, macos-latest; виводить підсумкову таблицю PASS/FAIL і завершується помилкою, якщо є хоч один FAIL. init: оркестратор, послідовно виконує git-init, create-project, create-build, create-actions, check; передає результат кожного кроку наступному, зупиняється на першій помилці з поясненням і не оголошує успіх без успішного check; наприкінці друкує звіт зі списком створених файлів.
```

**Результат:** створено шість prompt-файлів у `.github/prompts/`. Кожен має frontmatter (`description`, `agent: agent`) і розділи: передумови, дії, очікувані файли, команди перевірки, повідомлення про помилку. `git-init` перевіряє репозиторій і доповнює `.gitignore`, не виконуючи `git init`. `create-project`, `create-build`, `create-actions` застосовують відповідні skills. `check` лише перевіряє (структуру, збірку, `BasicAddition`, ігнорування `build/`, YAML і три runner-и) та видає таблицю PASS/FAIL. `init` послідовно запускає п'ять команд, зупиняється на першій помилці й не оголошує успіх без успішного `check`. Frontmatter, розділи та `git diff --check` перевірені, помилок немає.

**Зауваження:** `check` не перевіряє відсутність секретів і чутливих файлів у Git, а методичка (Етап 6) цього вимагає.

## Запит 3.1. Перевірка відсутності секретів у check

**Промпт:**

```
Онови .github/prompts/check.prompt.md: додай перевірку відсутності секретів і чутливих файлів у Git. У розділ "Дії" додай крок: переглянь git ls-files і переконайся, що серед відстежуваних файлів немає .env, *.pem, *.key, id_rsa*; знайди у відстежуваних файлах (git grep) типові ознаки токенів і приватних ключів (ghp_, github_pat_, AKIA, BEGIN PRIVATE KEY), виключивши з пошуку сам .github/prompts/check.prompt.md, щоб він не спрацьовував на власні шаблони. Додай відповідний рядок "Відсутність секретів у Git" у підсумкову таблицю PASS/FAIL та в розділ "Команди перевірки". Решту вмісту не змінюй.
```

**Причина:** методичка (Етап 6) вимагає, щоб перевірка підтверджувала відсутність секретів у Git, а `check` цього не робив.

**Результат:** у `check.prompt.md` додано перевірку відстежуваних файлів (`.env`, `.env.*`, `*.pem`, `*.key`, `id_rsa*`), пошук ознак токенів і приватних ключів через `git grep` (сам prompt виключено), рядок «Відсутність секретів у Git» у підсумковій таблиці та відповідні команди перевірки. Змінено лише цей файл.

**Помилка:** шаблон `ghp_|github_pat_|AKIA|BEGIN PRIVATE KEY` збігається з будь-яким відстежуваним файлом, де ці слова просто згадані, зокрема з `docs/ai-log.md`. `check` завжди давав би `FAIL`, і `init` ніколи не завершувався б успіхом.

## Запит 3.2. Виправлення шаблону пошуку секретів

**Промпт:**

```
Онови .github/prompts/check.prompt.md: у перевірці секретів заміни простий шаблон git grep на точніший, щоб він збігався лише зі справжніми токенами та ключами, а не зі згадками цих слів у документації чи журналі: 'ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----'. Залиши виключення .github/prompts/check.prompt.md. Онови команду в розділах "Дії" та "Команди перевірки" однаково. Решту вмісту не змінюй.
```

**Причина:** попередній шаблон збігався зі згадками цих слів у відстежуваних файлах (зокрема в `docs/ai-log.md`), через що `check` завжди повертав `FAIL`.

**Результат:** обидві команди `git grep` у `check.prompt.md` (розділи «Дії» та «Команди перевірки») замінено на точний шаблон для токенів і маркерів приватних ключів, виключення `:(exclude).github/prompts/check.prompt.md` збережено. Команди ідентичні, старий шаблон відсутній, `git diff --check` пройшов.

**Прийняте рішення:** помилку виправлено через зміну інструкції команди, а не ручною правкою результату чи вилученням перевірки.

## Запит 4. Документація

**Промпт:**

```
Створи README.md (ПІП: Мосійчук Артур Ігорович, група: КІ-406, варіант 1: C++, CMake, GoogleTest/CTest, короткий опис проєкту, як запустити агента, як зібрати і запустити готовий проєкт), docs/architecture.md (проблеми, які вирішує агент; skills; commands; дані між етапами; обробка помилок оркестратором; таблиця відповідності кожного файлу агента його ролі з поясненням, що використано формат GitHub Copilot: .github/agents, .github/skills, .github/prompts) і docs/usage.md (точні команди запуску агента через /init, локальної перевірки через /check та ci.bat або ci.sh, і запуску зібраного hello на Windows, Linux і macOS).
```

**Результат:** створено три файли. `README.md`: дані студента, короткий опис, запуск `/init`, збірка, тести й запуск `hello` на Windows/Linux/macOS. `docs/architecture.md`: проблеми, які вирішує агент, skills, commands, передавання даних між етапами, обробка помилок оркестратором і таблиця відповідності файлів формату GitHub Copilot їхнім ролям. `docs/usage.md`: точні команди `/init`, `/check`, `ci.bat`/`ci.sh` і запуску виконуваного файла. Внутрішні посилання та `git diff --check` перевірені, збірку не запускали, бо змінено лише документацію.

**Зауваження:** помилок не виявлено, змін після генерації не вносилось.