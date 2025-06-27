
# はじめに

iOSアプリを開発・公開する上で必要になってくるのが証明書周りの知識ですが、はじめは様々な用語が出るので混乱してしまっていました。

私自身が整理していく中で、証明書周りの関係をイラストにしてみるとざっくりと全体像の把握がしやすかったため、今回はなるべくイラストを使ってご紹介していきたいと思います。

# 全体像

今回見ていくiOS証明書周りの全体像になります。

![全体像](/images/certificate/overview.png)

※ iOSの証明書周りの全体像を説明する上で、こちらの記事が大変分かりやすいため、こちらを参考に作成いたしました

https://qiita.com/fujisan3/items/d037e3c40a0acc46f618

全体像の1から順番にご紹介しますが、まずはじめに事前知識として、データのやり取りの際に用いられるデータの暗号化、鍵、コード署名について理解していきます。

# データの暗号化・鍵

まずはシンプルなAさんとBさんのデータのやり取りをイラストで表してみます。

![データのやり取り](/images/certificate/data_encrypt_key1.png)

このままですと、悪意を持った第三者からデータを盗み見される可能性があります。

![データの盗み見](/images/certificate/data_encrypt_key2.png)

データの暗号化は、こうしたデータの内容を第三者から見られるのを防ぐためにデータを加工することです。

データを暗号化することで、受け取った側は暗号化されたデータを元のデータに戻す復号をしない限りは確認することができません。そのため、第三者から盗み見されたとしてもデータの内容を知ることができません。

![データの暗号化](/images/certificate/data_encrypt_key3.png)

そして、データを暗号化・復号するためには「鍵」というものが必要になります。

データを暗号化する方法として、暗号化と復号に同じ鍵を使う「共通鍵暗号方式」と別々の鍵を用いる「公開鍵暗号方式」に分けられます。

## 共通鍵暗号方式

暗号化と複合に同じ鍵を用いる暗号方式です。

![共通鍵暗号方式](/images/certificate/data_encrypt_key4.png)

前述したように、第三者から盗み見されたとしても、暗号化されたデータであるためデータの内容を知ることができません。

しかし、共通鍵暗号方式には問題点があります。それが、データを受け取る側が共通鍵を持っておらず、送る側が共通鍵も一緒に渡す場合に、第三者が盗み見した時にその共通鍵を使ってデータを復号できてしまうことです。

![共通鍵暗号方式問題点](/images/certificate/data_encrypt_key5.png)

このように、公開鍵をそのまま送信すると第三者に盗まれてしまうため、安全に鍵を配送する手段を取る必要があります。(鍵配送問題)

## 公開鍵暗号方式

暗号化と複合に異なるペアとなる鍵を用いる暗号方式です。

暗号化に使う鍵を「公開鍵」、復号に使う鍵を「秘密鍵」として、それぞれが別々の機能を持ちます。

![公開鍵暗号方式](/images/certificate/data_encrypt_key6.png)

受け取る側(Bさん)が送る側(Aさん)に対して事前に公開鍵を送っておき、その公開鍵を使ってデータを暗号化します。

暗号化されたデータは公開鍵のペアとなる秘密鍵でしか復号できません。そのため、公開鍵と暗号化されたデータを第三者に盗み見された場合でも暗号化されたデータを復号できるのは秘密鍵であるため、元のデータに復号することはできません。

公開鍵暗号方式では共通鍵暗号方式の問題としてあった鍵配送問題を解決することができますが、一方で公開鍵の信頼性に関する問題があります。

公開鍵には作成者などに関する情報を持たないため、データを受け取る側(Bさん)が送る側(Aさん)に公開鍵を渡す際に、第三者が自身で作成した公開鍵とすり替えても、送る側(Aさん)が受け取る側(Bさん)からの公開鍵なのか、第三者にすり替えられた公開鍵なのかを判断することができません。

