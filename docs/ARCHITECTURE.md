# Growlのアーキテクチャについて
Growlのios版アプリでは設計パターンとしてMVVMとクリーンアーキテクチャを採用して開発を行います。ここではios版アプリにおけるアーキテクチャレイヤに関する定義を記述します。

## Domain層
DomainレイヤではGrowlのドメインから抽出されたエンティティおよび値オブジェクトが定義されており、次のような構成になっています。

- Entities
- ValueObjects
- ReposioryProtocols

## Presentation層
PrsentationレイヤではGrowlのUIに関するレンダリング処理、および状態管理の制御などUI固有のルールをカプセル化しています。

- Drivers: UiKit固有のロジック、遷移制御、Window管理、ライフサイクルをカプセル化
- ViewModels: アプリケーション固有の純粋なロジック、状態管理をカプセル化
- Views: アプリケーションの宣言的なUIをカプセル化

## UseCase層
UseCaseレイヤでは、エンティティや値オブジェクトにまつわるアプリケーション固有のロジックに関する詳細が定義されます。

## Infrastructure層
Infrastructureレイヤでは、外部サービス（AWS、DBなど）関連のロジックを担当します。

- ExternalServices
- Repository
- Schema
