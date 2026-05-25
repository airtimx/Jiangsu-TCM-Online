# Design — 13 直播

## 表

`live_session`（title, start_time, status, room_id, playback_url, topic_id, audit_status）

## LiveProvider 接口

```java
createRoom(config) -> roomId
getPlayUrl(roomId) -> url
onCallback(event)
```

## API

- Admin: CRUD + audit
- App: `GET /api/app/v1/live`, `GET /live/{id}/play`

## 并行

与 10/11/12 完全独立，W3 专人负责

## Admin：图13.1–13.2