![公開鍵暗号方式問題点](/images/certificate/data_encrypt_key7.png)

# コード署名

秘密鍵・公開鍵はiOSにおいてはコード署名の際に使用されることになります。コード署名とは、以下のようなことを可能にするための仕組みです。

* アプリケーションの正当性の検証
* アプリケーションの完全性の保証
* 開発者IDの確認
* 安全なアプリケーションの配布

具体的に実現していることは以下の2点であり、これらをそれぞれ確認してみます。

1. アプリケーションの正当性の検証(改竄などがないかどうかの検証)
2. 開発者または企業の真正性の保証(特定の開発者・企業のアプリケーションかどうかの証明)

## 目的

### アプリケーションの正当性の検証(改竄などがないかどうかの検証)

アプリケーションのコードが改竄されていないことを確認するにはハッシュ関数が用いられます。

ハッシュ関数とは、与えられたデータを固定長の不規則な値に変換する関数のことを指します。

![ハッシュ関数](/images/certificate/code_signing1.png)

ハッシュ関数には、同じ入力なら出力は必ず同じになる、ハッシュ値から元のデータを逆算することはできないといった特徴を持っています。

![ハッシュ関数特徴](/images/certificate/code_signing2.png)

アプリケーションのコードにおいても、アプリケーションのコードをハッシュ関数でハッシュ化し、そのハッシュ値を使って改竄されていないかどうかの検証が行われます。

![ハッシュ関数アプリケーションコード](/images/certificate/code_signing3.png)

しかし、そのままアプリケーションのコードをハッシュ関数を使ってハッシュ化し、ハッシュ値で検証するだけでは不十分です。その情報が開発者によって実際に作成され、送信中に改竄されていないことを証明できないからです。

![ハッシュ関数アプリケーションコード問題点](/images/certificate/code_signing4.png)

そこで、開発者を特定し改竄の検証もするためにデジタル署名が利用されます。

### 開発者または企業の真正性の保証(特定の開発者・企業のアプリケーションかどうかの証明)

デジタル署名では、ハッシュ値と公開鍵・秘密鍵を使用してデータの真正性、完全性、送信者の認証を保証するものです。コード署名では、アプリケーションのコードのハッシュ値を秘密鍵を使って署名を行い、公開鍵を使って検証します。

![デジタル署名](/images/certificate/code_signing5.png)

公開鍵を使って送られてきた署名を復号できるのは、それのペアとなる秘密鍵を使って暗号化した署名者の署名のみです。つまり、データを復号できた場合には、秘密鍵を持っている所有者によって署名されたデータであることが保証され、署名された後にデータの改竄があってもハッシュ値が異なるため不正を検出することができます。

![デジタル署名特徴](/images/certificate/code_signing6.png)

デジタル署名によって、署名後の改竄の検出、特定の開発者(企業)に署名されていることを検証することができるようになりました。

しかし、デジタル署名にも問題点があります。それが公開鍵暗号方式と同じく、公開鍵の信頼性の問題です。公開鍵には作成者などに関する情報を持たないため、第三者がなりすますことができてしまいます。

![デジタル署名問題点](/images/certificate/code_signing7.png)

そこで、公開鍵が信頼でき、真正性を保証するための仕組みとしてデジタル証明書が使用されます。

## デジタル証明書

デジタル証明書は、認証局(CA: Certification Authority)を通して、公開鍵に自身の情報を含めたものです。認証局は開発者の公開鍵と開発者情報、その他関連情報を自身の秘密鍵で署名を行い、公開鍵・開発者情報・署名情報をまとめてデジタル証明書として発行します。

![デジタル証明書](/images/certificate/code_signing8.png)

先ほどのコード署名のデジタル署名の流れの中では、開発者が公開鍵を渡して検証を行なっていましたが、これをデジタル証明書を使って検証するようにします。

![デジタル証明書流れ](/images/certificate/code_signing9.png)

