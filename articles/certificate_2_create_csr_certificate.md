---
title: "iOSの証明書周りをイラストで読み解く 証明書作成編"
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [iOS, Swift, Xcode]
published: true
---

# はじめに

[前回](https://zenn.dev/yossibank/articles/certificate_1_create_public_secret_key)はiOSの証明書周りを理解するための秘密鍵・公開鍵/コード署名編として、コード署名の中の流れやデジタル署名、デジタル証明書の仕組みについて読み解いていきました。

今回はiOS開発において必要なデジタル証明書を実際に作成しながら、必要な手順を読み解いていきます。

![概要図詳細](/images/certificate/2_create_csr_certificate1.png)

# 概要

デジタル証明書は、認証局を通して、公開鍵に自身の情報を含めたものでした。そして、認証局は開発者の公開鍵と開発者情報、その他関連情報を自身の秘密鍵で署名を行い、公開鍵・開発者情報・署名情報をまとめてデジタル証明書として発行します。

![デジタル証明書](/images/certificate/2_create_csr_certificate2.png)

デジタル証明書を取得するためには、まずは申請するために必要な作業である証明書署名要求(CSR: Certificate Signing Request)の作成を行います。

## CSR

CSRは、いわゆる自身の公開鍵と開発者情報を認証局に送るための準備になります。また、CSRは`.certSigningRequest`ファイル形式で生成されます。

![CSR](/images/certificate/2_create_csr_certificate3.png)

では、実際にCSRを作成してみましょう。

### CSR作成

1. キーチェーンアクセス → 証明書アシスタント → 認証局に証明書を要求

![CSR作成手順1](/images/certificate/2_create_csr_certificate4.png)

1. CSRに必要な情報を入力、ローカルマシンに保存

![CSR作成手順2](/images/certificate/2_create_csr_certificate5.png)

3. 鍵ペア情報入力

![CSR作成手順3](/images/certificate/2_create_csr_certificate6.png)

CSRの作成の際には、自身の公開鍵と秘密鍵のペアが作成され、ローカルマシン内のキーチェーンに保存されます。鍵はCSR作成の通称で設定した名前で生成されます。

![CSR作成後の鍵の場所](/images/certificate/2_create_csr_certificate7.png)

CSRの作成が完了したので、次はこのCSRを使ってAppleの認証局を通じてデジタル証明書の発行をしていきましょう。

## デジタル証明書

iOSにおいては、認証局はApple Root Certification Authorityとなり、作成したCSRを提出することでデジタル証明書が発行されます。

![iOSデジタル証明書](/images/certificate/2_create_csr_certificate8.png)

では、実際にデジタル証明書を発行してみましょう。

### デジタル証明書発行

1. Apple Developer Programから証明書(Certificates＋)選択 → 証明書作成用途に応じて証明書選択

![iOSデジタル証明書発行手順1](/images/certificate/2_create_csr_certificate9.png)

![iOSデジタル証明書発行手順1-2](/images/certificate/2_create_csr_certificate10.png)

2. 作成したCSRを選択

![iOSデジタル証明書発行手順2](/images/certificate/2_create_csr_certificate11.png)

3. 発行された証明書をローカルマシンにダウンロード

![iOSデジタル証明書発行手順3](/images/certificate/2_create_csr_certificate12.png)

これでコード署名で使われるデジタル証明書の発行まですることができました。

![デジタル証明書発行完了](/images/certificate/2_create_csr_certificate13.png)

# おわりに

iOSにおける認証局のApple Root Certification Authorityを通じて、デジタル証明書の発行までを実際にローカルマシンで追いながら確認することができました。

次回は、ローカルマシン上でのデジタル証明書の登録、秘密鍵との紐付きについて読み解いていきます。

# 参考文献

[Xcode と署名](https://scrapbox.io/tasuwo-ios/Xcode_%E3%81%A8%E7%BD%B2%E5%90%8D)

[iOSアプリのプロビジョニング周りを図にしてみる](https://qiita.com/fujisan3/items/d037e3c40a0acc46f618)

[iOSのコード署名がなんのためにどうやって行われているかを理解する](https://qiita.com/maiyama18/items/88567365dde2a3b3cc92#%E3%82%B3%E3%83%BC%E3%83%89%E7%BD%B2%E5%90%8D%E3%81%AE%E7%99%BB%E5%A0%B4%E4%BA%BA%E7%89%A9)
