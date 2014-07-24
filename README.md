Vagrant with Chef Cookbook for Redmine
======================================

Overview
--------

ALMinium を利用して Redmine の環境を構築する Vagrant ファイルです。操作自体は Chef で記述していますので、その部分のみの利用も可能です。
いくつか plugin を追加しています。詳しくはソースを見てください。

Use Chef Only
-------------

```
% knife solo prepare user@example.com
% vim nodes/example.com.json
{"run_list": ["role[redmine-alminium]"]}
% knife solo cook user@example.com --no-berkshelf
```


License
-------

ライセンスは、ALMinium のライセンスに準拠します。


