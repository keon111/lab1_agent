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

