# Shift Manager & Scheduler

シフト管理を効率化する Web アプリ（Rails 製）

## 🔧 使用技術

- Ruby on Rails 7
- SQLite3（開発用）
- Stimulus.js
- Vanilla CSS
- Devise（ログイン機能）

## 📌 管理者画面の機能（Shift Manager）

- ユーザ一覧表示・登録
- プロジェクト一覧表示・登録
- 習熟度プルダウン編集（select タグ + 自動更新対応）

## 📌 スタッフ画面の機能（Shift Scheduler）

- シフト希望登録（Ajax 対応）
- モーダル UI 表示
- 勤務一覧表示

## 🚀 起動方法

```bash
bundle install
bin/rails db:setup
bin/dev
```
