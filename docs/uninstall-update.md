# アンインストール・アップデート手順

## 目次
1. [プロジェクトからの削除](#プロジェクトからの削除)
2. [システムからの完全アンインストール](#システムからの完全アンインストール)
3. [アップデート方法](#アップデート方法)
4. [バージョン管理](#バージョン管理)

## プロジェクトからの削除

### 個別プロジェクトから Claude Project Identifier を削除

プロジェクトディレクトリで以下のファイルを削除します：

```bash
# プロジェクトディレクトリに移動
cd /path/to/your/project

# Claude Project Identifier のファイルを削除
rm -f CLAUDE.md
rm -f .claude-project
rm -f init-project.sh

# Makefile から関連する設定を削除（手動で編集）
# info: ターゲットなどを削除
```

### Makefile の編集

Makefile に追加した設定がある場合は、以下の部分を削除：

```makefile
# 以下のような行を削除
.PHONY: info project-info

info: project-info

project-info:
	@bash init-project.sh
```

## システムからの完全アンインストール

### 1. インストールディレクトリの削除

```bash
# デフォルトのインストールディレクトリを削除
rm -rf ~/.claude-project-identifier

# カスタムディレクトリにインストールした場合
rm -rf $CLAUDE_PROJECT_DIR
```

### 2. シェル設定のクリーンアップ

#### Bash の場合（~/.bashrc）

```bash
# ~/.bashrc を編集
nano ~/.bashrc

# 以下の行を削除：
# Claude Project Identifier
export PATH="$PATH:$HOME/.claude-project-identifier/scripts"
alias claude-project-setup='$HOME/.claude-project-identifier/scripts/setup.sh'
```

#### Zsh の場合（~/.zshrc）

```bash
# ~/.zshrc を編集
nano ~/.zshrc

# 同様に Claude Project Identifier 関連の行を削除
```

### 3. 設定の反映

```bash
# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc
```

### 4. 確認

```bash
# コマンドが削除されたことを確認
which claude-project-setup
# "claude-project-setup not found" と表示されればOK
```

## アップデート方法

### 方法1: 自動アップデート（推奨）

```bash
# インストールディレクトリに移動
cd ~/.claude-project-identifier

# 最新版を取得
git pull origin main

# スクリプトの実行権限を再設定
chmod +x scripts/*.sh

# バージョン確認
cat CHANGELOG.md | head -20
```

### 方法2: 再インストール

```bash
# 1. 現在のバージョンをバックアップ（オプション）
cp -r ~/.claude-project-identifier ~/.claude-project-identifier.backup

# 2. 再度インストールスクリプトを実行
curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash

# インストーラーが既存のインストールを検出し、更新するか確認します
```

### 方法3: 手動アップデート

```bash
# 1. 最新版をダウンロード
cd /tmp
git clone https://github.com/ootakazuhiko/claude-project-identifier.git claude-project-identifier-new

# 2. 既存のインストールを更新
cp -r claude-project-identifier-new/* ~/.claude-project-identifier/

# 3. 実行権限を設定
chmod +x ~/.claude-project-identifier/scripts/*.sh

# 4. 一時ファイルを削除
rm -rf /tmp/claude-project-identifier-new
```

## バージョン管理

### 現在のバージョンを確認

```bash
# CHANGELOG.md の最新エントリを確認
head -10 ~/.claude-project-identifier/CHANGELOG.md

# または、.claude-project のバージョンを確認（プロジェクトごと）
cat .claude-project | grep version
```

### 特定バージョンのインストール

```bash
# 特定のバージョンをチェックアウト
cd ~/.claude-project-identifier
git fetch --tags
git checkout v1.0.0  # 例：v1.0.0 をインストール
```

### プロジェクトファイルの更新

新しいバージョンで新機能が追加された場合、プロジェクトの設定ファイルも更新が必要な場合があります：

```bash
# プロジェクトディレクトリで
cd /path/to/your/project

# 既存の設定をバックアップ
cp .claude-project .claude-project.backup

# 新しいテンプレートと比較
diff .claude-project ~/.claude-project-identifier/templates/.claude-project.template

# 必要に応じて新機能を追加
# 例：新しい待機インジケーターや表示オプション
```

## トラブルシューティング

### アップデート後に動作しない場合

1. **権限の確認**
   ```bash
   chmod +x ~/.claude-project-identifier/scripts/*.sh
   chmod +x init-project.sh
   ```

2. **PATH の再設定**
   ```bash
   source ~/.bashrc  # または ~/.zshrc
   ```

3. **キャッシュのクリア**
   ```bash
   hash -r  # コマンドのキャッシュをクリア
   ```

### バージョンの不整合

プロジェクトの設定ファイルが古いバージョンの形式の場合：

```bash
# 設定ファイルの移行ツール（将来実装予定）
~/.claude-project-identifier/scripts/migrate-config.sh

# または手動で新しい形式に更新
cp .claude-project .claude-project.old
cp ~/.claude-project-identifier/templates/.claude-project.template .claude-project
# 古い設定を新しいファイルにマージ
```

## ベストプラクティス

1. **アップデート前のバックアップ**
   ```bash
   cp -r ~/.claude-project-identifier ~/.claude-project-identifier.$(date +%Y%m%d)
   ```

2. **段階的なアップデート**
   - まず1つのプロジェクトでテスト
   - 問題がなければ他のプロジェクトも更新

3. **変更履歴の確認**
   ```bash
   # アップデート前に変更内容を確認
   curl -s https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/CHANGELOG.md | head -50
   ```

## 完全なクリーンインストール

すべてを削除して最初からやり直す場合：

```bash
# 1. 完全アンインストール
rm -rf ~/.claude-project-identifier
sed -i '/claude-project-identifier/d' ~/.bashrc  # または ~/.zshrc

# 2. シェルをリロード
source ~/.bashrc

# 3. 新規インストール
curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
```