デジタル証明書では公開鍵に含めて署名情報と開発者情報を持っているため、第三者が開発者になりすますことができなくなります。

![デジタル証明書特徴](/images/certificate/code_signing10.png)

これで、コード署名の中でアプリケーションの正当性の検証(改竄などがないかどうかの検証)、開発者または企業の真正性の保証(特定の開発者・企業のアプリケーションかどうかの証明)を確認することができました。

ここまでで、iOSアプリの証明書では公開鍵、秘密鍵の作成、デジタル証明書の発行が必要なことがわかりました。

ここからは、全体像の1から実際にローカルマシンで実行しながら確認していきます。

# 秘密鍵/公開鍵の作成

![秘密鍵・公開鍵の作成概要図](/images/certificate/create_key.png)

秘密鍵/公開鍵については、次のCSR(証明書署名要求)作成の際に自動的に作成されます。そのため、開発者側で何かを行う必要はありません。

# CSR(証明書署名要求)作成

![CSR(証明書署名要求)概要図](/images/certificate/csr1.png)

証明書署名要求(CSR: Certificate Signing Request)は、証明書を発行するために自身の公開鍵と開発者情報を認証局に送るための準備になります。CSRは`.certSigningRequest`ファイル形式で生成されます。

![CSRファイル](/images/certificate/csr2.png)

## CSR作成手順

1. キーチェーンアクセス → 証明書アシスタント → 認証局に証明書を要求

![CSR作成手順1](/images/certificate/csr3.png)

1. CSRに必要な情報を入力、ローカルマシンに保存

![CSR作成手順2](/images/certificate/csr4.png)

3. 鍵ペア情報入力

![CSR作成手順3](/images/certificate/csr5.png)

CSRの作成の際には、自身の公開鍵と秘密鍵のペアが作成され、ローカルマシン内のキーチェーンに保存されます。鍵はCSR作成の通称で設定した名前で生成されます。

![CSR作成後の鍵の場所](/images/certificate/csr6.png)

# 証明書の発行

![証明書の発行概要図](/images/certificate/certificate_issue1.png)

証明書は、iOSにおいては認証局であるApple Root Certification Authorityに対して先ほど作成したCSRを提出することで発行できます。

![iOSデジタル証明書](/images/certificate/certificate_issue2.png)

## 証明書発行手順

1. Apple Developer Programから証明書(Certificates＋)選択 → 証明書作成用途に応じて選択

![iOSデジタル証明書発行手順1](/images/certificate/certificate_issue3.png)

![iOSデジタル証明書発行手順1-2](/images/certificate/certificate_issue4.png)

2. 作成したCSRを選択

![iOSデジタル証明書発行手順2](/images/certificate/certificate_issue5.png)

3. 発行された証明書をローカルマシンにダウンロード

![iOSデジタル証明書発行手順3](/images/certificate/certificate_issue6.png)

これでローカルマシンに証明書がある状態になりました。証明書は`.cer`ファイル形式で生成されます。

![デジタル証明書発行完了](/images/certificate/certificate_issue7.png)

# 証明書の登録・紐付け

![証明書の登録概要図](/images/certificate/certificate_register1.png)

ローカルマシンにダウンロードした証明書をダブルクリックなどして取り込むと、証明書に含まれる公開鍵とペアの秘密鍵が紐付かれ、キーチェーンで以下のように表示されます。

cer | キーチェーン
:--: | :--:
![cer](/images/certificate/certificate_register2.png) | ![キーチェーン](/images/certificate/certificate_register3.png)

※ もし、証明書に対して秘密鍵が紐付かなかった場合には、CSRで作成された秘密鍵がローカルマシンに存在しないなど何かしらの問題がある可能性が高いです

ここで、証明書と秘密鍵が紐づいてペアとなったものは[identity](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/identities)と呼ばれ、特にコード署名においてはCode Signing Identityと呼ばれます。

## Code Signing Identity

