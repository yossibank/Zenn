---
title: "iOSの証明書周りをイラストで読み解く 証明書登録編"
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [iOS, Swift, Xcode]
published: false
---

# はじめに

[前回](https://zenn.dev/yossibank/articles/certificate_2_create_csr_certificate)はiOSの証明書周りを理解するための証明書発行編として、実際にローカルマシンでCSRの作成、デジタル証明書を発行しながら読み解いていきました。

https://zenn.dev/yossibank/articles/certificate_2_create_csr_certificate

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

## Code Signing Identity

Code Signing Identityは、証明書に含まれている公開鍵、開発者情報、認証局での署名情報と公開鍵とペアの秘密鍵を含んでいます。また、Code Signing Identityは`.p12`ファイル形式で生成されます。

![Code Signing Identity](/images/certificate/3_register_certificate5.png)

Code Signing Identityの作成は、キーチェーン上で対象の証明書、秘密鍵を書き出すことでローカルマシンに保存することができます。

書き出し | p12ファイル保存
:--: | :--:
![書き出し](/images/certificate/3_register_certificate6.png) | ![p12ファイル作成](/images/certificate/3_register_certificate7.png)

p12ファイルは様々な用途で使用できます。例えば、ローカルマシンを新しく買い替えた時などです。本来は新しいローカルマシンには秘密鍵がないため、CSRから証明書を作り直す必要がありますが、Code Signing Identityを書き出してp12ファイルで保存しておけば、p12ファイルを取り込むだけで済みます。

![p12買い替え](/images/certificate/3_register_certificate8.png)

また、チーム開発の際は一つのCode Signing Identityを共有することで、個別でわざわざ作る必要がなくなります。

![p12チーム開発](/images/certificate/3_register_certificate9.png)

他にもBitriseといったCI/CDツールでもコード署名をする際に必要になったりします。

# おわりに

証明書をローカルマシンに取り込んだ際の秘密鍵との紐付き、ならびにCode Signing Identityの役割を確認することができました。

次回(準備中)は、Provisioning Profileの作成について読み解いていきます。

:::details 参考

https://scrapbox.io/tasuwo-ios/Xcode_%E3%81%A8%E7%BD%B2%E5%90%8D

https://qiita.com/fujisan3/items/d037e3c40a0acc46f618

https://qiita.com/maiyama18/items/88567365dde2a3b3cc92#%E3%82%B3%E3%83%BC%E3%83%89%E7%BD%B2%E5%90%8D%E3%81%AE%E7%99%BB%E5%A0%B4%E4%BA%BA%E7%89%A9

:::
