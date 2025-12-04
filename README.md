# かぞくクエスト

## アプリ概要
家事と育児タスクを「クエスト」として記録し、完了するとポイントが貯まる家庭向けゲーミフィケーションアプリ。

## ユーザー画面の要件

### 1. ユーザー登録・認証
- 新規登録（メール・パスワード）
- ログイン／ログアウト
- マイページ編集（名前・プロフィール画像）

### 2. クエスト（家事・育児タスク）の作成
- タイトル
- 詳細
- カテゴリ（家事 / 育児）
- デフォルトポイント（例: 10〜50）
- 作成したクエストの編集・削除が可能

### 3. クエストの実行
- 今日のクエスト一覧表示
- クエスト詳細 → 「完了」ボタンでポイント付与
- 育児カテゴリのクエストは赤ちゃんを選択（複数登録可能）

### 4. 赤ちゃん情報の登録
- 名前
- 生年月日（月齢の自動表示）
- 複数登録可能

### 5. 実行履歴
- 日付ごとのクエスト完了履歴
- 獲得ポイント合計
- フィルタ（家事のみ / 育児のみ）

### 6. お気に入りクエスト
- クエストのお気に入り登録
- お気に入り一覧表示

### 7. ランキング
- 全ユーザーの月間ポイントランキング

### 8. レビュー機能
- 評価（1〜5）
- コメント（任意）
- クエストごとの平均評価表示

## 管理者画面の要件
※ RailsAdmin / ActiveAdmin を想定

### 1. ユーザー管理
- 一覧
- 詳細
- 削除（退会処理）

### 2. クエスト管理
- 全クエスト一覧
- 不適切クエストの削除

### 3. レビュー管理
- 全レビュー一覧
- 不適切レビューの削除

## データ項目（モデル設計）

### User
- email
- encrypted_password
- name
- profile_image
- total_points
- created_at
- updated_at

### Baby
- user_id
- name
- birth_date
- created_at
- updated_at

### Quest
- user_id
- title
- description
- category（家事 / 育児）
- default_points
- created_at
- updated_at

### QuestLog（実行ログ）
- user_id
- quest_id
- baby_id（任意）
- points_awarded
- done_at
- created_at
- updated_at

### Review
- user_id
- quest_id
- rating（1〜5）
- comment
- created_at
- updated_at
