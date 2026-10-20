---
description: "Налаштуй CMake, GoogleTest, CTest і кросплатформні скрипти збірки за skill build-and-test."
agent: agent
---

# create-build

Виконуй усі дії ідемпотентно: повторний запуск не руйнує і не дублює файли чи конфігурації.

## Передумови

- Поточний робочий каталог — корінь проєкту.
- `src/main.cpp` існує або створюється командою `create-project`.
- Прочитай наявні CMake-файли, скрипти збірки, вихідні файли й тести перед редагуванням.
- Доступний skill [build-and-test](../skills/build-and-test/SKILL.md).

## Дії

1. Застосуй усі вимоги й перевірки skill [build-and-test](../skills/build-and-test/SKILL.md).
2. Створи або узгоджено доповни кореневий `CMakeLists.txt`, `src/math_operations.h`, `src/math_operations.cpp`, `tests/unit_tests.cpp`, `ci.sh` і `ci.bat`.
3. Використовуй C++17, виконуваний файл `hello`, статичну `math_lib` із `PUBLIC` include-каталогом `src/`, GoogleTest через FetchContent v1.14.0, `gtest_force_shared_crt ON`, `enable_testing()` і `gtest_discover_tests`.
4. Скрипти в корені не приймають параметрів; вони конфігурують, збирають Release і запускають CTest. Забезпеч ненульовий код завершення при будь-якій помилці й повторно безпечне створення `build/`.
5. Збережи сумісність зі структурою `src/` та `tests/`; не перезаписуй наявний корисний вміст без перевірки.

## Очікувані файли

- `CMakeLists.txt`
- `src/math_operations.h`
- `src/math_operations.cpp`
- `tests/unit_tests.cpp` з тестом `BasicAddition`
- `ci.sh`
- `ci.bat`
- Згенеровані артефакти збірки в `build/` після перевірки; не додавай їх до Git.

## Команди перевірки

- Linux/macOS: `bash ci.sh`
- Windows: `ci.bat`
- Після збірки: `ctest --test-dir build -C Release --output-on-failure`
- Переконайся, що ціль `hello` зібрана і CTest успішно запускає `BasicAddition`.

## Повідомлення про помилку

Якщо конфігурація, завантаження FetchContent, збірка або будь-який тест не пройшов, зупинись, повідом про невдалу команду та її помилку; не оголошуй створення build-конфігурації успішним.
