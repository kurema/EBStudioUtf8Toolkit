# EBStudioUtf8Toolkit
EBStudioにUTF8形式のhtmlを入力するためのツールキット

## 注意！
このツールキットはObsoleteです。EBStudioUtf8ToolkitSharpの方が高速かつ確実です。  
ただし、実行内容はほぼ同等ですし、こちらの方が外字フォントが大きく見やすくなります。

## 使い方
1. このファイルをダウンロードして展開します。
2. Toolkitフォルダ内に変換したいファイルを"main.utf8.html"として配置します。
3. conv.batを実行します。
4. EBStudioで変換します。
詳しくはToolkit/readme.txtを参照。

## 注意
32bit版OSを使っている人はToolkit/read.pl内の
```
$FontDumpWLocation="C:\\Program Files (x86)\\EBStudio\\FontDumpW.exe";
```
を
```
$FontDumpWLocation="C:\\Program Files\\EBStudio\\FontDumpW.exe";
```
に書き換えてください。EBStudioの場所を変更した方も同様です。

## 設定
フォントの設定、外字のサイズ等は"read.pl"や"table2image.ini"から変更できます。

## ライセンス
MITライセンスです。  
自作辞書の作成・ツールキットに添付・改造などご自由にどうぞ。
