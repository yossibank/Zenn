# ファイル名の入力プロンプト
read -p "記事ファイル名を入力してください: " INPUT_NAME

# 入力が空ならデフォルト名
INPUT_NAME=${INPUT_NAME:-new_article}

# 拡張子を追加してファイル名を作成
FILENAME="${INPUT_NAME}.md"

# 保存先ディレクトリ
TARGET_DIR="articles"

# テンプレートの内容
TEMPLATE="---
title: \"\"
emoji: \"🔨\"
type: \"tech\" # tech: 技術記事 / idea: アイデア
topics: [iOS, Swift, Xcode]
published: false
---

# はじめに


# 概要


# おわりに


::: details 参考



:::
"

# ファイルを作成
echo "$TEMPLATE" > "$TARGET_DIR/$FILENAME"

# 完了メッセージ
echo "記事を作成しました ✅ $FILENAME"