1. 文字コードがUTF8でEBStudio形式のHTMLをこのフォルダにmain.utf8.htmlとして配置します。
2. コマンドプロンプトからconv.batを実行します。
3. しばらくすると多数のファイルが出力されます。以下のようになっているはずです。

C:.
│  conv.bat
│  createGaiji.bat
│  Gaiji.xml
│  Gaiji16x16.xml
│  Gaiji16x24.xml
│  Gaiji24x24.xml
│  Gaiji24x48.xml
│  Gaiji48x48.xml
│  Gaiji8x16.xml
│  GaijiMap.xml
│  main.html
│  main.utf8.html
│  main.img.html
│  read.pl
│  table.pl
│  table2image.exe
│  table2image.ini
│  
├─imgt
│      0.jpeg
│      ...多数のファイル
│      
└─table
        0.html
        ...多数のファイル

   EBStudioを開き、変換を行います。
   表を画像化する場合は"main.img.html"、そうしない場合は"main.html"を入力ファイルに追加してください。
   また外字フォントに"Gaiji.xml",外字定義に"GaijiMap.xml"を設定して変換しましょう。
4. なお"table2image.exe"が一部のファイルの変換を失敗する事があります。その場合は手作業で修正するか(画像の作成・"main.img.html"内の該当imgタグをテーブルに戻す)、"main.html"をお使いください。
