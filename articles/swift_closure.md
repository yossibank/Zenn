---
title: "Swiftのクロージャをイラストで理解する"
emoji: "🔨"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [iOS, Swift, Xcode]
published: true
---

# はじめに

プログラミング初学者の方に説明する機会が多くあったので、とりあえず概要を理解できるようにイラストでまとめてみました。(N番煎じ)

# クロージャとは

とりあえずドキュメントを確認してみると以下のような記述があります。

> Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to closures, anonymous functions, lambdas, and blocks in other programming languages.

https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/

クロージャとは、自己完結型の機能ブロックのことで、コード内で受け渡ししたり使用したりすることができるとのことです。

もう少し分かりやすい表現にすると、ブロック内にある処理を実行するコードのかたまりのことです。

## 現実世界で表現してみる

現実の世界で表すと、クロージャはちょっとした作業をひとまとまりにまとめたものになります。

例えば、「コーヒーを入れる」という作業があった時に、どの種類の豆を入れるのか、どれぐらいの量を入れるのかなどをレシピとしてまとめておきます。

このように作業をレシピとしてまとめておけば、コーヒーを入れる際にいつでもレシピを使ってコーヒーを入れることができます。

![現実世界クロージャ](/images/closure/closure1.png)

レシピを作成することのメリットは以下のような点です。

1. **自立した情報となっている**

レシピは必要な情報や手順などが全て記載されています。そのため、そのレシピを使う人がどのような人であっても期待したものを作成することができます。

![現実世界メリット1](/images/closure/closure2.png)

2. **どの場所でも作ることができる**

レシピがあれば家でもオフィスでも、どこでも作ることができます。情報や手順は全てレシピに記載されているため、それを使う環境に左右されることなく期待したものを作成することができます。

![現実世界メリット2](/images/closure/closure3.png)

3. **カスタマイズができる**

レシピに情報を追加することで、完成品をカスタマイズすることができます。これは希望通りのものを作るために、容易に手順を変えることができる柔軟性を持ち合わせています。

![現実世界メリット3](/images/closure/closure4.png)

## コードで表現してみる

先ほどの現実世界で例として挙げた「コーヒーを入れる」という作業をクロージャとしてコードで表現してみます。

``` swift
let recipe: (String, String) -> String = { (beans: String, size: String) -> String in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}

let coffee = recipe("ブルーマウンテン", "large")
print(coffee) // 使った豆: ブルーマウンテン, サイズ: large
```

コメントを付けて、細かく見ていくと以下のような形になります。

``` swift
// 変数・定数定義: (ブロックの中で使用したいデータ型) -> 戻り値のデータ型 = { (使用する情報名: データ型) -> 戻り値のデータ型 in
//   return 実行したい処理
// }
let recipe: (String, String) -> String = { (beans: String, size: String) -> String in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}

let coffee = recipe("ブルーマウンテン", "large")
print(coffee) // 使った豆: ブルーマウンテン, サイズ: large
```

変数・定数定義をせずにクロージャだけの部分を整理すると、クロージャはこの形が基本形となります。

``` swift
{ (使用する情報名: データ型) -> 戻り値のデータ型 in
    return 実行したい処理
}
```

### クロージャの書き方

クロージャには様々な方法で表現することができます。

1. **型の省略**

クロージャ内で戻り値の型が明示的の場合、戻り値のデータ型を省略することができます。

``` swift
let recipe: (String, String) -> String = { (beans: String, size: String) in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}
```

クロージャ内で明示的に型定義をしていた場合、変数・定数に対してのデータ型を省略することができます。

``` swift
let recipe = { (beans: String, size: String) in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}
```

変数・定数で明示的にデータ型を定義していた場合、クロージャ内で使用する情報名、戻り値に対してのデータ型を省略することができます。

``` swift
let recipe: (String, String) -> String = { beans, size in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}
```

クロージャのブロック内のコードが1行の場合、`return`を省略することができます。

``` swift
let recipe: (String, String) -> String = { beans, size in
    "\("使った豆: \(beans)"), \("サイズ: \(size)")"
}
```

2. **引数名の簡略化**

変数・定数で明示的にデータを定義していた場合には、クロージャ内で使用する情報名を省略して`$インデックス値`で取得することができます。

