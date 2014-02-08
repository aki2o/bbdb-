これは何？
==========

BBDBのレコード検索/選択を、より簡単かつ直感的に行えるインタフェースを提供するEmacsの拡張です。  

BBDBはGnus/WanderlustなどのMUAで使えるアドレス帳です。  
http://savannah.nongnu.org/projects/bbdb


デモ
====

![demo](image/demo.gif)


特徴
====

### インクリメンタルな絞込み

anything.el/helm.elのように、インクリメンタルにマッチしたレコードを絞り込んでいきます。  
migemo.elが利用可能になっていれば、migemo検索ができます。  

### To/Cc/Bccを任意に選択できる

表示されているレコードに対して、一括/個別にTo/Cc/Bccを指定/指定解除することができます。  
指定されたレコードの左端列には、以下のようにマークが表示されます。  

* T ... To
* C ... Cc
* B ... Bcc


インストール
============

### package.elを使う場合

2014/02/01 melpaリポジトリからインストール可能  

### el-get.elを使う場合

2014/02/02 利用可能。ただし、masterブランチのみです。  

### auto-install.elを使う場合

```lisp
(auto-install-from-url "https://raw.github.com/aki2o/bbdb-/master/bbdb-.el")
```

※ 下記の依存拡張もそれぞれインストールする必要があります。  

### 手動の場合

bbdb-.elをダウンロードし、load-pathの通った場所に配置して下さい。  

※ 下記の依存拡張もそれぞれインストールする必要があります。  

### 依存拡張

* [bbdb.el](http://savannah.nongnu.org/projects/bbdb)
* [log4e.el](https://github.com/aki2o/log4e)
* [yaxception.el](https://github.com/aki2o/yaxception)

#### bbdb.elについて

package.elでmelpaに登録されているものを対象としています。  
bbdb.elはいろいろな所から入手できるようですが、  
設定項目が変わっていたりするので、それ以外のものは動作するか不明です。  


設定
====

```lisp
(require 'bbdb-)

;; 必要に応じて適宜カスタマイズして下さい。以下のS式を評価することで項目についての情報が得られます。
;; (customize-group "bbdb-")

;; セットアップ実行
(bbdb-:setup)
```


使い方
======

### 起動

`bbdb-:open`または、`bbdb-:start-completion`です。  
メール作成バッファでは`bbdb-:start-completion`を使う方が良いです。  
デフォルトで、`bbdb-complete-mail`に割り当てられたキーで`bbdb-:start-completion`が実行できます。  
または、`bbdb-:start-completion-key`という設定項目もあります。  
それらが気に入らなければ、別途適宜キーバインドして下さい。  

### キーバインド

起動によって表示される\*bbdb-\*バッファには以下のキーバインドが定義されています。  

* **j** ... 次のレコードへ
* **k** ... 前のレコードへ
* **h** ... 前の文字へ
* **l** ... 次の文字へ
* **J** ... 1画面分スクロールダウン
* **K** ... 1画面分スクロールアップ
* **s** ... インクリメンタル検索開始
* **S** ... migemo使用について、逆の設定でインクリメンタル検索開始
* **a** ... 全レコード再表示
* **t** ... ポイントしているレコードをToに指定
* **c** ... ポイントしているレコードをCcに指定
* **b** ... ポイントしているレコードをBccに指定
* **u** ... ポイントしているレコードのTo/Cc/Bccの指定を解除
* __\* t__ ... 表示されている全レコードをToに指定
* __\* c__ ... 表示されている全レコードをCcに指定
* __\* b__ ... 表示されている全レコードをBccに指定
* __\* u__ ... 表示されている全レコードのTo/Cc/Bccの指定を解除
* **R** ... 再起動(BBDBの最新内容を取り込む)
* **q** ... 終了
* **RET** ... 完了(必要ならメール作成バッファを開き、To/Cc/Bccの指定を反映)


留意事項
========

### BBDBのレコードを変更したら

\*bbdb-\*バッファは一度生成されると、終了してもバッファはそのままで再利用されます。  
そのため、\*BBDB\*バッファ(M-x`bbdb`で生成される)でレコードを追加/変更/削除した場合は、
再起動して下さい。


動作確認
========

* Emacs ... GNU Emacs 24.2.1 (i386-mingw-nt5.1.2600) of 2012-12-08 on GNUPACK
* bbdb.el ... 20140123.1541
* log4e.el ... 0.2.0
* yaxception.el ... 0.1


**Enjoy!!!**

