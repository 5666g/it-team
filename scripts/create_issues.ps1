<#
.SYNOPSIS
    Автоматическое создание 8 учебных задач (Issues) через GitHub CLI (gh).
.DESCRIPTION
    Скрипт проверяет авторизацию в GitHub CLI и создаёт 8 Issues для лабораторной работы.
    Запуск: .\scripts\create_issues.ps1
#>

# Проверка наличия gh
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "Ошибка: GitHub CLI (gh) не установлен. Установите: winget install GitHub.cli" -ForegroundColor Red
    exit 1
}

# Проверка авторизации
gh auth status | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Вы не авторизованы в GitHub CLI. Выполните: gh auth login" -ForegroundColor Yellow
    exit 1
}

Write-Host "Создание 8 учебных задач через GitHub CLI..." -ForegroundColor Cyan

$issues = @(
    @{
        title = "[Task 1] Заполнение страницы участников команды (pages/team.html)"
        branch = "feature/team-members"
        file = "pages/team.html"
        commit = "feat: добавить карточки участников команды"
        desc = "Заполнить информацию о ключевых участниках команды (минимум 3 карточки)."
    },
    @{
        title = "[Task 2] Заполнение страницы проектов команды (pages/projects.html)"
        branch = "feature/projects-list"
        file = "pages/projects.html"
        commit = "feat: добавить описание проектов команды"
        desc = "Добавить описание проектов, статус разработки и используемые технологии."
    },
    @{
        title = "[Task 3] Заполнение страницы технологического стека (pages/technologies.html)"
        branch = "feature/technologies-stack"
        file = "pages/technologies.html"
        commit = "feat: описать технологический стек"
        desc = "Описать направления разработки (Frontend, Backend, DevOps) и инструменты."
    },
    @{
        title = "[Task 4] Заполнение страницы «О команде» (pages/about.html)"
        branch = "feature/about-us"
        file = "pages/about.html"
        commit = "feat: добавить историю и принципы команды"
        desc = "Описать историю команды, главную миссию и ценности сотрудничества."
    },
    @{
        title = "[Task 5] Заполнение страницы контактов (pages/contacts.html)"
        branch = "feature/contacts-info"
        file = "pages/contacts.html"
        commit = "feat: добавить контактную информацию"
        desc = "Разместить карточки официальных каналов связи (без личных данных!)."
    },
    @{
        title = "[Task 6] Заполнение страницы достижений (pages/achievements.html)"
        branch = "feature/achievements-list"
        file = "pages/achievements.html"
        commit = "feat: оформить карточки достижений"
        desc = "Добавить награды, победы в хакатонах и вехи развития команды."
    },
    @{
        title = "[Task 7] Заполнение страницы мероприятий (pages/events.html)"
        branch = "feature/events-schedule"
        file = "pages/events.html"
        commit = "feat: добавить расписание мероприятий"
        desc = "Сформировать календарь митапов, воркшопов и сессий код-ревью."
    },
    @{
        title = "[Task 8] Заполнение страницы полезных ресурсов (pages/resources.html)"
        branch = "feature/learning-resources"
        file = "pages/resources.html"
        commit = "feat: добавить список полезных ресурсов"
        desc = "Подготовить подборку полезных ссылок по Git и веб-технологиям."
    }
)

$i = 1
foreach ($task in $issues) {
    $body = @"
### Учебное задание №$i
- **Файл для изменения:** `${task.file}`
- **Рекомендуемая ветка:** `${task.branch}`
- **Пример названия коммита:** `${task.commit}`

#### Задача:
${task.desc}

#### Алгоритм выполнения:
1. Замените блок заглушки `.stub-box` в `${task.file}` по образцу из `pages/template.html`.
2. Проверьте результат локально в браузере.
3. Сделайте коммит в ветку `${task.branch}` и отправьте в личный форк.
4. Откройте Pull Request в основной репозиторий преподавателя.
"@

    Write-Host "Создание: $($task.title)..." -NoNewline
    gh issue create --title $task.title --body $body --label "lab-task,student-$i" | Out-Null
    Write-Host " [OK]" -ForegroundColor Green
    $i++
}

Write-Host "`nВсе 8 задач успешно созданы во вкладке Issues репозитория!" -ForegroundColor Green
