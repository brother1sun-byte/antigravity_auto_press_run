![Antigravity Auto Press Run](./header.jpg)

# Antigravity Auto Press Run

**Antigravity Auto Press Run** は、AI コーディングアシスタント「Antigravity（VSCode 拡張機能）」が表示する許可確認ボタン（`Allow Once`・`Allow This Conversation`・`Run` など）を自動でクリックするための、軽量なバックグラウンドスクリプトです。

## 概要

Antigravity は、ファイルアクセスやコマンド実行の許可を求める確認ダイアログを頻繁に表示します。このスクリプトは、Chrome DevTools Protocol（CDP）経由で Antigravity の UI を監視し、対象ボタンを検知次第、自動でクリックします。

---

> [!CAUTION]
> ## ⚠️ 重大な警告：このスクリプトの使用には重大なリスクがあります
>
> このスクリプトは Antigravity が表示する**すべての許可確認を無条件・無検閲で自動承認**します。
>
> また、このツールの使用は利用規約違反となる可能性があります。
>
> これは以下のような**取り返しのつかない操作も自動で許可してしまう**ことを意味します：
>
> - **ファイルの削除・上書き**（プロジェクト全体の消去を含む）
> - **システムコマンドの実行**（管理者権限のある操作も含む）
> - **外部ネットワークへのアクセス・データ送信**
> - **環境変数・秘匿情報（APIキー等）の読み取り**
>
> **ご使用にあたっての最低限の安全策：**
> - 重要なファイルは事前にバックアップを取ること
> - 信頼できるプロンプト・タスクの実行時のみ起動すること
> - AI に大規模な操作をさせていない時間帯は必ず停止すること
> - 本番環境・本番データベースに接続した状態では絶対に使用しないこと
>
> **自己責任でご使用ください。発生した損害について開発者は一切の責任を負いません。**

---
## おすすめの導入方法

antigravityのAIチャットに以下のプロンプトを入力してください。
「https://github.com/harunamitrader/antigravity_auto_press_run を導入して。可能な範囲でAI側で作業を行い、必要な情報があれば質問して。手動で行う必要があるものは丁寧にやり方を教えて。」

導入が完了したら、
「デバッグモード用ショートカットとantigravity_auto_press_runの起動用ショートカットをデスクトップに作成して」
も必要に応じてプロンプトを送信しても良いかもしれません。

導入方法でわからないことやエラーがあれば都度antigravityのAIチャットで質問すればどうにか導入できるはずです。


## 動作前提：Antigravity をデバッグモードで起動する

このスクリプトは Chrome DevTools Protocol（CDP）を使って Antigravity の UI に接続します。そのため、**Antigravity（VSCode）をデバッグポートを有効にした状態で起動する必要があります。**

### VSCode のデバッグポートを有効にする方法

VSCode の起動オプションに `--remote-debugging-port=9222` を追加します。

**方法 1：コマンドラインから起動**

```bash
code --remote-debugging-port=9222
```

**方法 2：ショートカットに引数を追加（Windows）**

1. VSCode のショートカットを右クリック →「プロパティ」
2. 「リンク先」の末尾に ` --remote-debugging-port=9222` を追加
3. 例：`"C:\...\Code.exe" --remote-debugging-port=9222`

> [!NOTE]
> デバッグポートが有効でない状態でこのスクリプトを起動しても、接続に失敗して自動クリックは動作しません。

## 機能

- **自動検知・クリック**: Antigravity の許可確認ダイアログを 5 秒間隔（デフォルト）で自動検知し、クリックを実行します。
- **二段階クリック方式**: CDP 経由のマウスイベント（座標クリック）に加え、DOM 要素に対する JavaScript 直接実行（`.click()`）を併用することで、画面外や描画遅延時でもより確実な動作を実現しています。
- **コンテキストログ**: クリック前に「何が許可されようとしているか」の文脈を抽出し、ログとして出力します。
- **複数ポートの自動探索**: 標準の `9222` 番ポートに加え、`9000`〜`9003` 番ポートも自動的にスキャンして Antigravity の UI を見つけ出します。
- **ログの永続化**: 実行履歴をコンソールだけでなく、`auto_press_run.log` ファイルにも自動保存します。
- **自動再接続**: 通信が切断された場合でも、再度ターゲットを探して自動的に復旧します。
- **堅牢な設計**: 未ハンドルの例外が発生してもプロセスを落とさず継続するエラーハンドラーを搭載しています。
- **安全のための除外**: `Always run` や `常に許可` 系のボタンは、意図しない恒久的な許可を防ぐためにあえて除外しています。

## インストール

```bash
git clone https://github.com/<あなたのGitHubユーザー名>/antigravity_auto_press_run.git
cd antigravity_auto_press_run
npm install
```

## 使い方

### 前提：Antigravity をデバッグポート付きで起動してから、このスクリプトを起動してください。

### 方法 1：コマンドラインから起動（推奨）

```bash
npm start
```

### 方法 2：バッチファイルから起動（Windows）

`start_bot.bat` をダブルクリック、またはデスクトップのショートカットから起動します。

### ログの見方

実行履歴はコンソールに表示されるほか、同ディレクトリ内の `auto_press_run.log` にも追記されます。

```text
[10:30:01] Starting Antigravity Auto Press Run background process...
[10:30:01] Found primary target on port 9222: helloworld - Antigravity
[10:30:01] Connected to Antigravity UI!
[10:30:06] [Action] "Allow Once" ボタンを自動クリックします
  ┗ [Context]
      Allow file access to
      C:\path\to\your\project\file.js
      Deny  Allow Once  Allow This Conversation
```

## 自動クリック対象ボタン（優先順位順）

| 優先度 | ボタン名 |
|--------|----------|
| 1 | Run |
| 2 | Allow Once |

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
