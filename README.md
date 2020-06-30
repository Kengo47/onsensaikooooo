# OnSeeeeen!
あなたの好きな温泉を、ちょこっと思い出とともに誰かと共有するアプリです。

![onseeeeen_capture](https://user-images.githubusercontent.com/64575727/86012132-93eea380-ba58-11ea-927a-0ed81766779a.jpg)

## URL
https://onseeeeen.com/

## 概要
- 非ログイン状態の場合は投稿の閲覧、検索、人気投稿閲覧のみ可能です。ログインすると実際の投稿やコメントが可能になります。<br>
- ログイン画面の「かんたんログイン」をクリックすると、メールアドレスとパスワードを入力せずに、ゲストユーザーとしてログインすることができます。<br>
- メールアドレス"`admin@example.com`"、パスワード"`123456`"で【管理者ユーザー】としてログインできます。<br>
- 【管理者ユーザー】は、他の一般ユーザーのアカウントや投稿、コメントを削除することが可能です。<br>
- レスポンシブ対応しているので、スマホからでもご覧いただけます。

## 使用技術
- Ruby 2.6.6, Rails 5.2.4.2
- HTML (haml), Scss, Bootstrap4, JavaScript, jQuery
- Docker, Docker-compose
- Nginx, Puma
- AWS (VPC, EC2, RDS for MySQL, S3, CloudFront, SES, Route53, ACM, ELB)
- Circle CI/CD(Capistrano3)
- RSpec
- GoogleMapsAPI

## AWS構成図
![AWS_stracture](https://user-images.githubusercontent.com/64575727/86011966-55f17f80-ba58-11ea-821c-1a03b0bd050e.jpg)

## 機能一覧
- ユーザー機能
  - devise
  - 新規登録、ログイン、ログアウト機能
  - マイページ、登録情報編集機能
- 投稿関係
  - 投稿一覧表示、投稿詳細表示、新規投稿、投稿編集、投稿削除機能
  - 画像のアップロードはcarrierwaveを使用
  - 投稿の名前からgeocodingによる緯度経度取得、GoogleMapsAPIで表示
  - 全ての投稿の位置をマーカーで表示するマップ機能
  - 投稿（都道府県）の割合をグラフで表示
  - 不適切用語フィルターを使用（antivirus）
- 現在位置取得機能
- コメント関係
  - コメント表示、コメント投稿、コメント削除機能
- ページネーション機能
  - (kaminari + Infinite Scroll)を使用
- お気に入り機能
  - お気に入りされた投稿の、人気順表示機能
  - Ajaxを使用
- フォロー機能
  - フォロー、フォロワー一覧表示機能
  - Ajaxを使用
- 検索機能
  - 投稿を複数の検索条件を指定可能
  - ユーザーを名前で検索機能
- 管理ユーザー機能
  - ユーザー一覧の表示、一般ユーザーのアカウントや投稿、コメントを削除可能
- RSpecによる自動テスト機能
  - 単体spec
  - システムspec
- その他
  - SelectBoxの中身を動的に変更する機能
    - 都道府県SelectBoxに対する市区町村SelectBoxをAjaxで動的に制御

## ER図
![onseeeeen-er](https://user-images.githubusercontent.com/64575727/86100279-97833880-baf3-11ea-8921-741787da708b.jpg)
