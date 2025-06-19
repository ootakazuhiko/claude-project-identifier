# .claude-prompt.sh 使用手順書

## ✅ 現在の状況確認

`claude-add`実行後、以下のファイルが作成されます：

```bash
ls -la .claude-prompt.sh .claude-project CLAUDE.md
```

## 🎯 Claude Code環境での正しい使用方法

### 1. プロジェクト情報の表示

```bash
# プロジェクト情報を詳細表示
./init-project.sh
```

### 2. 環境変数の設定と確認

```bash
# .claude-prompt.shを実行して環境変数を設定
source .claude-prompt.sh

# 設定された環境変数を確認
echo "プロジェクト名: $CLAUDE_PROJECT_NAME"
echo "プロジェクトタイプ: $CLAUDE_PROJECT_TYPE"
echo "バージョン: $CLAUDE_PROJECT_VERSION"
```

### 3. 作業セッション開始時のルーチン

```bash
# 1. プロジェクト情報を表示
./init-project.sh

# 2. 環境変数を設定
source .claude-prompt.sh

# 3. プロジェクト情報を確認
echo "現在作業中: $CLAUDE_PROJECT_NAME ($CLAUDE_PROJECT_TYPE)"
```

## 🖥️ ローカルターミナルでの使用方法

ローカルのターミナル（Claude Code外）で使用する場合：

### 1. 初回設定

```bash
# プロンプト統合ファイルをホームにコピー
cp .claude-prompt.sh ~/.claude-prompt.sh

# シェル設定に追加
echo 'source ~/.claude-prompt.sh' >> ~/.bashrc  # Bashの場合
# または
echo 'source ~/.claude-prompt.sh' >> ~/.zshrc   # Zshの場合

# シェル再読み込み
source ~/.bashrc  # または source ~/.zshrc
```

### 2. 使用方法

```bash
# Claude対応プロジェクトディレクトリに移動
cd /path/to/your/claude-project

# 自動的にプロンプトが変更される
# [プロジェクト名] ~/path/to/project $ 
```

## 🧪 テスト手順

### ステップ1: ファイル存在確認

```bash
# 必要なファイルが存在することを確認
ls -la .claude-project .claude-prompt.sh CLAUDE.md init-project.sh
```

### ステップ2: プロジェクト情報表示テスト

```bash
# プロジェクト情報が正しく表示されるか確認
./init-project.sh
```

### ステップ3: 環境変数設定テスト

```bash
# 環境変数が正しく設定されるか確認
source .claude-prompt.sh
echo "プロジェクト名: '$CLAUDE_PROJECT_NAME'"
echo "プロジェクトタイプ: '$CLAUDE_PROJECT_TYPE'"
echo "バージョン: '$CLAUDE_PROJECT_VERSION'"
```

### ステップ4: JSON形式確認

```bash
# .claude-projectファイルの内容確認
cat .claude-project | head -10
```

## ❌ よくある問題と解決方法

### 問題1: 環境変数が空

**症状**:
```bash
source .claude-prompt.sh
echo "$CLAUDE_PROJECT_NAME"  # 空の出力
```

**原因**: `.claude-project`ファイルの形式が正しくない

**解決方法**:
```bash
# JSONファイルの内容確認
cat .claude-project

# プロジェクト名の手動抽出テスト
grep -o '"name": "[^"]*"' .claude-project | head -1 | cut -d'"' -f4
```

### 問題2: プロンプトが変更されない

**症状**: Claude Code環境でプロンプトが `[プロジェクト名]` に変わらない

**解決方法**: Claude Code環境では制限があります
```bash
# 代わりに環境変数を活用
source .claude-prompt.sh
echo "[$CLAUDE_PROJECT_NAME] 作業中"
```

### 問題3: ターミナルタイトルが変更されない

**症状**: ブラウザのタイトルが変わらない

**解決方法**: Claude Codeはブラウザ環境のため制限があります
```bash
# 代わりにプロジェクト情報を表示
./init-project.sh
```

## 📋 実用的な使用例

### 例1: 作業開始時のプロジェクト確認

```bash
#!/bin/bash
# プロジェクト開始スクリプト

echo "=== プロジェクト情報 ==="
source .claude-prompt.sh
echo "プロジェクト: $CLAUDE_PROJECT_NAME"
echo "タイプ: $CLAUDE_PROJECT_TYPE"
echo "バージョン: $CLAUDE_PROJECT_VERSION"
echo "作業ディレクトリ: $(pwd)"
echo "========================"
```

### 例2: 環境変数を使った条件分岐

```bash
#!/bin/bash
source .claude-prompt.sh

if [ "$CLAUDE_PROJECT_TYPE" = "React Application" ]; then
    echo "React プロジェクトです。npm start で開発サーバーを起動できます。"
elif [ "$CLAUDE_PROJECT_TYPE" = "Python Project" ]; then
    echo "Python プロジェクトです。requirements.txt を確認してください。"
else
    echo "プロジェクトタイプ: $CLAUDE_PROJECT_TYPE"
fi
```

### 例3: 複数プロジェクト間の移動

```bash
#!/bin/bash
# プロジェクト切り替えスクリプト

switch_project() {
    cd "$1"
    if [ -f ".claude-prompt.sh" ]; then
        source .claude-prompt.sh
        echo "[$CLAUDE_PROJECT_NAME] に切り替えました"
    else
        echo "Claude対応プロジェクトではありません"
    fi
}

# 使用例
# switch_project /path/to/project-a
# switch_project /path/to/project-b
```

## 📊 動作確認チェックリスト

- [ ] `.claude-project` ファイルが存在する
- [ ] `.claude-prompt.sh` ファイルが存在する  
- [ ] `./init-project.sh` でプロジェクト情報が表示される
- [ ] `source .claude-prompt.sh` で環境変数が設定される
- [ ] `echo "$CLAUDE_PROJECT_NAME"` でプロジェクト名が表示される
- [ ] JSON形式が正しい（`cat .claude-project` で確認）

## 🎯 まとめ

**Claude Code環境での推奨使用方法**:
1. `./init-project.sh` - プロジェクト情報表示
2. `source .claude-prompt.sh` - 環境変数設定
3. `echo "$CLAUDE_PROJECT_NAME"` - プロジェクト名確認

**ローカル環境での推奨使用方法**:
1. 初回: `cp .claude-prompt.sh ~/.claude-prompt.sh` + シェル設定
2. 以降: ディレクトリ移動時に自動プロンプト変更

Claude Code環境では完全なターミナル制御はできませんが、環境変数とプロジェクト情報表示により効果的なプロジェクト識別が可能です。