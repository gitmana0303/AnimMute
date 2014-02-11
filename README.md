AnimMute
=============================================================================================

maxscript : animation mute tool

　MayaのMute機能のように位置・回転・スケールアニメーションをON/OFF出来るようにするツールです。  
　選択オブジェクトのコントローラをリスト化してウェイトを切り替えます。

![Screenshot](/screenshots/ss_mute_off.png "mute off")
![Screenshot](/screenshots/ss_mute_on.png "mute on")


Installation
---------------------------------------------------------------------------------------------
　AnimMuteフォルダをuserscriptsフォルダへまるごとコピーして下さい。  
　srcフォルダにあるAnimMute.msをビューポートにドラッグ＆ドロップするとマクロが生成されます。  
  
　userscriptsフォルダは下記のコードで表示される場所です。
```bash
getdir #userscripts
```

Note
---------------------------------------------------------------------------------------------
* PRSコントローラのオブジェクトのみセットアップ可能
* XYZ個別Muteには対応してません
* Mute実行時のTransformは維持しません
