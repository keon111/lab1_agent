---
name: build-and-test
description: Налаштовує кросплатформну збірку C++17 із GoogleTest, CTest та скриптами перевірки для Windows і Unix.
---

# build-and-test

## Коли застосовувати

Застосовуй цей skill, коли базовий C++ проєкт потрібно налаштувати для збірки через CMake і автоматизованого виконання unit-тестів локально або в CI.

## Вхідні дані

- Корінь C++ проєкту з `src/main.cpp`.
- Потрібні назви цілей і тестів: `hello`, `math_lib` та `BasicAddition`.
- Середовище з CMake і компілятором C++17 для запуску перевірок.

## Вихідні файли

- `CMakeLists.txt`, який:
  - вимагає C++17;
  - розташований у корені та створює виконуваний файл `hello` із `src/main.cpp`;
  - створює статичну бібліотеку `math_lib` із `src/math_operations.cpp` і задає `src/` як `PUBLIC` include-каталог для заголовка `src/math_operations.h`;
  - підключає GoogleTest через `FetchContent` із тегом `v1.14.0`;
  - встановлює `gtest_force_shared_crt` у `ON` для сумісності з MSVC;
  - викликає `enable_testing()` і використовує `gtest_discover_tests`.
- `src/math_operations.h` із декларацією `int add(int a, int b);`.
- `src/math_operations.cpp` із реалізацією `add`.
- `tests/unit_tests.cpp` із GoogleTest-тестом `BasicAddition`.
- `ci.sh` у корені, який без параметрів створює `build/`, переходить у нього, виконує `cmake ..`, `cmake --build . --config Release` і `ctest -C Release --output-on-failure`.
- `ci.bat` у корені, який без параметрів виконує ті самі кроки у Windows.

Скрипти збірки не приймають параметрів. Зроби створення каталогу повторно безпечним: наприклад, у Bash використай `mkdir -p build`; у batch перевір наявність каталогу перед `mkdir`. Обидва скрипти мають конфігурувати проєкт, збирати його та запускати CTest, повертати ненульовий код і зупинятися при будь-якій помилці.

## Перевірки

- Запусти `ci.sh` на Unix-подібному середовищі або `ci.bat` у Windows без параметрів.
- Переконайся, що CMakeLists.txt у корені конфігурує проєкт і збирає `hello` із `src/main.cpp` та статичну ціль `math_lib` із `src/math_operations.cpp`.
- Переконайся, що `math_lib` оголошує `src/` як `PUBLIC` include-каталог, а `tests/unit_tests.cpp` збирається з доступом до `math_operations.h`.
- Переконайся, що CTest виявляє і успішно запускає `BasicAddition`.
- Переконайся, що скрипти запускають конфігурацію, збірку та CTest у заданому порядку й повертають ненульовий код при помилці будь-якого кроку.
- Не приховуй помилки завантаження FetchContent, конфігурації, компіляції чи тестування.

## Приклад входу

> Для наявного `src/main.cpp` додай CMake-збірку C++17, статичну math_lib із `src/` як PUBLIC include-каталогом, тест BasicAddition на GoogleTest v1.14.0 і скрипти ci.sh та ci.bat у корені.

## Типовий сценарій помилки

На Windows виникає конфлікт runtime-бібліотек між тестом і GoogleTest. Встанови `gtest_force_shared_crt` у `ON` до завантаження GoogleTest через FetchContent і перебудуй проєкт.
