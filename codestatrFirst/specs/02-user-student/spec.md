# Spec — 02 用户与学员（user-student）

| 项 | 内容 |
|---|---|
| 波次 | W1 |
| 前置 | 00, 01（JWT 可 Mock） |
| Flyway | V020–V029 |
| 端 | BE + Admin + 小程序 |

## Background

小程序微信用户与认证学员分离管理；管理端需用户查询、学员 CRUD、批量导入导出。

## Scope

**In scope**
- 微信 `code` 登录、自动注册 `app_user`
- 学员认证（姓名、手机、短信验证码、地区、单位）
- 管理端：用户管理（查改）、学员管理（增删改、导入导出）
- 学员与专题关联（供 08 使用）

**Out of scope**
- 学习统计展示（17）
- 短信服务商具体选型（抽象 SmsProvider）

## Acceptance Criteria

- [ ] 微信首次登录创建用户
- [ ] 学员认证通过后 `cert_status=CERTIFIED`
- [ ] Excel 导入校验失败行可下载错误报告
- [ ] 导出字段与手册图2.3 一致
