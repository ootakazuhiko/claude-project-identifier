# カスタマイズガイド

Claude Project Identifier は高度にカスタマイズ可能です。このガイドでは、様々なカスタマイズオプションについて説明します。

## 目次
1. [表示内容のカスタマイズ](#表示内容のカスタマイズ)
2. [バナーデザイン](#バナーデザイン)
3. [待機インジケーター](#待機インジケーター)
4. [色とスタイル](#色とスタイル)
5. [技術スタック表示](#技術スタック表示)
6. [環境別設定](#環境別設定)
7. [高度なカスタマイズ](#高度なカスタマイズ)

## 表示内容のカスタマイズ

### 基本的な表示項目の制御

`.claude-project` ファイルの `display.info` セクションで、表示する情報を制御できます：

```json
{
  "display": {
    "info": {
      "show_git_branch": true,      // Gitブランチを表示
      "show_environment": true,      // 環境情報を表示
      "show_timestamp": true,        // タイムスタンプを表示
      "show_tech_stack": true,       // 技術スタックを表示
      "show_last_commit": true,      // 最新コミットを表示
      "show_todo_count": true,       // TODOカウントを表示
      "show_version": true,          // バージョンを表示
      "show_author": false,          // 作者情報を表示
      "show_license": false          // ライセンスを表示
    }
  }
}
```

### カスタム情報の追加

プロジェクト固有の情報を追加できます：

```json
{
  "project": {
    "custom_fields": {
      "api_endpoint": "https://api.example.com",
      "database": "PostgreSQL 14",
      "deployment": "AWS ECS",
      "ci_cd": "GitHub Actions"
    }
  }
}
```

## バナーデザイン

### Unicode バナー（デフォルト）

```json
{
  "display": {
    "banner": [
      "╔══════════════════════════════════════════════╗",
      "║           🚀 My Awesome Project 🚀           ║",
      "║         Modern Web Application v2.0          ║",
      "╚══════════════════════════════════════════════╝"
    ]
  }
}
```

### ASCII バナー（互換性重視）

```json
{
  "display": {
    "banner_ascii": [
      "==================================================",
      "           * My Awesome Project *                 ",
      "         Modern Web Application v2.0              ",
      "=================================================="
    ],
    "use_ascii": true
  }
}
```

### カスタムアートバナー

```json
{
  "display": {
    "banner": [
      "     _____  _                   _      ",
      "    / ____|| |                 | |     ",
      "   | |     | | __ _ _   _  __| | ___  ",
      "   | |     | |/ _` | | | |/ _` |/ _ \\ ",
      "   | |____ | | (_| | |_| | (_| |  __/ ",
      "    \\_____||_|\\__,_|\\__,_|\\__,_|\\___| ",
      "                                       ",
      "         Project Identifier v1.0       "
    ]
  }
}
```

## 待機インジケーター

### 基本的な待機メッセージ

```json
{
  "display": {
    "waiting_indicators": [
      "[WAITING] 🎯 コマンドをお待ちしています...",
      "[WAITING] 💭 何をお手伝いしましょうか？",
      "[WAITING] ⚡ 準備完了です！",
      "[WAITING] 🔧 次の作業を指示してください",
      "[WAITING] 📝 入力をお待ちしています..."
    ]
  }
}
```

### コンテキスト別メッセージ

```json
{
  "display": {
    "waiting_indicators_by_context": {
      "morning": [
        "[WAITING] ☀️ おはようございます！今日は何から始めますか？",
        "[WAITING] 🌅 新しい一日の始まりです。準備はいいですか？"
      ],
      "evening": [
        "[WAITING] 🌙 お疲れ様です。まだ作業を続けますか？",
        "[WAITING] 🌃 夜の開発タイムですね！"
      ],
      "weekend": [
        "[WAITING] 🎉 週末開発お疲れ様です！",
        "[WAITING] 🏖️ 休日も頑張っていますね！"
      ]
    }
  }
}
```

## 色とスタイル

### カラーテーマ設定

```json
{
  "display": {
    "colors": {
      "banner": "cyan",          // バナーの色
      "project_name": "purple",  // プロジェクト名の色
      "section_header": "green", // セクションヘッダーの色
      "waiting": "yellow",       // 待機インジケーターの色
      "info": "blue",           // 情報テキストの色
      "success": "green",       // 成功メッセージの色
      "error": "red",          // エラーメッセージの色
      "warning": "yellow"      // 警告メッセージの色
    }
  }
}
```

### スタイル設定

```json
{
  "display": {
    "styles": {
      "use_bold": true,        // 太字を使用
      "use_underline": false,  // 下線を使用
      "use_emoji": true,       // 絵文字を使用
      "indent_size": 2,        // インデントサイズ
      "separator": "─"         // セパレーター文字
    }
  }
}
```

## 技術スタック表示

### 詳細な技術スタック

```json
{
  "tech_stack": {
    "frontend": {
      "framework": "Next.js 14",
      "ui_library": "React 18",
      "styling": "Tailwind CSS",
      "state_management": "Zustand",
      "testing": "Jest + React Testing Library"
    },
    "backend": {
      "framework": "Express.js",
      "language": "TypeScript",
      "database": "PostgreSQL",
      "orm": "Prisma",
      "cache": "Redis"
    },
    "devops": {
      "container": "Docker",
      "ci_cd": "GitHub Actions",
      "hosting": "AWS ECS",
      "monitoring": "Datadog"
    }
  }
}
```

### シンプルな技術スタック

```json
{
  "tech_stack": {
    "main": ["React", "Node.js", "PostgreSQL"],
    "tools": ["Docker", "Jest", "ESLint"]
  }
}
```

## 環境別設定

### 開発環境の識別

```json
{
  "environments": {
    "development": {
      "color": "green",
      "emoji": "🚀",
      "label": "DEV",
      "banner_suffix": "[開発環境]"
    },
    "staging": {
      "color": "yellow",
      "emoji": "🔧",
      "label": "STAGE",
      "banner_suffix": "[ステージング]"
    },
    "production": {
      "color": "red",
      "emoji": "🏭",
      "label": "PROD",
      "banner_suffix": "[本番環境]",
      "show_warning": true,
      "warning_message": "⚠️  本番環境です。操作にご注意ください！"
    }
  }
}
```

### 環境変数による切り替え

```bash
# 環境変数で環境を指定
export CLAUDE_PROJECT_ENV=production
```

## 高度なカスタマイズ

### 条件付き表示

```json
{
  "display": {
    "conditional": {
      "show_if_git_dirty": {
        "message": "⚠️  未コミットの変更があります",
        "color": "yellow"
      },
      "show_if_tests_failing": {
        "message": "❌ テストが失敗しています",
        "color": "red"
      }
    }
  }
}
```

### カスタムスクリプト統合

```json
{
  "hooks": {
    "before_display": "./scripts/check-status.sh",
    "after_display": "./scripts/notify.sh",
    "custom_info": {
      "build_status": "npm run build:status",
      "test_coverage": "npm run coverage:summary"
    }
  }
}
```

### 動的コンテンツ

```json
{
  "display": {
    "dynamic": {
      "show_weather": true,
      "show_quote": true,
      "show_build_status": true,
      "api_endpoints": {
        "weather": "https://api.weather.com/...",
        "quote": "https://api.quotable.io/random"
      }
    }
  }
}
```

### プラグインシステム

```json
{
  "plugins": [
    {
      "name": "git-stats",
      "enabled": true,
      "config": {
        "show_branch_ahead_behind": true,
        "show_stash_count": true
      }
    },
    {
      "name": "docker-status",
      "enabled": true,
      "config": {
        "show_running_containers": true
      }
    }
  ]
}
```

## ベストプラクティス

### 1. シンプルさを保つ
過度なカスタマイズは情報過多になる可能性があります。必要な情報のみを表示しましょう。

### 2. チーム間で統一
チームで使用する場合は、設定を統一して共有しましょう。

### 3. パフォーマンスを考慮
動的コンテンツや外部APIの使用は、表示速度に影響する可能性があります。

### 4. アクセシビリティ
色だけでなく、記号や文字でも情報を伝えるようにしましょう。

## サンプル設定

### ミニマリスト設定

```json
{
  "project": {
    "name": "Simple App",
    "version": "1.0.0"
  },
  "display": {
    "minimal": true,
    "info": {
      "show_git_branch": true,
      "show_timestamp": false,
      "show_tech_stack": false
    }
  }
}
```

### フル機能設定

完全な設定例は [examples/full-featured/](../examples/full-featured/) を参照してください。

## 設定の検証

設定が正しいか確認するには：

```bash
# JSON構文チェック
jq . .claude-project

# 設定の検証
./scripts/validate-config.sh
```

## トラブルシューティング

設定が反映されない場合は、[トラブルシューティングガイド](troubleshooting.md)を参照してください。