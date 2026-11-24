#!/usr/bin/env python3
"""
Скрипт автоматического создания меток и 8 Issues через GitHub REST API.
Не требует установки сторонних библиотек (использует только стандартный модуль urllib).

Использование:
  python scripts/create_issues.py --repo ВАШ_АККАУНТ/it-team --token ВАШ_GITHUB_TOKEN
  
Или через переменную окружения:
  export GITHUB_TOKEN=ghp_xxxx
  python scripts/create_issues.py --repo ВАШ_АККАУНТ/it-team
"""

import sys
import os
import json
import argparse
import urllib.request
import urllib.error

LABELS = [
    {"name": "lab-task", "color": "8B5CF6", "description": "Учебное практическое задание"},
    {"name": "student-1", "color": "6366F1", "description": "Задание для студента 1"},
    {"name": "student-2", "color": "6366F1", "description": "Задание для студента 2"},
    {"name": "student-3", "color": "6366F1", "description": "Задание для студента 3"},
    {"name": "student-4", "color": "6366F1", "description": "Задание для студента 4"},
    {"name": "student-5", "color": "6366F1", "description": "Задание для студента 5"},
    {"name": "student-6", "color": "6366F1", "description": "Задание для студента 6"},
    {"name": "student-7", "color": "6366F1", "description": "Задание для студента 7"},
    {"name": "student-8", "color": "6366F1", "description": "Задание для студента 8"},
]

TASKS = [
    {
        "num": 1,
        "title": "[Task 1] Заполнение страницы участников команды (pages/team.html)",
        "file": "pages/team.html",
        "branch": "feature/team-members",
        "commit": "feat: добавить карточки участников команды",
        "desc": "Заполнить информацию о ключевых участниках команды (минимум 3 карточки по шаблону)."
    },
    {
        "num": 2,
        "title": "[Task 2] Заполнение страницы проектов команды (pages/projects.html)",
        "file": "pages/projects.html",
        "branch": "feature/projects-list",
        "commit": "feat: добавить описание проектов команды",
        "desc": "Добавить описание учебных и открытых проектов команды, статусы и технологии."
    },
    {
        "num": 3,
        "title": "[Task 3] Заполнение страницы технологического стека (pages/technologies.html)",
        "file": "pages/technologies.html",
        "branch": "feature/technologies-stack",
        "commit": "feat: описать технологический стек",
        "desc": "Систематизировать стек разработки: Frontend, Backend, DevOps, базы данных."
    },
    {
        "num": 4,
        "title": "[Task 4] Заполнение страницы «О команде» (pages/about.html)",
        "file": "pages/about.html",
        "branch": "feature/about-us",
        "commit": "feat: добавить историю и принципы команды",
        "desc": "Описать историю основания сообщества, цели и культуру совместной работы."
    },
    {
        "num": 5,
        "title": "[Task 5] Заполнение страницы контактов (pages/contacts.html)",
        "file": "pages/contacts.html",
        "branch": "feature/contacts-info",
        "commit": "feat: добавить контактную информацию",
        "desc": "Оформить карточки публичных каналов связи (без личных персональных данных!)."
    },
    {
        "num": 6,
        "title": "[Task 6] Заполнение страницы достижений (pages/achievements.html)",
        "file": "pages/achievements.html",
        "branch": "feature/achievements-list",
        "commit": "feat: оформить карточки достижений",
        "desc": "Осветить награды, призовые места на хакатонах и вехи развития команды."
    },
    {
        "num": 7,
        "title": "[Task 7] Заполнение страницы мероприятий (pages/events.html)",
        "file": "pages/events.html",
        "branch": "feature/events-schedule",
        "commit": "feat: добавить расписание мероприятий",
        "desc": "Сформировать календарь митапов, воркшопов и презентаций команды."
    },
    {
        "num": 8,
        "title": "[Task 8] Заполнение страницы полезных ресурсов (pages/resources.html)",
        "file": "pages/resources.html",
        "branch": "feature/learning-resources",
        "commit": "feat: добавить список полезных ресурсов",
        "desc": "Собрать подборку качественных обучающих ссылок по Git и веб-технологиям."
    }
]

def ensure_labels(repo: str, token: str):
    url = f"https://api.github.com/repos/{repo}/labels"
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "User-Agent": "IT-Team-Lab-Setup"
    }
    print("Проверка и создание меток (labels)...")
    for lbl in LABELS:
        payload = json.dumps(lbl).encode("utf-8")
        req = urllib.request.Request(url, data=payload, headers=headers, method="POST")
        try:
            with urllib.request.urlopen(req) as resp:
                pass
        except urllib.error.HTTPError as e:
            # 422: метка уже существует, это нормально
            if e.code != 422:
                print(f"Предупреждение по метке {lbl['name']}: {e.code}")

def create_issue(repo: str, token: str, task: dict):
    url = f"https://api.github.com/repos/{repo}/issues"
    body = f"""### Учебное задание №{task['num']}
- **Файл для изменения:** `{task['file']}`
- **Рекомендуемая ветка:** `{task['branch']}`
- **Пример названия коммита:** `{task['commit']}`

#### Задача:
{task['desc']}

#### Алгоритм выполнения:
1. Замените блок заглушки `.stub-box` в `{task['file']}` по образцу из `pages/template.html`.
2. Проверьте результат локально в браузере.
3. Сделайте коммит в ветку `{task['branch']}` и отправьте в личный форк.
4. Откройте Pull Request в основной репозиторий преподавателя.
"""

    payload = {
        "title": task["title"],
        "body": body,
        "labels": ["lab-task", f"student-{task['num']}"]
    }
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "User-Agent": "IT-Team-Lab-Setup"
    }

    req = urllib.request.Request(
        url, 
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST"
    )

    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            print(f"[{task['num']}/8] Создана: {data['html_url']}")
    except urllib.error.HTTPError as e:
        err_msg = e.read().decode("utf-8")
        print(f"Ошибка при создании задачи #{task['num']}: HTTP {e.code} - {err_msg}", file=sys.stderr)

def main():
    parser = argparse.ArgumentParser(description="Автоматическое создание 8 Issues в GitHub репозитории")
    parser.add_argument("--repo", required=True, help="Репозиторий в формате owner/repo (например: octocat/it-team)")
    parser.add_argument("--token", default=os.environ.get("GITHUB_TOKEN"), help="GitHub Personal Access Token (PAT)")
    args = parser.parse_args()

    if not args.token:
        print("Ошибка: укажите GitHub токен через --token или переменную GITHUB_TOKEN", file=sys.stderr)
        sys.exit(1)

    ensure_labels(args.repo, args.token)

    print(f"Создание 8 учебных задач в репозитории {args.repo}...")
    for task in TASKS:
        create_issue(args.repo, args.token, task)
    print("Готово! Все задачи успешно созданы.")

if __name__ == "__main__":
    main()