Code Signing Identityは、証明書に含まれている公開鍵、開発者情報、認証局での署名情報と公開鍵とペアの秘密鍵を含んでいます。Code Signing Identityは`.p12`ファイル形式で生成されます。

![Code Signing Identity](/images/certificate/certificate_register4.png)

キーチェーン上で対象の証明書、秘密鍵を書き出すことでローカルマシンに保存することができます。

書き出し | p12ファイル保存
:--: | :--:
![書き出し](/images/certificate/certificate_register5.png) | ![p12ファイル作成](/images/certificate/certificate_register6.png)

p12ファイルは様々な用途で使用できます。例えば、ローカルマシンを新しく買い替えた時などです。本来は新しいローカルマシンには秘密鍵がないため、CSRから証明書を作り直す必要がありますが、Code Signing Identityを書き出してp12ファイルで保存しておけば、p12ファイルを取り込むだけで済みます。

![p12買い替え](/images/certificate/certificate_register7.png)

また、チーム開発の際は一つのCode Signing Identityを共有することで、個別でわざわざ作る必要がなくなります。

![p12チーム開発](/images/certificate/certificate_register8.png)

他にもBitriseといったCI/CDツールでコード署名をする際に必要になったりします。

# App IDの登録

![AppIDの登録概要図](/images/certificate/appid1.png)

App IDはアプリケーションを識別するための一意のIDとなるものです。また、プッシュ通知やアプリ内課金といったAppleの機能を利用する際にはAppID上で有効化の設定が必要になります。

![App ID](/images/certificate/appid2.png)

