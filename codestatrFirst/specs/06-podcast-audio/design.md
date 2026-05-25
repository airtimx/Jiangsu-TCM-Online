# Design — 06 播客与音频

## 表

`podcast`, `podcast_episode`（audio_key, duration_sec, sort_no）

## API

- Admin: `/api/admin/v1/podcasts`, episodes
- App: `GET /api/app/v1/podcasts/{id}/episodes`, play-url

## 并行

可与 04 完全并行（不同 Flyway 段、不同 BE 开发者）

## Admin：图8.1–8.2
