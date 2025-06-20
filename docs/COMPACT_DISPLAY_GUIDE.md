# コンパクト表示ガイド

## 概要

Claude Project Identifierの新しいコンパクト表示機能により、タスクバーやターミナルタイトルでプロジェクトを素早く識別できます。

## 🎯 主な機能

### 1. ティッカー（短縮識別子）
- **4文字以内**の短い識別子でプロジェクトを表現
- 例: `ITDO`, `TEST`, `CPI`, `AWSM`
- 自動生成または手動設定可能

### 2. 状態アイコン
| アイコン | 状態 | 説明 |
|---------|------|------|
| ⏳ | WAITING | 入力待機中 |
| 🔄 | RUNNING | コマンド実行中 |
| ✅ | SUCCESS | 正常終了 |
| ❌ | ERROR | エラー発生 |
| 🤔 | THINKING | 処理/思考中 |

### 3. コンパクト表示形式

#### タスクバー/ターミナルタイトル
```
⏳ ITDO/main | dev | 14:23
```
- 状態アイコン + ティッカー + Gitブランチ + 環境 + 時刻

#### コマンドプロンプト
```
[⏳ ITDO] $ 
```
- 状態アイコン + ティッカー

## 📦 表示モード

### 1. ワンライン表示 (`--oneline`)
```bash
./init-project-compact.sh --oneline
```
出力例:
```
⏳[TEST] Test Project v1.0.0 15:34 >
```

### 2. コンパクト情報 (`--compact`)
```bash
./init-project-compact.sh --compact
```
出力例:
```
⏳ [TEST] Test Project v1.0.0 (main) [dev] 15:34
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. 標準コンパクト表示（デフォルト）
```bash
./init-project-compact.sh
```
出力例:
```
⏳ [TEST] Test Project v1.0.0
────────────────────────────────────────
Type: Demo Application  Git: main (142 commits)  Env: dev
Cmds: npm {start|test|build}  make {info|help}
────────────────────────────────────────
Ready >
```

## 🔧 設定方法

### 1. ティッカーの設定

#### 自動生成ルール
1. プロジェクト名が4文字以下 → そのまま大文字化
2. 大文字の頭文字が2-4文字 → 頭文字を使用
3. それ以外 → 最初の4文字を大文字化

#### 手動設定
`.claude-project`ファイルに`ticker`を追加:
```json
{
  "project": {
    "name": "My Awesome Project",
    "ticker": "AWSM",
    ...
  }
}
```

### 2. 環境変数
```bash
export CLAUDE_PROJECT_ENV="production"  # 環境を変更
```

## 🚀 使用例

### 基本的な使用
```bash
# ティッカーのみ取得
TICKER=$(./init-project-compact.sh --ticker)
echo "Project ticker: $TICKER"

# ターミナルタイトルを更新
./init-project-compact.sh --update-title
```

### タスクバー統合
```bash
# .claude-taskbar.shを読み込み
source .claude-taskbar.sh

# 状態を変更
claude_set_state running   # 実行中
claude_set_state success   # 成功
claude_set_state error     # エラー
claude_set_state thinking  # 思考中
claude_set_state waiting   # 待機中（デフォルト）
```

### シェルプロンプト統合
```bash
# .bashrcまたは.zshrcに追加
source ~/.claude-taskbar.sh

# プロジェクトディレクトリに移動すると自動的に更新
cd /path/to/project
# プロンプト: [⏳ PROJ] $ 
```

## 📊 ティッカー生成例

| プロジェクト名 | ティッカー | 理由 |
|---------------|-----------|------|
| vue | VUE | 4文字以下 |
| React Native App | RNA | 大文字頭文字 |
| my-awesome-app | MY-A | 最初の4文字 |
| FastAPI Backend | FAPI | カスタム設定 |
| django-rest-framework | DRF | 一般的な略称 |

## 🎨 カスタマイズ

### カラーテーマ
現在の実装では固定色を使用していますが、将来的には`.claude-project`でカスタマイズ可能になる予定です。

### 表示項目
コンパクト表示では最小限の情報のみ表示:
- プロジェクト名とバージョン
- 現在の環境
- Gitブランチ（オプション）
- 主要コマンド

## 🔍 トラブルシューティング

### ティッカーが表示されない
```bash
# .claude-projectファイルを確認
cat .claude-project | grep ticker

# ティッカーを手動で設定
jq '.project.ticker = "MYPR"' .claude-project > tmp && mv tmp .claude-project
```

### ターミナルタイトルが更新されない
- Claude Code環境では制限があります
- ローカルターミナルでのみ完全に機能します

### プロンプトが変わらない
```bash
# taskbar統合を再読み込み
source .claude-taskbar.sh

# 手動で状態を設定
claude_set_state waiting
```

## 💡 ベストプラクティス

1. **ティッカーは短く分かりやすく**
   - 4文字以内
   - プロジェクトを識別しやすい
   - チーム内で統一

2. **状態管理を活用**
   - CI/CDスクリプトで`claude_set_state`を使用
   - エラー時は`error`状態に設定

3. **環境ごとに色分け**
   - 本番環境では注意を促す表示
   - 開発環境はリラックスした表示

これにより、複数のプロジェクトを同時に作業する際も、一目でどのプロジェクトにいるか識別できます。