追加できる機能については、XcodeのSinging & Capabilitiesなどから確認できます。それぞれの詳細については[ドキュメント](https://developer.apple.com/documentation/xcode/adding-capabilities-to-your-app)をご確認ください。

https://developer.apple.com/documentation/xcode/adding-capabilities-to-your-app

![Capability](/images/certificate/appid3.png)

## App ID登録手順

1. Apple Developer ProgramからID(Identifiers＋)選択 → App IDs選択

![App ID登録手順1](/images/certificate/appid4.png)

![App ID登録手順1-2](/images/certificate/appid5.png)

2. Select a type 「App」選択

![App ID登録手順2](/images/certificate/appid6.png)

3. 各情報入力

![App ID登録手順3](/images/certificate/appid7.png)

* Description → 登録するApp IDの名前

* Bundle ID → アプリケーションを識別するための一意のID
  1. Explicit → BundleIDを完全一致で特定できるようにする
  2. Wildcard → BundleIDを部分一致でワイルドカード(*)を使用して特定できるようにする

![App ID登録手順3-2](/images/certificate/appid8.png)

* Capabilities → 各アプリ機能を有効にするかどうかの設定

※ Bundle IDでWildcardを選択した場合はCapabilitiesを設定することはできません。そのため各アプリ機能を使用したい場合は、完全一致で特定できるExplicitのBundle IDを設定する必要があります

![App ID登録手順3-3](/images/certificate/appid9.png)

4. App ID登録

![App ID登録手順4](/images/certificate/appid10.png)

![App ID登録手順4](/images/certificate/appid11.png)

# Device IDの登録

![Device IDの登録概要図](/images/certificate/deviceid1.png)

Device IDはデバイスが一意で保持しているID(UDID: Unique Device Identifier)になります。Device IDを登録することで意図したデバイスでのみアプリケーションが実行されるようになり、無許可のデバイスでの実行を防ぐことができます。

![Device ID](/images/certificate/deviceid2.png)

## Device ID登録手順

1. Apple Developer Programからデバイス(Devices＋)選択

![Device ID登録手順1](/images/certificate/deviceid3.png)

2. 各情報入力

![Device ID登録手順2](/images/certificate/deviceid4.png)

* Device Name → 登録する端末の名前

* Device ID (UDID) → 端末のUDID

端末のUDIDはFinderなどから確認できます。

![Device ID登録手順2-2](/images/certificate/deviceid5.png)

3. Device ID登録

![Device ID登録手順3](/images/certificate/deviceid6.png)

![Device ID登録手順3-2](/images/certificate/deviceid7.png)

# Provisioning Profileの登録

![Provisioning Profileの登録概要図](/images/certificate/provisioning_profile1.png)

Provisioning Profileはこれまで作成した証明書、App ID、Device IDを全てまとめたファイルになります。このファイル内の情報を通じて、コード署名やアプリID、端末IDなどのアプリケーションで必要な検証を行います。Provisioning Profileは`.mobileprovision`ファイル形式で生成されます。

![Provisioning Profile](/images/certificate/provisioning_profile2.png)

## Provisioning Profile登録手順

1. Apple Developer programからプロファイル(Profiles＋)選択 → Provisioning Profile作成用途に応じて選択

![Provisioning Profile登録手順1](/images/certificate/provisioning_profile3.png)

![Provisioning Profile登録手順1-2](/images/certificate/provisioning_profile4.png)

2. 使用するApp ID選択

![Provisioning Profile登録手順2](/images/certificate/provisioning_profile5.png)

3. 使用する証明書選択

![Provisioning Profile登録手順3](/images/certificate/provisioning_profile6.png)

4. 許可する端末(UDID)選択

![Provisioning Profile登録手順4](/images/certificate/provisioning_profile7.png)

5. Provisioning Profile登録

![Provisioning Profile登録手順5](/images/certificate/provisioning_profile8.png)

![Provisioning Profile登録手順5](/images/certificate/provisioning_profile9.png)

これで、Provisioning Profileをローカルマシンにダウンロードするところまで完了しました。

![Provisioning Profileダウンロード](/images/certificate/provisioning_profile10.png)

# ビルド・アーカイブ設定・実行

![ビルド・アーカイブの設定・実行概要図](/images/certificate/build_archive1.png)

これまでで必要なものは作成することができたので、ビルド・アーカイブ時に設定して実行します。

今までのことを整理すると、ローカルマシンは以下のような状態になっています。

![ローカルマシン現在状況](/images/certificate/build_archive2.png)

アーカイブとは、アプリケーションを実行するのに必要な全てのファイルをひとまとめにするプロセスです。アーカイブによってひとまとめになったファイルは`.ipa(iOS Package Archive)`ファイル形式で生成されます。このファイルには、コード署名情報、Provisioning Profile、アプリケーションでコンパイルされた実行ファイル、リソースやその他情報ファイルなどが含まれています。

このipaファイルを使って、App StoreやAd Hocでアプリケーションの配布を行います。

![Xcodeアーカイブ](/images/certificate/build_archive3.png)

それでは、Xcodeでビルド・アーカイブをしてみましょう。

## Xcodeでビルド実行手順

Xcodeで指定した端末に対してビルドを実行するには、適切なProvisioning Profileを設定します。

1. ビルドしたい端末を指定

![Xcodeビルド手順1](/images/certificate/build_archive4.png)

2. Provisioning Profileの設定

![Xcodeビルド手順2](/images/certificate/build_archive5.png)

もし、Provisioning Profileの情報と異なる設定になっている場合にはここでエラーが発生します。

例1) Provisioning Profileで登録したApp IDのBundle IDと異なっていた場合

![Xcodeビルドエラー1](/images/certificate/build_archive6.png)

例2) ローカルマシンのCode Signing Identityに秘密鍵が紐づいていなかった場合

紐付いている | 紐付いていない
:--: | :--:
![Xcodeビルドエラー2-1](/images/certificate/build_archive7.png) | ![Xcodeビルドエラー2-2](/images/certificate/build_archive8.png)

![Xcodeビルドエラー2-3](/images/certificate/build_archive9.png)

## Xcodeでアーカイブ実行手順

1. タブ「Product」→ Archive選択

