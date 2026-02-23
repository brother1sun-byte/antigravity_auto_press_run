# Antigravity Auto Press Run

**Antigravity Auto Press Run** は、AI コーディングアシスタント「Antigravity（VSCode 拡張機能）」が表示する許可確認ボタン（`Allow Once`・`Allow This Conversation`・`Run` など）を自動でクリックするための、軽量なバックグラウンドスクリプトです。

## 概要

Antigravity は、ファイルアクセスやコマンド実行の許可を求める確認ダイアログを頻繁に表示します。このスクリプトは、Chrome DevTools Protocol（CDP）経由で Antigravity の UI を監視し、対象ボタンを検知次第、自動でクリックします。

> [!WARNING]
> このスクリプトは許可確認を**無条件に自動承認**します。悪意のあるコマンドや破壊的な操作も自動で許可してしまう可能性があります。
> 信頼できる作業環境・用途に限定してご使用ください。

## 機能

- Antigravity の許可確認ダイアログを 5 秒間隔で自動検知・クリック
- クリック前に「何を許可したか」のコンテキストをログ出力
- 接続が切れた場合は自動で再接続
- 誤爆防止：`Always run` 等の意図しないボタンは除外

## 動作条件

- **OS**: Windows
- **Node.js**: v18 以降
- **Antigravity**: CDP デバッグポート（デフォルト: `9222`）が有効であること

## インストール

```bash
git clone https://github.com/<あなたのGitHubユーザー名>/antigravity_auto_press_run.git
cd antigravity_auto_press_run
npm install
```

## 使い方

### 方法 1：コマンドラインから起動（推奨）

```bash
npm start
```

### 方法 2：バッチファイルから起動（Windows）

`start_bot.bat` をダブルクリック、またはデスクトップのショートカットから起動します。

### ログの見方

```
[10:30:01] Starting Antigravity Auto Press Run background process...
[10:30:01] Found primary target on port 9222: helloworld - Antigravity
[10:30:01] Connected to Antigravity UI!
[10:30:06] [Action] Auto-clicking: "Allow Once" | [Context] Allow file access to C:\Users\...\discord_interaction.l... Allow Once Allow This Conversation
```

## 自動クリック対象ボタン（優先順位順）

| 優先度 | ボタン名 |
|--------|----------|
| 1 | Allow Once |
| 2 | Allow This Conversation |
| 3 | Run |
| 4 | Allow |
| 5 | Approve / Yes / 実行 / 許可 / 承認 / はい |

`Always run` のような、他コンテキストのボタンは除外されます。

## 設定

`antigravity_auto_press_run.js` の冒頭で以下の値を変更できます。

```js
const CDP_PORTS = [9222, 9000, 9001, 9002, 9003]; // 監視するCDPポート
const POLLING_INTERVAL = 5000;                     // チェック間隔（ミリ秒）
```

## ファイル構成

```
antigravity_auto_press_run/
├── antigravity_auto_press_run.js  # メインスクリプト
├── start_bot.bat                  # Windows用起動バッチファイル
├── package.json
└── README.md
```

## ライセンス

MIT License © harunamitrader
