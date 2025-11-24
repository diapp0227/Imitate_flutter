
![](https://img.shields.io/badge/2024.3.2-FF4c4c?&label=AndroidStudio)
![](https://img.shields.io/badge/15.3-4cFFFF?&label=Xcode)

# 各プロジェクト説明

<pre>
.
└── project
    ├── Flutter (1)
    ├── Android (2)
    └── iOS (3)
</pre>

## (1)Flutter
各プロジェクトに取り込んで実装するフレークワークのプロジェクト

### 開き方
* AndroidStudioでproject/Flutter階層をルートにopenする

### ビルド方法
project/Flutterの階層で以下のコマンドを実行すると、フレームワークをビルドできる
  * 【Android】flutter build aar
  * 【iOS】flutter build ios-framework

## (2)Android
Androidプロジェクト

### 開き方
* AndroidStudioでproject/Android階層をルートにopenする
* local.propertiesはgit追加してないので、local.propertiesに「sdk.dir(AndroidSDKを配置箇所)」と「flutter.sdk(flutterのsdk)」を記述必要

  ```kotlin:local.properties
    sdk.dir=【任意】/Android/sdk
    flutter.sdk=【任意】/flutter
  ```

### フレームワーク取り込み方

* 以下コードの記述でproject/Flutter階層に存在するフレームワークを取り込んでいる (gitに反映済み)

  ```kotlin:settings.gradle.kts
    maven("../Flutter/build/host/outputs/repo")
  ```
  
  ```kotlin:build.gradle.kts
    implementation ("com.example.imitate_flutter:flutter_debug:1.0")
  ```

## (3)iOS
iOSプロジェクト

### 開き方
* Xcodeでproject/iOS/imitate.xcodeprojを開く

### フレームワーク取り込み方

* Frameworksディレクトリ階層に「App.xcframework」「Flutter.xcframework」をXcode上でドラッグドロップ(gitに反映済み)

