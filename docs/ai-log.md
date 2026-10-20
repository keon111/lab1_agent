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
