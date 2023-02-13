# AWS 基礎知識

## コース説明

AWS について学ぶ。

## アマゾン ウェブ サービス（AWS）とは？

> Amazon 社内のビジネス課題を解決するために生まれた IT インフラストラクチャのノウハウをもとに、2006 年、アマゾン ウェブ サービス（AWS）はウェブサービスという形態で、企業を対象に IT インフラストラクチャサービスの提供を開始しました。

[参照 - アマゾン ウェブ サービス（AWS）とは？](https://aws.amazon.com/jp/about-aws/)

## アマゾン ウェブ サービス（AWS）とは？（日本語字幕）

[ビデオ教材](http://172.16.9.137/share/新入社員研修/教材/クラウドコンピューティング基礎/アマゾン%20ウェブ%20サービス（AWS）とは？（日本語字幕）-RrdwaCG8xjU.mp4)

[オリジナルビデオ教材 - アマゾン ウェブ サービス（AWS）とは？（日本語字幕）](https://www.youtube.com/watch?v=RrdwaCG8xjU)

## アマゾンウェブサービス（AWS）とは？ | AWS (日本語字幕) (3:11)

[ビデオ教材 - アマゾンウェブサービス（AWS）とは？ | AWS (日本語字幕) (3:11)](http://172.16.9.137/share/新入社員研修/教材/クラウドコンピューティング基礎/アマゾンウェブサービス（AWS）とは？%20%20_%20AWS%20%28日本語字幕%29%20%283_11%29-TkPfiAwB7j8.mp4)

[オリジナルビデオ教材 - アマゾンウェブサービス（AWS）とは？ | AWS (日本語字幕) (3:11)](https://www.youtube.com/watch?v=TkPfiAwB7j8)


## まるわかりクラウド入門 | AWS Summit Tokyo 2016

[ビデオ教材 - まるわかりクラウド入門 | AWS Summit Tokyo 2016](http://172.16.9.137/share/新入社員研修/教材/クラウドコンピューティング基礎/まるわかりクラウド入門%20_%20AWS%20Summit%20Tokyo%202016-Kf16UrJayew.mp4)

[オリジナルビデオ教材 - まるわかりクラウド入門 | AWS Summit Tokyo 2016](https://www.youtube.com/watch?v=Kf16UrJayew)

## いまさら聞けない AWS 入門 | AWS Summit Tokyo 2016

[ビデオ教材 - いまさら聞けない AWS 入門 | AWS Summit Tokyo 2016](http://172.16.9.137/share/新入社員研修/教材/クラウドコンピューティング基礎/いまさら聞けない%20AWS%20入門%20_%20AWS%20Summit%20Tokyo%202016-wVlRnmB6Ra4.mp4)

[オリジナルビデオ教材 - いまさら聞けない AWS 入門 | AWS Summit Tokyo 2016](https://www.youtube.com/watch?v=wVlRnmB6Ra4)


## [Amazon クラウド製品](https://aws.amazon.com/jp/products/)(ネットワーキングとコンテンツ配信) を使う事により構築しなくてもよくなったもの

製品名 | 役割 | 構築しなくてもよくなったもの 
------------ | ------------- | ------------- 
[Amazon VPC](https://aws.amazon.com/jp/vpc/?c=19&pt=1)| AWS クラウド内で論理的に分離したセクションをプロビジョニングし、お客様が定義する仮想ネットワークで AWS リソースを起動できます。 | 物理的なラックの構築、ネットワーク機器の配備
[Amazon EC2](https://aws.amazon.com/jp/ec2/) | クラウド内の安全でサイズ変更可能なコンピューティング性能。初期費用なしで必要なときにアプリケーションを起動。 | サーバー構築に必要なハードウェア
[Amazon S3](https://aws.amazon.com/jp/s3/) | どこからでもお好みの量のデータの保存と取得が簡単に行えるオブジェクトストレージ。 S3は、利用するストレージリソースを自由にスケールアップ・ダウンすることができます。| メモリやハードディスクを増設したり、CPUをより上位スペックに交換（スペックアップ）
[Elastic Load Balancing(Network Load Balancer)](https://aws.amazon.com/jp/elasticloadbalancing/?c=7&pt=11) | Elastic Load Balancing は、アプリケーションへのトラフィックを複数のターゲット (Amazon EC2 インスタンス、コンテナ、IP アドレス、Lambda 関数など) に自動的に分散します。Elastic Load Balancing は、変動するアプリケーショントラフィックの負荷を、1 つのアベイラビリティーゾーンまたは複数のアベイラビリティーゾーンで処理できます。Elastic Load Balancing では、3 種類のロードバランサーが用意されています。これらはすべて、アプリケーションの耐障害性を高めるのに必要な高い可用性、自動スケーリング、堅牢なセキュリティを特徴としています。 | SSL証明書 ロードバランサ
[Amazon Relational Database Service (RDS)](https://aws.amazon.com/jp/rds/) | クラウド上のリレーショナルデータベースのセットアップ、オペレーション、スケールを数回のクリックで実現 | インフラストラクチャをプロビジョニング、データベースソフトウェアのインストールやメンテナンス, RDBMSのインストール, パッチ更新, レプリケーション、リードレプリカの作成
[AWS Lambda](https://aws.amazon.com/jp/lambda/) | サーバーについて検討することなくコードを実行できます。お支払いいただくのは、実際に使用したコンピューティング時間に対する料金のみです。 | サーバーのプロビジョニングや管理
[Amazon CloudWatch](https://aws.amazon.com/jp/cloudtrail/) | ユーザーアクティビティと API 使用状況の追跡 | ネットワーク管理ソフトウェア(ZabbixやNagios、Hinemos) 、スクリプトとcron
[AWS Identity and Access Management (IAM)](https://aws.amazon.com/jp/iam/) | AWS のサービスとリソースへのアクセスを安全に管理。IAM を使用すると、AWS のユーザーとグループを作成および管理し、アクセス権を使用して AWS リソースへのアクセスを許可および拒否できます。 | 
[AWS Certificate Manager](https://aws.amazon.com/jp/certificate-manager/) | パブリックとプライベートの SSL/TLS 証明書を簡単にプロビジョニング、管理、デプロイして、AWS のサービスと内部接続リソースで使用 |  パブリックやプライベートの SSL/TLS 証明書のプロビジョニング
[ネットワーク ACL](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-network-acls.html) | 1 つ以上のサブネットのインバウンドトラフィックとアウトバウンドトラフィックを制御するファイアウォールとして動作する、VPC 用のセキュリティのオプションレイヤー
[VPC のセキュリティグループ](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/VPC_SecurityGroups.html) | インスタンスの仮想ファイアウォールとして機能し、インバウンドトラフィックとアウトバウンドトラフィックをコントロールします。
[Internet Gateway](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/VPC_Internet_Gateway.html) | VPC のインスタンスとインターネットとの間の通信を可能にする VPC コンポーネントであり、冗長性と高い可用性を備えており、水平スケーリングが可能です。 | Gateway
[NAT ゲートウェイ](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-nat-gateway.html) | ネットワークアドレス変換 (NAT) ゲートウェイを使用して、プライベートサブネットのインスタンスからはインターネットや他の AWS サービスに接続できるが、インターネットからはこれらのインスタンスとの接続を開始できないようにすることができます。 | NAT
[カスタマーゲートウェイデバイス](https://docs.aws.amazon.com/ja_jp/vpc/latest/adminguide/Introduction.html) | Amazon VPC VPN 接続では、データセンター (またはネットワーク) を Amazon Virtual Private Cloud (VPC) にリンクします。カスタマーゲートウェイデバイスは、その接続の作業者側のアンカーです。
[Amazon Route 53](https://aws.amazon.com/jp/route53/?c=19&pt=4)| 信頼性が高く、費用効率に優れた方法でエンドユーザーをインターネットアプリケーションにルーティング | ドメイン業者からドメインの購入。DNSサーバーの構築とメンテナンス。
[AWS Cloud Map](https://aws.amazon.com/jp/cloud-map/?c=19&pt=7) | クラウドリソースのサービス検出。アプリケーションの可用性を向上、開発者の生産性を向上。| マッピングサービス
[AWS Transit Gateway](https://aws.amazon.com/jp/transit-gateway/?c=19&pt=10) | Amazon VPC、AWS アカウント、オンプレミスネットワーク間の数千規模の接続を簡単にスケールする | ハブ (複数の Amazon Virtual Private Cloud (Amazon VPC) および Direct Connect や VPN に接続できます。)
[Amazon API Gateway](https://aws.amazon.com/jp/api-gateway/?c=19&pt=2) | 規模に応じた API の作成、維持、保護を行います | Websocket通信の接続を管理するホストとなるサーバ 
[AWS PrivateLink](https://aws.amazon.com/jp/privatelink/?c=19&pt=5) | ネットワークトラフィックを AWS ネットワーク内に限定することで、AWS でホストされるサービスに簡単かつセキュアにアクセスします。 | インターネットゲートウェイ、NATデバイス
[AWS Direct Connect](https://aws.amazon.com/jp/directconnect/?c=19&pt=8) | AWS Direct Connect はプレミスから AWS への専用ネットワーク接続の構築をシンプルにするクラウドサービスソリューションです | IPsec
[Amazon CloudFront](https://aws.amazon.com/jp/cloudfront/?c=19&pt=3) | 高速で安全性が高くプログラム可能なコンテンツ配信ネットワーク (CDN、content delivery network) | CDNサービス
[AWS App Mesh](https://aws.amazon.com/jp/app-mesh/?c=19&pt=6) | すべてのサービスのためのアプリケーションレベルのネットワーキング | ロードバランサー(例：Envoy)を使用したサービスメッシュの通信バス、エッジプロキシ
[AWS Global Accelerator](https://aws.amazon.com/jp/global-accelerator/?c=19&pt=9&blogs-global-accelerator.sort-by=item.additionalFields.createdDate&blogs-global-accelerator.sort-order=desc&aws-global-accelerator-wn.sort-by=item.additionalFields.postDateTime&aws-global-accelerator-wn.sort-order=desc) | AWS グローバルネットワークを使用して、アプリケーションのグローバルな可用性とパフォーマンスを向上させる | ロードバランシング

[Amazon Web Services Japan - slideshare](https://www.slideshare.net/AmazonWebServicesJapan/presentations)
