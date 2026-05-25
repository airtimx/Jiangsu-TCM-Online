# Spec — 04 课程与视频（course-video）

| 项 | 内容 |
|---|---|
| 波次 | W2 |
| 前置 | 01, 00(OSS) |
| Flyway | V040–V049 |
| 端 | BE + Admin + 页面 |

## Scope

**In scope**
- 课程 CRUD、审核、封面、讲师、学时
- 课程视频集：上传、排序、预览
- 关联考卷 ID（09 模块试卷，仅存 foreign key）
- 小程序：视频列表、播放器、进度上报（07）

**Out of scope**
- 考卷逻辑（09）
- 专题绑定（08）

## Acceptance Criteria

- [ ] 视频上传走 OSS 预签名
- [ ] 审核通过后 app 可播放
- [ ] 播放进度上报接口可被 07 消费
