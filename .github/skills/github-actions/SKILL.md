---
name: github-actions
description: Створює GitHub Actions CI для збірки, тестування та публікації виконуваного файла на Windows, Linux і macOS.
---

# github-actions

## Коли застосовувати

Застосовуй цей skill, коли проєкту потрібна автоматична перевірка C++ збірки та unit-тестів у GitHub Actions на трьох основних операційних системах.

## Вхідні дані

- Репозиторій із `ci.sh`, який збирає проєкт у `build/`.
- Відомі назви цілей CMake та розташування виконуваних файлів.
- Гілки, для яких має запускатися CI: назви яких містять `develop` або `master`.

## Вихідні файли

- `.github/workflows/ci.yml` з:
  - тригерами `push` і `pull_request`, налаштованими на гілки, що містять `develop` або `master`;
  - однією job `cross_build`, матрицею `ubuntu-latest`, `windows-latest`, `macos-latest` і `fail-fast: false`;
  - лише кроками checkout через `actions/checkout@v4`, запуску `bash ci.sh` із `shell: bash` і завантаження артефакту в кроці `Deploy`;
  - без команд `cmake` чи `ctest`, кроку встановлення CMake або окремого кроку `Run Unit Tests`: усю конфігурацію, збірку й тестування виконує `ci.sh`;
  - кроком Deploy на основі `actions/upload-artifact@v4`, з унікальною назвою артефакту `hello-${{ matrix.os }}`, `if-no-files-found: error` і шляхами `build/hello` та `build/Release/hello.exe`.

Використовуй glob-шаблони гілок, що покривають будь-які назви з підрядками `develop` або `master` (наприклад, `**develop**` і `**master**`). Не змінюй наявні тригери та matrix. Не додавай до workflow окремих команд збірки чи тестування: їх виконує `ci.sh`.

## Перевірки

- Перевір YAML-синтаксис і наявність обох тригерів та шаблонів гілок.
- Переконайся, що job називається `cross_build`, перелічує всі три runner-и та має `fail-fast: false`.
- Перевір, що workflow має лише кроки checkout (`actions/checkout@v4`), запуску `bash ci.sh` із `shell: bash` і Deploy (`actions/upload-artifact@v4`) у цьому порядку.
- Переконайся, що workflow не містить команд `cmake`/`ctest`, кроку встановлення CMake або окремого кроку `Run Unit Tests`; збірку й тести виконує `ci.sh`.
- Переконайся, що Deploy задає унікальну назву `hello-${{ matrix.os }}`, `if-no-files-found: error` і шляхи `build/hello` та `build/Release/hello.exe`.
- Перевір відповідність шляхів артефактів результатам Unix- і Windows-збірок.

## Приклад входу

> Додай CI workflow для гілок develop і master на Ubuntu, Windows та macOS: збери через ci.sh, запусти CTest і завантаж виконуваний файл.

## Типовий сценарій помилки

Крок Deploy не знаходить артефакт на одному з runner-ів через різне розташування виконуваних файлів. Узгодь шляхи з генератором CMake: Unix використовує `build/hello`, а багатоконфігураційна збірка Windows — `build/Release/hello.exe`.

`Failed to CreateArtifact: artifact name conflict` виникає, коли різні runner-и використовують однакову назву артефакту. Задай назву з ідентифікатором ОС, наприклад `hello-${{ matrix.os }}`, щоб назва була унікальною для кожної ОС.
