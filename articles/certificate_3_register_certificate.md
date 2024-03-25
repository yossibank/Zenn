---
title: "iOSの証明書周りをイラストで読み解く 証明書登録編"
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [iOS, Swift, Xcode]
published: false
---

# はじめに

[前回](https://zenn.dev/yossibank/articles/certificate_2_create_csr_certificate)はiOSの証明書周りを理解するための証明書作成編として、実際にローカルマシンでCSR、デジタル証明書を発行しながら読み解いていきました。

今回は発行したデジタル証明書をローカルマシンに取り込んだときに、どのように管理されているかを読み解いていきます。

![概要図詳細](/images/certificate/3_register_certificate1.png)

# 概要

前回、デジタル証明書をローカルマシンにダウンロードまで行いましたが、証明書にはCSRで作成した公開鍵、開発者情報、認証局のApple Root Certification Authorityでの署名情報が含まれています。また、証明書は`.cer`ファイル形式で生成されます。

![デジタル証明書](/images/certificate/3_register_certificate2.png)

ダウンロードした証明書をダブルクリックすることでローカルマシンに取り込むことができます。取り込んだ際には、証明書に含まれている公開鍵とペアの秘密鍵が紐付かれ、キーチェーンで以下のように表示されます。

※ 証明書に対して秘密鍵が紐付かなかった場合には、CSRで作成された秘密鍵がローカルマシンに存在しないことを意味します

cer | キーチェーン
:--: | :--:
![cer](/images/certificate/3_register_certificate3.png) | ![キーチェーン](/images/certificate/3_register_certificate4.png)

ここで、証明書と秘密鍵が紐づいてペアとなったものは[identity](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/identities)と呼ばれ、特にコード署名においてはCode Signing Identityと呼ばれます。

![Code Signing Identity](/images/certificate/3_register_certificate5.png)

## Code Signing Identity

# おわりに

:::details 参考

https://scrapbox.io/tasuwo-ios/Xcode_%E3%81%A8%E7%BD%B2%E5%90%8D

https://qiita.com/fujisan3/items/d037e3c40a0acc46f618

https://qiita.com/maiyama18/items/88567365dde2a3b3cc92#%E3%82%B3%E3%83%BC%E3%83%89%E7%BD%B2%E5%90%8D%E3%81%AE%E7%99%BB%E5%A0%B4%E4%BA%BA%E7%89%A9

:::
