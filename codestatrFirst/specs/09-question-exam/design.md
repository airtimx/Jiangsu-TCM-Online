# Design — 09 题库与测评

## 表

`question_bank`, `question`, `exam_paper`, `exam_paper_question`, `exam_record`, `exam_answer`

## API

- Admin: banks, questions, papers, import Excel
- App: `GET /api/app/v1/exams?topicId=`, `GET /papers/{id}`, `POST /papers/{id}/submit`

## 判分服务

`ExamGradingService` 独立类，便于单测

## 并行（W2 即可启动）

- BE 题库 + 判分与 08 无关
- AD 题库页与 MP 答题 UI 用 Mock 试卷
- 08 仅消费 `exam_paper_id`

## 门槛

提交前调 07：`summary.completedRatio >= topic.examThreshold`

## Admin：图11.1；App：图5.1–5.3
