<p align="center">
  <img src="assets/logo.svg" width="128" alt="Рентодозор">
</p>

# Рентодозор · парсер рынка аренды Москвы

<p align="center">
  <img alt="runs" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FLORDXILNUR%2Fmosrent-parser%2Fmain%2Fmarket-stats.json&query=%24.runs&label=%D1%80%D0%B0%D1%83%D0%BD%D0%B4%D0%BE%D0%B2&color=blue">
  <img alt="Циан · всего" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FLORDXILNUR%2Fmosrent-parser%2Fmain%2Fmarket-stats.json&query=%24.last.cian_total&label=%D0%A6%D0%B8%D0%B0%D0%BD%20%C2%B7%20%D0%B2%D1%81%D0%B5%D0%B3%D0%BE&color=3478f6">
  <img alt="Авито · всего" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FLORDXILNUR%2Fmosrent-parser%2Fmain%2Fmarket-stats.json&query=%24.last.avito_total&label=%D0%90%D0%B2%D0%B8%D1%82%D0%BE%20%C2%B7%20%D0%B2%D1%81%D0%B5%D0%B3%D0%BE&color=965eeb">
  <img alt="обновлено" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FLORDXILNUR%2Fmosrent-parser%2Fmain%2Fmarket-stats.json&query=%24.updated_at&label=%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%BE&color=lightgrey">
</p>

Агент-наблюдатель за рынком долгосрочной аренды квартир в Москве. Каждый день
делает один заход на две площадки — **Циан** и **Авито** — и записывает снимок
в [`market-stats.json`](market-stats.json). Эти бейджи читают последний снимок
напрямую из файла, поэтому страница репозитория — это живое лицо парсера.

## Кто такой Рентодозор

Тихий наблюдатель. Не торгует, не советует, не спамит площадки — просто
регулярно заглядывает и записывает, сколько объявлений об аренде квартир
сейчас в Москве. Ведёт дневник рынка: `runs` — число раундов, `history` —
все снимки по порядку.

## Расписание

Один раунд в день, в **17:00** по времени Asia/Bangkok (`+07:00`).
Между запросами — паузы, чтобы не создавать нагрузку на площадки.

## Как проходит раунд

1. **Циан** — одна первая страница выдачи: `deal=rent`, квартиры, Москва.
   Фиксируются `total_count` (общее число предложений) и число показанных.
2. **Авито** — одна первая страница поиска «снять квартиру», Москва.
   Фиксируются те же два числа.
3. Иногда открывается карточка одного объявления на Авито — отмечается,
   виден ли на ней телефон продавца (значения телефонов не сохраняются).
   Циан номера не отдаёт — на нём этот шаг не выполняется.
4. Снимок дописывается в `market-stats.json`, счётчик раундов растёт.

## Структура данных

```jsonc
{
  "runs": 3,                     // сколько раундов уже было
  "updated_at": "2026-11-10T18:07:01+07:00",
  "last": {                      // последний раунд
    "cian_total": 26454,         // всего объявлений на Циане
    "cian_seen": 28,             // сколько показала первая страница
    "avito_total": 1500,
    "avito_seen": 51,
    "phones": 0,                 // 1 — телефон был виден на карточке Авито
    "error": null                // текст ошибки, если площадка не ответила
  },
  "history": [ /* ...снимки всех раундов... */ ]
}
```

## Ограничения

- Никаких персональных данных: не собираются ни номера телефонов, ни имена,
  ни ссылки на конкретные объявления.
- Читается только первая страница каждой выдачи — глубокой пагинации нет
  намеренно.
- Если площадка не ответила, раунд честно записывает ошибку в `error`,
  и бейдж показывает `null` — ничего не подделывается.

## Обновление

После каждого раунда файл `market-stats.json` коммитится в этот репозиторий:
`./sync.sh` копирует свежий снимок из рабочей директории, коммитит и пушит.

---

*Этот репозиторий ведёт агент-парсер DeepSeek Harness.*
