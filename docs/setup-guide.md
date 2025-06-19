# Claude Project Identifier - セットアップガイド

## 目次
1. [はじめに](#はじめに)
2. [インストール方法](#インストール方法)
3. [初期設定](#初期設定)
4. [プロジェクトへの適用](#プロジェクトへの適用)
5. [動作確認](#動作確認)
6. [トラブルシューティング](#トラブルシューティング)

## はじめに

Claude Project Identifier は、Claude Code (claude.ai/code) でプロジェクトを開いた際に、プロジェクト情報を自動的に表示し、待機状態を視覚的に示すシステムです。

### 必要な環境
- Bash 4.0 以上
- Git
- テキストエディタ

## インストール方法

### 方法1: ワンライナーインストール（推奨）

```bash
curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
```

または wget を使用：

```bash
wget -qO- https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
```

### 方法2: 手動インストール

```bash
# 1. リポジトリをクローン
git clone https://github.com/ootakazuhiko/claude-project-identifier.git

# 2. インストールディレクトリに移動
cd claude-project-identifier

# 3. セットアップスクリプトを実行
./scripts/setup.sh
```

### 方法3: プロジェクトに直接コピー

テンプレートファイルを直接プロジェクトにコピーすることもできます：

```bash
# テンプレートディレクトリから必要なファイルをコピー
cp templates/CLAUDE.md.template /path/to/your/project/CLAUDE.md
cp templates/.claude-project.template /path/to/your/project/.claude-project
cp templates/init-project.sh.template /path/to/your/project/init-project.sh
chmod +x /path/to/your/project/init-project.sh
```

## 初期設定

### 1. CLAUDE.md の編集

`CLAUDE.md` ファイルを開き、プロジェクト固有の情報に置き換えます：

```markdown
## Project Identification

When working with this project, Claude Code should always display the following information at startup and when waiting for user input:

```
[WAITING] ユーザー入力待機中... / Waiting for user input...
================================================
 Project: あなたのプロジェクト名
 Type: プロジェクトタイプ
 Environment: Development
 Current Directory: [current path]
 Time: [current time]
================================================
```
```

主な編集箇所：
- `[PROJECT_NAME]` → 実際のプロジェクト名
- `[PROJECT_TYPE]` → プロジェクトの種類（Web App、CLI Tool など）
- `[PROJECT_DESCRIPTION]` → プロジェクトの説明

### 2. .claude-project の設定

`.claude-project` ファイルを編集して、プロジェクトの詳細情報を設定します：

```json
{
  "project": {
    "name": "My Awesome Project",
    "description": "革新的なWebアプリケーション",
    "version": "1.0.0",
    "type": "Web Application",
    "status": "Active Development"
  }
}
```

### 3. 待機インジケーターのカスタマイズ

`.claude-project` で待機時のメッセージをカスタマイズできます：

```json
{
  "display": {
    "waiting_indicators": [
      "[WAITING] 🚀 あなたのコマンドを待っています...",
      "[WAITING] 💡 今日は何を作りましょうか？",
      "[WAITING] ⚡ 準備完了です！"
    ]
  }
}
```

## プロジェクトへの適用

### 自動セットアップスクリプトの使用

```bash
# プロジェクトディレクトリに移動
cd /path/to/your/project

# セットアップスクリプトを実行
claude-project-setup
```

スクリプトが対話的に以下を確認します：
- プロジェクト名
- プロジェクトタイプ
- 説明
- バージョン
- 使用技術

### Makefile への統合

既存の Makefile がある場合、以下を追加できます：

```makefile
# Claude Project Information
.PHONY: info

info:
	@bash init-project.sh
```

## 動作確認

### 1. コマンドラインから実行

```bash
# プロジェクトディレクトリで
make info

# または直接実行
bash init-project.sh
```

### 2. 期待される出力

```
[WAITING] 👁️ Ready for your command...
================================================
 Project: My Awesome Project
 Type: Web Application
 Environment: Development
 Current Directory: /home/user/projects/awesome
 Time: 2024-06-19 10:30:45
================================================

▶ Project Information
  ├─ Name: My Awesome Project
  ├─ Version: 1.0.0
  ├─ Status: Active Development
  └─ Tech Stack: Node.js, React, PostgreSQL

Ready to start working on My Awesome Project!
```

## トラブルシューティング

### 文字化けが発生する

**原因**: ターミナルが Unicode 文字をサポートしていない

**解決方法**: `.claude-project` で ASCII バナーを使用：

```json
{
  "display": {
    "use_ascii": true
  }
}
```

### プロジェクト情報が表示されない

**確認事項**:
1. `CLAUDE.md` と `.claude-project` が存在するか
2. `init-project.sh` に実行権限があるか
3. プロジェクトルートディレクトリで実行しているか

```bash
# 実行権限の確認と付与
ls -la init-project.sh
chmod +x init-project.sh
```

### 環境情報が正しく表示されない

**原因**: コマンドが PATH に存在しない

**解決方法**: `.claude-project` で表示項目を調整：

```json
{
  "display": {
    "info": {
      "show_git_branch": false,
      "show_node_version": false
    }
  }
}
```

### カスタマイズが反映されない

**確認事項**:
1. JSON の構文エラーがないか確認
2. ファイルが正しく保存されているか確認

```bash
# JSON 構文チェック（jq がインストールされている場合）
jq . .claude-project
```

## 高度な設定

### 環境別の設定

```json
{
  "environments": {
    "development": {
      "color": "green",
      "emoji": "🚀"
    },
    "production": {
      "color": "red",
      "emoji": "🏭"
    }
  }
}
```

### カスタムコマンドの追加

```json
{
  "quick_commands": [
    {
      "name": "start",
      "command": "npm run dev",
      "description": "開発サーバーを起動"
    },
    {
      "name": "test",
      "command": "npm test",
      "description": "テストを実行"
    }
  ]
}
```

## 次のステップ

- [カスタマイズガイド](customization.md) - 表示内容の詳細なカスタマイズ方法
- [サンプル集](../examples/) - 各種プロジェクトタイプの設定例
- [トラブルシューティング](troubleshooting.md) - より詳細な問題解決方法

## サポート

問題が解決しない場合は、[GitHub Issues](https://github.com/ootakazuhiko/claude-project-identifier/issues) で報告してください。