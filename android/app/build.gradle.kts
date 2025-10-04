plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Add the Google services Gradle plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.the_track_fit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
        freeCompilerArgs += listOf("-Xjvm-default=all")
    }

    signingConfigs {
        create("release") {
            storeFile = file("KeyOfApp.jks")
            storePassword = "M0H@MeDFARES"
            keyAlias = "moka"
            keyPassword = "M0H@MeDFARES"
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.the_track_fit"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use the release signing config with KeyOfApp.jks
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    
    // Add Firebase Authentication
    implementation("com.google.firebase:firebase-auth")
    
    // Add Firebase Analytics (optional but recommended)
    implementation("com.google.firebase:firebase-analytics")
    
    // Add other Firebase products as needed
    // https://firebase.google.com/docs/android/setup#available-libraries
}
// Certificate fingerprints:
//      SHA1: EB:43:93:E0:C9:30:7D:08:EA:45:A4:D9:D9:52:CD:57:3C:37:B4:96
//      SHA256: 00:EE:D4:92:80:5C:C1:D8:B3:4A:EA:46:5A:6D:95:C5:79:BD:08:E2:AE:4B:17:4E:C2:F9:BD:D0:5E:F3:C5:C7