![Xcodeアーカイブ手順1](/images/certificate/build_archive10.png)

2. 「Distribute App」選択

![Xcodeアーカイブ手順2](/images/certificate/build_archive11.png)

3. 配布用途に応じて選択(今回はDebugging)

![Xcodeアーカイブ手順3](/images/certificate/build_archive12.png)

4. ipaファイルのエクスポート

ipa内容 | ローカルマシンに保存
:--: | :--:
![Xcodeアーカイブ手順4](/images/certificate/build_archive13.png) | ![Xcodeアーカイブ手順4-2](/images/certificate/build_archive14.png)

ipaファイルを使うことで、Xcodeでビルドせずとも直接端末にインストールすることもできました。

端末に追加 | 追加するipa選択
:--: | :--:
![Xcodeアーカイブ1](/images/certificate/build_archive15.png) | ![Xcodeアーカイブ2](/images/certificate/build_archive16.png)

端末に追加後 | 端末
:--: | :--:
![Xcodeアーカイブ3](/images/certificate/build_archive17.png) | ![Xcodeアーカイブ4](/images/certificate/build_archive18.png)

# TIPS

## 証明書の管理

チーム開発において証明書の管理は複雑になりがちです。

例えば、チーム開発をしている中で新たにメンバーが入った際には、例えば以下のような対応が必要になります。

対応①) 新しいメンバーの証明書、端末IDを作成、追加してProvisioning Profileを更新するパターン

1. (Apple Developer Programのアカウントを作成、招待し)新しいメンバーの証明書を作成
2. 新しいメンバーの端末のDevice IDを登録
3. 既存のProvisioning Profileの更新(新しいメンバーの証明書、Device IDを追加)

![署名書管理対応1](/images/certificate/tips1.png)

対応②) 新しいメンバーにCode Signing Identity(p12)を渡し、端末IDのみを追加してProvisioning Profileを更新するパターン

1. 新しいメンバーに開発メンバーがCode Signing Identity(p12)を渡す
2. 新しいメンバーの端末のDevice IDを登録
3. 既存のProvisioning Profileの更新(新しいメンバーのDevice IDを追加)

![署名書管理対応2](/images/certificate/tips2.png)

このように開発メンバーが変更するたびに、Provisioning Profileを更新する必要があるため、これらの作業を手動でやるのは非常に手間で人為的ミスが発生するリスクがあります。

そのため、これらの証明書の作業はなるべく全て自動化したいものですが、これを解決したのがfastlaneのmatchになります。

### fastlane match

fastlane matchでは管理者が証明書周りの情報全てを管理します。GitHubのプライベートリポジトリなどで証明書(.cer)、Code Signing Identity(.p12)、Provisioning Profile(.mobileprovision)を保存し、開発者メンバーはコマンド1つで必要な証明書などの情報を取得することができます。

![fastlane match](/images/certificate/tips3.png)

証明書の管理は煩雑になりがちになるため、チームで開発する際には導入することで手動管理をせずに済みます。

https://docs.fastlane.tools/actions/match/

# おわりに

証明書周りをイラストでイメージしながら実際に作成して進めてみましたが、出てくる用語に対してのイメージがしやすくなったのではないかと思います。

少しでもこちらの記事が参考になれば幸いです。

:::details 参考

https://www.shoeisha.co.jp/book/detail/9784798172439

https://qiita.com/maiyama18/items/88567365dde2a3b3cc92#%E3%82%B3%E3%83%BC%E3%83%89%E7%BD%B2%E5%90%8D%E3%81%AE%E7%99%BB%E5%A0%B4%E4%BA%BA%E7%89%A9

https://qiita.com/fujisan3/items/d037e3c40a0acc46f618

https://kumaskun.hatenablog.com/entry/2022/09/20/210919

https://scrapbox.io/tasuwo-ios/Xcode_%E3%81%A8%E7%BD%B2%E5%90%8D

:::
