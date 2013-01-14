# Solution for CodeIQ Q124

## このプロジェクトについて

これは [CodeIQ](http://codeiq.jp/) の次の問題に提出した解答です。

* [挑戦者求む！【言語不問】百聞は一見にしかず by 404 Blog Not Found 小飼 弾│CodeIQ](https://codeiq.jp/ace/kogai_dan/q124)

問題の内容は次のページで見ることができます。

* [第1回　百聞は一見に如かず～文字列処理＋画像処理＝？ ─小飼弾からの挑戦：エンジニアのスキルを試すコードパズル ─この問題，あなたは解けますか？｜gihyo.jp … 技術評論社](http://gihyo.jp/dev/serial/01/codeiq/0001)

出題者による解説は次のページにあります。

* [第5回　小飼弾からの挑戦（第1回）解説編：エンジニアのスキルを試すコードパズル ─この問題，あなたは解けますか？｜gihyo.jp … 技術評論社](http://gihyo.jp/dev/serial/01/codeiq/0005)

このプロジェクトの解答の解説は次のページにあります。

* [CodeIQ: Q124 解説編](http://blog.keshi.org/hogememo/2013/01/14/codeiq-q124-follow-up)

## 解答の説明

解答プログラムは Unixen 環境で動くシェルスクリプトとして作成しました。

PNG 画像の読み書きに [netpbm](http://netpbm.sf.net) を使用しています。その他の使用コマンドは od および printf で、POSIX により定められた用法に限っています。Debian GNU/Linux と OSX Mountain Lion + Homebrew の環境でテストしました。

エンコーダスクリプト `encode.sh` を `decode.sh` と名前を変えるとデコーダスクリプトになります。次のようにリンクを作って使用してください。

    $ ln encode.sh decode.sh
    $ ./encode.sh
    Usage: ./encode.sh plain.txt source.png >embedded.png
    $ ./decode.sh
    Usage: ./decode.sh embedded.png >plain.txt

埋め込みのアルゴリズムは出題サンプルの `embedded.png` と同様にしました。すなわち R/G/B の下位 3/2/3 ビットを利用して各ピクセルに 1 バイトずつ埋め込みます。未使用ピクセルにはすべて 0 を埋め込んでいます。

こちらで用意したテスト用の PNG 画像は次の 2 つです。

* `yaegashi-source.png`
* `yaegashi-embedded.png`

以下は実行例です。

    $ echo '漢字、カタカナ、ひらがなの入ったPNG。' >plain.txt
    $ ./encode.sh plain.txt yaegashi-source.png >yaegashi-embedded.png
    $ ./decode.sh yaegashi-embedded.png
    漢字、カタカナ、ひらがなの入ったPNG。

    $ ./decode.sh yaegashi-embedded.png
    漢字、カタカナ、ひらがなの入ったPNG。

    $ curl -s http://dl.dropbox.com/u/110505645/CodeIQ/20121129/embedded.png | ./decode.sh -
    漢字、カタカナ、ひらがなの入ったPNG。
