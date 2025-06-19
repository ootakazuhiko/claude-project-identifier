# Claude Project Identifier - プロンプト統合設定ガイド

## 🎯 概要

このガイドでは、`.claude-prompt.sh`を使用してターミナルのタイトルバーとプロンプトにプロジェクト名を表示する方法を説明します。

## ⚠️ 重要な注意事項

Claude Codeは**ブラウザベースの環境**で動作するため、**ターミナルのタイトルバーを直接変更することはできません**。

しかし、以下の方法でプロジェクト識別を向上させることができます：

## 🔧 利用可能な方法

### 1. ローカルターミナルでの使用

Claude Codeの外部で、ローカルのターミナルでプロジェクトを操作する場合：

#### 手順：

1. **プロンプト統合スクリプトをホームディレクトリにコピー**
   ```bash
   cp .claude-prompt.sh ~/.claude-prompt.sh
   ```

2. **シェル設定ファイルに追加**
   
   **Bashの場合：**
   ```bash
   echo 'source ~/.claude-prompt.sh' >> ~/.bashrc
   ```
   
   **Zshの場合：**
   ```bash
   echo 'source ~/.claude-prompt.sh' >> ~/.zshrc
   ```

3. **シェルを再読み込み**
   ```bash
   source ~/.bashrc  # または source ~/.zshrc
   ```

4. **プロジェクトディレクトリに移動**
   ```bash
   cd /path/to/your/claude-project
   ```

#### 結果：
- **ターミナルタイトル**: `Claude Code - プロジェクト名`
- **プロンプト**: `[プロジェクト名] ~/path/to/project $ `

### 2. Claude Code内での代替方法

Claude Code環境内では、以下の方法でプロジェクト識別ができます：

#### A. 手動でプロジェクト情報を表示

```bash
./init-project.sh
```

または

```bash
make info  # Makefileがある場合
```

#### B. 環境変数でプロジェクト情報を設定

```bash
source .claude-prompt.sh  # 環境変数を設定
echo "現在のプロジェクト: $CLAUDE_PROJECT_NAME"
```

#### C. プロンプトの一時的な変更

```bash
# 現在のセッションでプロンプトを変更
source .claude-prompt.sh
# プロンプトが [プロジェクト名] に変更される
```

## 🧪 テスト方法

### 1. ファイルの存在確認

```bash
ls -la .claude-project .claude-prompt.sh CLAUDE.md
```

### 2. プロンプト統合のテスト

```bash
# プロジェクト名の抽出テスト
grep -o '"name": "[^"]*"' .claude-project | head -1 | cut -d'"' -f4
```

### 3. プロンプト統合の実行

```bash
# 直接実行してテスト
source .claude-prompt.sh
echo "プロジェクト名: $CLAUDE_PROJECT_NAME"
```

### 4. ターミナルタイトルの設定テスト

```bash
# ターミナルタイトルの設定（エスケープシーケンスが表示される）
echo -ne "\033]0;Claude Code - テストプロジェクト\007"
```

## 🔍 トラブルシューティング

### 問題1: プロンプトが変更されない

**原因**: `.claude-project`ファイルが存在しない、または形式が正しくない

**解決方法**:
```bash
# ファイルの確認
cat .claude-project
# JSON形式であることを確認
```

### 問題2: ターミナルタイトルが変更されない

**原因**: Claude Code環境ではブラウザのタイトルは変更できない

**解決方法**: 
- ローカルターミナルで使用する
- または `./init-project.sh` でプロジェクト情報を表示する

### 問題3: 環境変数が設定されない

**確認方法**:
```bash
echo $CLAUDE_PROJECT_NAME
echo $CLAUDE_PROJECT_TYPE
```

**解決方法**:
```bash
source .claude-prompt.sh
```

## 📋 実用的な使用例

### 例1: プロジェクト情報の確認

```bash
# プロジェクトディレクトリに移動
cd /path/to/your/project

# Claude設定を読み込み
source .claude-prompt.sh

# プロジェクト情報を表示
echo "プロジェクト: $CLAUDE_PROJECT_NAME"
echo "タイプ: $CLAUDE_PROJECT_TYPE"
```

### 例2: 作業開始時のルーチン

```bash
# 1. プロジェクト情報を表示
./init-project.sh

# 2. プロンプトを設定
source .claude-prompt.sh

# 3. 作業開始
echo "[$CLAUDE_PROJECT_NAME] での作業を開始します"
```

### 例3: 複数プロジェクト間の移動

```bash
# プロジェクトAに移動
cd /path/to/project-a
source .claude-prompt.sh
echo "現在: $CLAUDE_PROJECT_NAME"

# プロジェクトBに移動
cd /path/to/project-b
source .claude-prompt.sh
echo "現在: $CLAUDE_PROJECT_NAME"
```

## 💡 推奨される使用方法

### Claude Code環境での推奨方法

1. **プロジェクト開始時**:
   ```bash
   ./init-project.sh  # プロジェクト情報を確認
   ```

2. **作業中**:
   ```bash
   source .claude-prompt.sh  # 環境変数を設定
   ```

3. **プロジェクト識別が必要な時**:
   ```bash
   echo "現在のプロジェクト: $CLAUDE_PROJECT_NAME"
   ```

### ローカル開発環境での推奨方法

1. **初回設定**:
   ```bash
   cp .claude-prompt.sh ~/.claude-prompt.sh
   echo 'source ~/.claude-prompt.sh' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **以降の使用**:
   - プロジェクトディレクトリに移動するだけで自動的にプロンプトが変更される

## 🎯 まとめ

- **Claude Code内**: `./init-project.sh`でプロジェクト情報を表示
- **ローカルターミナル**: `.claude-prompt.sh`でプロンプトとタイトルを自動変更
- **環境変数**: `source .claude-prompt.sh`でプロジェクト情報を環境変数に設定

Claude Code環境の制約により、ブラウザのタイトルバーは変更できませんが、これらの方法でプロジェクト識別を効果的に行うことができます。