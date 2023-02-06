---
sidebar_position: 1
---

# プロジェクトの作成

以下ので「thanks-card-app」という名前のプロジェクトを作成することができます。

ここでは Android で実行することを前提としております。
Ionic は iPhone 用のアプリを開発することも可能です。

## Ionic-CLI のインストール

> Ionicアプリは、主にIonic CLI（command-line）を利用して作成・開発します。Ionic CLIは、幅広い開発ツールと開発を手助けするオプションを提供している、Ionic teamが推奨しているインストール方法です。Ionic CLIは、アプリの実行や、Appflowといった他のサービスに接続などができる重要なツールです。

[Ionicのインストール](https://ionicframework.jp/docs/intro/cli/)

以下の手順で Ionic CLI をインストールしてください。

```shell
npm install -g @ionic/cli
```

proxy 環境下で開発している場合、以下のコマンドで Ionic CLI の proxy を設定してください。

```shell
ionic config set -g proxy http://proxy.occ.co.jp:8080
```


## プロジェクトの作成

```shell
ionic start thanks-card-app sidemenu --type=react --capacitor
cd thanks-card-app
```



## Android 開発環境の構築

thanks-card-app ディレクトリで以下のコマンドを実行し、プロジェクトに Android アプリ開発用の設定を追加してください。

```shell
ionic capacitor add android
```

以下のドキュメントを参照し「[Android Studio - Android Studioのインストール](https://ionicframework.com/docs/ja/developing/android#android-studio)」から「[Android Studio - Android仮想デバイスの作成](https://ionicframework.jp/docs/developing/android/#android%E4%BB%AE%E6%83%B3%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AE%E4%BD%9C%E6%88%90)」を実行してください。
(Android の実機を使いたい場合は「[Androidデバイスを設定する](https://ionicframework.jp/docs/developing/android/#android%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B)」も実施してください。

[Androidでの開発](https://ionicframework.com/docs/ja/developing/android)

(**注1**) 「[Android仮想デバイスの作成](https://ionicframework.jp/docs/developing/android/#android%E4%BB%AE%E6%83%B3%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AE%E4%BD%9C%E6%88%90)」の以下は情報が古いため読み替えてください。

> Create Virtual Device をクリックし、適切なデバイス定義を選択します。不明な場合は、 **Pixel 2** を選択し、適切なシステムイメージを選択します。よく分からない場合は、**Pie (API 28) with Google Play services** を選択してください。Androidのバージョンについては、Androidのバージョン履歴を参照してください。

- 「**Pixel 2**」→「**Pixel 6**」
- 「**Pie (API 28) with Google Play services**」→「**S (API 31) with Google Play services**」

