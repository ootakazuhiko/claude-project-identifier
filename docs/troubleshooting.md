# トラブルシューティングガイド

このガイドでは、Claude Project Identifier の使用中に発生する可能性のある問題と、その解決方法について説明します。

## 目次
1. [インストールの問題](#インストールの問題)
2. [表示の問題](#表示の問題)
3. [設定の問題](#設定の問題)
4. [パフォーマンスの問題](#パフォーマンスの問題)
5. [互換性の問題](#互換性の問題)
6. [デバッグ方法](#デバッグ方法)

## インストールの問題

### ワンライナーインストールが失敗する

**症状**:
```bash
curl: (7) Failed to connect to raw.githubusercontent.com
```

**原因**: ネットワーク接続の問題、またはファイアウォール設定

**解決方法**:
1. プロキシ経由でインストール：
```bash
export https_proxy=http://your-proxy:port
curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
```

2. 手動でダウンロード：
```bash
# ブラウザでダウンロードしてから
bash ~/Downloads/install.sh
```

### Permission denied エラー

**症状**:
```bash
bash: ./scripts/setup.sh: Permission denied
```

**解決方法**:
```bash
chmod +x scripts/*.sh
chmod +x init-project.sh
```

### git clone が失敗する

**症状**:
```bash
fatal: unable to access 'https://github.com/...': SSL certificate problem
```

**解決方法**:
```bash
# 一時的な回避策（セキュリティに注意）
git config --global http.sslVerify false
git clone https://github.com/ootakazuhiko/claude-project-identifier.git
git config --global http.sslVerify true
```

## 表示の問題

### 文字化けが発生する

**症状**: バナーや絵文字が正しく表示されない

**原因**: ターミナルがUTF-8をサポートしていない

**解決方法**:

1. ターミナルの文字エンコーディングを確認：
```bash
echo $LANG
# UTF-8が含まれていることを確認
```

2. ASCIIモードに切り替え：
```json
{
  "display": {
    "use_ascii": true,
    "use_emoji": false
  }
}
```

3. 代替バナーを使用：
```json
{
  "display": {
    "banner": "banner_ascii"
  }
}
```

### 色が表示されない

**症状**: すべてのテキストが同じ色で表示される

**原因**: ターミナルが色をサポートしていない、または無効化されている

**解決方法**:

1. ターミナルの色サポートを確認：
```bash
echo $TERM
# xterm-256color などが表示されることを確認
```

2. 色を強制的に有効化：
```bash
export TERM=xterm-256color
```

3. 色を無効化：
```json
{
  "display": {
    "colors": {
      "enabled": false
    }
  }
}
```

### プロジェクト情報が表示されない

**症状**: `make info` を実行しても何も表示されない

**確認事項**:

1. 必要なファイルの存在確認：
```bash
ls -la CLAUDE.md .claude-project init-project.sh
```

2. スクリプトの実行権限：
```bash
chmod +x init-project.sh
```

3. シェルの確認：
```bash
echo $SHELL
# /bin/bash または /bin/zsh であることを確認
```

## 設定の問題

### JSONパースエラー

**症状**:
```
parse error: Invalid numeric literal at line X, column Y
```

**原因**: `.claude-project` のJSON構文エラー

**解決方法**:

1. JSON検証ツールを使用：
```bash
# jqを使用
jq . .claude-project

# Pythonを使用
python -m json.tool .claude-project
```

2. よくある構文エラー：
- 最後のカンマ
- 引用符の不一致
- エスケープされていない特殊文字

### 設定が反映されない

**症状**: `.claude-project` を編集しても変更が表示されない

**確認事項**:

1. ファイルが保存されているか
2. 正しいディレクトリで実行しているか
3. キャッシュのクリア：
```bash
# 環境変数をクリア
unset CLAUDE_PROJECT_CACHE
```

### カスタムフィールドが表示されない

**原因**: テンプレートがカスタムフィールドに対応していない

**解決方法**: `init-project.sh` を編集してカスタムフィールドを追加：

```bash
# カスタムフィールドの表示を追加
if [ -n "$CUSTOM_FIELD" ]; then
    echo "  ├─ Custom: $CUSTOM_FIELD"
fi
```

## パフォーマンスの問題

### 起動が遅い

**原因**: 外部コマンドの実行や大きなファイルの読み込み

**解決方法**:

1. 不要な情報の無効化：
```json
{
  "display": {
    "info": {
      "show_todo_count": false,
      "show_last_commit": false
    }
  }
}
```

2. キャッシュの有効化：
```bash
export CLAUDE_PROJECT_CACHE=1
```

### メモリ使用量が多い

**原因**: 大きなプロジェクトでの再帰的な検索

**解決方法**: 検索範囲を制限：
```bash
# .claude-project-ignore ファイルを作成
echo "node_modules/" > .claude-project-ignore
echo "dist/" >> .claude-project-ignore
```

## 互換性の問題

### macOS での問題

**症状**: `readlink: illegal option -- f`

**解決方法**: GNU coreutilsをインストール：
```bash
brew install coreutils
# または
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
```

### Windows (WSL) での問題

**症状**: パスの問題やスクリプトエラー

**解決方法**:
1. 改行コードを確認：
```bash
dos2unix init-project.sh
```

2. シェバンを確認：
```bash
#!/usr/bin/env bash
# または
#!/bin/bash
```

### 古いBashバージョン

**症状**: `syntax error near unexpected token`

**確認**:
```bash
bash --version
# 4.0以上が必要
```

**解決方法**: Bashをアップグレード、または互換モードを使用：
```bash
#!/bin/bash
# Bash 3互換モード
set +o posix
```

## デバッグ方法

### デバッグモードの有効化

```bash
# デバッグ出力を有効化
export CLAUDE_PROJECT_DEBUG=1
bash init-project.sh
```

### ステップ実行

```bash
# bashのデバッグモード
bash -x init-project.sh
```

### ログファイルの確認

```bash
# ログを有効化
export CLAUDE_PROJECT_LOG=/tmp/claude-project.log
bash init-project.sh 2>&1 | tee $CLAUDE_PROJECT_LOG
```

### 最小構成でのテスト

最小限の設定でテスト：
```json
{
  "project": {
    "name": "Test"
  }
}
```

## よくある質問

### Q: 複数のプロジェクトで異なる設定を使いたい

A: 各プロジェクトに個別の `.claude-project` ファイルを配置してください。

### Q: チーム全体で設定を共有したい

A: `.claude-project` をGitリポジトリに含めて、チームメンバーと共有してください。

### Q: CI/CDパイプラインで使用できますか？

A: はい、以下のように使用できます：
```yaml
- name: Show project info
  run: bash init-project.sh
```

### Q: エラーレポートはどこに送ればよいですか？

A: [GitHub Issues](https://github.com/ootakazuhiko/claude-project-identifier/issues) で報告してください。

## 緊急時の対処法

すべてが失敗する場合の最小限の回避策：

```bash
# 手動で最小限の情報を表示
cat << EOF
================================================
 Project: $(basename $(pwd))
 Directory: $(pwd)
 Time: $(date)
================================================
EOF
```

## サポートを受ける

1. [ドキュメント](../README.md)を確認
2. [既存のIssue](https://github.com/ootakazuhiko/claude-project-identifier/issues)を検索
3. 新しいIssueを作成（以下の情報を含める）：
   - OS とバージョン
   - シェルとバージョン
   - エラーメッセージ
   - 再現手順
   - `.claude-project` の内容（機密情報を除く）