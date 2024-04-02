# ファイル名を引数から取得する
FILENAME=${1:-new_article.md}

# テンプレートの内容
TEMPLATE="---
title: \"\"
emoji: \"\"
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

# テンプレートをファイルに書き出す
echo "$TEMPLATE" > articles/$FILENAME

echo "create article $FILENAME ✅"