``` swift
let recipe: (String, String) -> String = {
    let recipe1 = "使った豆: \($0)" // 1番目のインデックス値は0のため「$0」で取得できる
    let recipe2 = "サイズ: \($1)" // 2番目のインデックス値は1のため「$1」で取得できる
    return "\(recipe1), \(recipe2)"
}
```

### 関数との違い / 使い分け

関数についてもクロージャの一種です。そのため、関数とクロージャの役割は似たようなものになりますが、いくつか違いについて挙げたいと思います。

1. **名前を持つかどうか**

関数には`func 関数名() { 処理 }`のように名前を持っているため、さまざまな箇所で複数回を呼び出す際に便利です。

クロージャは名前を持たない無名関数とも呼ばれており、より短い書き方で表現することができます。

``` swift
// 関数
func makeCoffee(beans: String, size: String) -> String {
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}

let coffee = makeCoffee(beans: "ブルーマウンテン", size: "large")
print(coffee) // 使った豆: ブルーマウンテン, サイズ: large

// クロージャ
let recipe: (String, String) -> String = { (beans: String, size: String) -> String in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}

let coffee = recipe("ブルーマウンテン", "large")
print(coffee) // 使った豆: ブルーマウンテン, サイズ: large
```

2. **キャプチャをできるかどうか**

クロージャにはクロージャが定義されたブロック内の変数や定数を保持し、クロージャ内で後から参照・使用できるキャプチャの機能を持っています。キャプチャされた変数は、クロージャが存在する限り、生存する期間が延長され、メモリ上に保持され続けます。

``` swift
// 関数(コーヒーの総数をカウントし、そのカウントを返す)
// ただし、関数が呼び出されるたびにtotalCountはリセットされるため、
// 常に1を返す
func makeFuncCoffee() -> Int {
    var totalCount = 0
    totalCount += 1
    return totalCount
}

// 関数makeFuncCoffeeを4回呼び出しても、カウントは呼び出すたびにリセットされるため
// 出力は常に1となる
print(makeFuncCoffee()) // 1
print(makeFuncCoffee()) // 1
print(makeFuncCoffee()) // 1
print(makeFuncCoffee()) // 1

// クロージャ(コーヒーの総数をカウントするクロージャを返す)
// 関数内で定義された変数totalCountはクロージャによってキャプチャされ、
// その後の呼び出しで共有される
func makeClosureCoffee() -> () -> Int {
    var totalCount = 0

    // クロージャがスコープ外のtotalCountをキャプチャする(値の保持)
    let totalCountClosure: () -> Int = {
        totalCount += 1
        return totalCount
    }

    return totalCountClosure
}

// 同じクロージャインスタンスを使ってカウントを増やしていくため、
// 呼び出しのたびにカウントが累積される
let coffee = makeClosureCoffee()
print(coffee()) // 1
print(coffee()) // 2
print(coffee()) // 3
print(coffee()) // 4
```

3. **引数に対する処理**

関数では外部引数名、デフォルト引数が使用できますが、クロージャでは使用することができません。

* 外部引数名
  * 引数を設定する際に、外部へ渡す引数名と内部で扱う引数名を別々にすることができる

``` swift
// 🙆‍♂️ 関数
func makeCoffee(beans first: String, size second: String) -> String {
    let recipe1 = "使った豆: \(first)"
    let recipe2 = "サイズ: \(second)"
    return "\(recipe1), \(recipe2)"
}

let coffee = makeCoffee(beans: "ブルーマウンテン", size: "large")

// 🙅‍♂️ クロージャ
let recipe = { (beans first: String, size second: String) -> String in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}
```

* デフォルト引数
  * 引数の値に対してデフォルトの値を設定する
  * 呼び出し時に設定しなかった場合はデフォルト値が使用される

``` swift
// 🙆‍♂️ 関数
func makeCoffee(beans: String, size: String = "large") -> String {
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}

let coffee = makeCoffee(beans: "ブルーマウンテン")

// 🙅‍♂️ クロージャ
let recipe = { (beans: String, size: String = "large") -> String in
    let recipe1 = "使った豆: \(beans)"
    let recipe2 = "サイズ: \(size)"
    return "\(recipe1), \(recipe2)"
}
```

# おわりに

クロージャもただの処理のかたまりと思えば、理解しやすくなったのではないかと思います。

少しでもこちらの記事が参考になれば幸いです。


::: details 参考

https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/

:::
