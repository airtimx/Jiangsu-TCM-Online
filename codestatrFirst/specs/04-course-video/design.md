# Design — 04 课程与视频

## 表

`course`, `course_video`（course_id, title, duration_sec, oss_key, sort_no, audit_status）

## API

- Admin: CRUD `/api/admin/v1/courses`, `/courses/{id}/videos`, audit
- App: `GET /api/app/v1/courses/{id}`, `GET .../videos`, `GET .../videos/{vid}/play-url`

## 并行

- BE 视频表 + AD 列表页 与 MP 播放器 UI（Mock play-url）同时进行
- 与 05/06 无代码依赖，仅共享 OSS 工具类

## Admin

图5.1–5.2：`/content/courses`
