#!/usr/bin/env bash
# Автоматическое создание 8 учебных задач (Issues) через GitHub CLI (gh)
# Запуск: ./scripts/create_issues.sh

set -e

if ! command -v gh &> /dev/null; then
    echo "Ошибка: GitHub CLI (gh) не установлен."
    echo "Установка: https://cli.github.com/ или sudo apt install gh / brew install gh"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Вы не авторизованы в GitHub CLI. Выполните: gh auth login"
    exit 1
fi

echo "Создание 8 учебных задач через GitHub CLI..."

tasks=(
    "Заполнение страницы участников команды (pages/team.html):feature/team-members:pages/team.html:feat: добавить карточки участников команды:Заполнить информацию о ключевых участниках команды (минимум 3 карточки)."
    "Заполнение страницы проектов команды (pages/projects.html):feature/projects-list:pages/projects.html:feat: добавить описание проектов команды:Добавить описание проектов, статус разработки и используемые технологии."
    "Заполнение страницы технологического стека (pages/technologies.html):feature/technologies-stack:pages/technologies.html:feat: описать технологический стек:Описать направления разработки (Frontend, Backend, DevOps) и инструменты."
    "Заполнение страницы «О команде» (pages/about.html):feature/about-us:pages/about.html:feat: добавить историю и принципы команды:Описать историю команды, главную миссию и ценности сотрудничества."
    "Заполнение страницы контактов (pages/contacts.html):feature/contacts-info:pages/contacts.html:feat: добавить контактную информацию:Разместить карточки официальных каналов связи (без личных данных!)."
    "Заполнение страницы достижений (pages/achievements.html):feature/achievements-list:pages/achievements.html:feat: оформить карточки достижений:Добавить награды, победы в хакатонах и вехи развития команды."
    "Заполнение страницы мероприятий (pages/events.html):feature/events-schedule:pages/events.html:feat: добавить расписание мероприятий:Сформировать календарь митапов, воркшопов и сессий код-ревью."
    "Заполнение страницы полезных ресурсов (pages/resources.html):feature/learning-resources:pages/resources.html:feat: добавить список полезных ресурсов:Подготовить подборку полезных ссылок по Git и веб-технологиям."
)

num=1
for item in "${tasks[@]}"; do
    IFS=":" read -r title branch file commit desc <<< "$item"
    
    body="### Учебное задание №$num
- **Файл для изменения:** \`$file\`
- **Рекомендуемая ветка:** \`$branch\`
- **Пример названия коммита:** \`$commit\`

#### Задача:
$desc

#### Алгоритм выполнения:
1. Замените блок заглушки \`.stub-box\` в \`$file\` по образцу из \`pages/template.html\`.
2. Проверьте результат локально в браузере.
3. Сделайте коммит в ветку \`$branch\` и отправьте в личный форк.
4. Откройте Pull Request в основной репозиторий преподавателя."

    echo -n "Создание [Task $num] $title..."
    gh issue create --title "[Task $num] $title" --body "$body" --label "lab-task,student-$num" > /dev/null
    echo " [OK]"
    num=$((num + 1))
done

echo "Все 8 задач успешно созданы!"
