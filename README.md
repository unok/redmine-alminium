Vagrant with Chef Cookbook for Redmine
======================================

概要
----

ALMinium ( http://alminium.github.io/alminium/git.html ) を利用して Redmine の環境を構築する Vagrant ファイルです。操作自体は Chef で記述していますので、その部分のみの利用も可能です。
いくつか plugin を追加しています。詳しくはソースを見てください。

Chefだけ使う場合
---------------

```
% knife solo prepare user@example.com
% vim nodes/example.com.json
{"run_list": ["role[redmine-alminium]"]}
% knife solo cook user@example.com --no-berkshelf
```

GitHub との連携方法
------------------------------

1. リポジトリをミラー
```
cd /var/opt/alminium/git
sudo -u apache  git clone --mirror https://github.com/unok/redmine-alminium.git
```

2. 作ったリポジトリを Redmine のプロジェクトで利用するように登録

3. GitHub で webhook を登録
http://redmine.example.com/github_hook?project_id=my_project&repository_id=my_repo


Bitbucket や GitLab.com 等でもこの方法で行けるんじゃないかと思います。
ただし、プライベートの場合は、apache 用の鍵を作って登録するなどの作業が必要になります。

ライセンス
---------

ALMinium のライセンスに準拠します。


