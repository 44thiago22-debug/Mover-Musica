#!/bin/bash
set -e

echo "=== 1. Creando carpetas del proyecto Android ==="
mkdir -p app/src/main/java/com/mi_app/movermusica
mkdir -p app/src/main/res/values

echo "=== 2. Moviendo el codigo principal ==="
if [ -f "MainActivity.java" ]; then
  mv MainActivity.java app/src/main/java/com/mi_app/movermusica/MainActivity.java
else
  echo "Error: No se encontro MainActivity.java en la raiz"
  exit 1
fi

echo "=== 3. Creando el Manifiesto de Android ==="
cat << 'EOF' > app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://android.com" package="com.mi_app.movermusica">
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
    <application android:label="Mover Musica" android:theme="@style/Theme.AppCompat.Light.NoActionBar">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

echo "=== 4. Creando Estilos y recursos visuales ==="
echo '<resources><style name="Theme.AppCompat.Light.NoActionBar" parent="Theme.AppCompat.Light"/></resources>' > app/src/main/res/values/styles.xml

echo "=== 5. Creando configuraciones del proyecto (Gradle) ==="
cat << 'EOF' > app/build.gradle
plugins { id 'com.android.application' }
android {
    namespace 'com.mi_app.movermusica'
    compileSdk 34
    defaultConfig { applicationId "com.mi_app.movermusica"; minSdk 21; targetSdk 34; versionCode 1; versionName "1.0" }
}
dependencies { implementation 'androidx.appcompat:appcompat:1.6.1' }
EOF

echo "include ':app'" > settings.gradle

cat << 'EOF' > build.gradle
buildscript {
    repositories { google(); mavenCentral() }
    dependencies { classpath 'com.android.tools.build:gradle:8.2.2' }
}
allprojects { repositories { google(); mavenCentral() } }
EOF

echo "=== 6. Inicializando Gradle oficial ==="
gradle wrapper --gradle-version 8.5
chmod +x gradlew

echo "=== 7. Compilando el APK final ==="
./gradlew assembleDebug

