# Firebase (iOS) — `GoogleService-Info.plist`

The app uses **Firebase Core** + **Cloud Messaging** for push. The iOS build succeeds without this file, but **`Firebase.initializeApp()` will fail at runtime** until the app is registered in Firebase and the plist is present.

## Option A — FlutterFire (recommended)

From `apps/public-mobile`:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and wires iOS/Android. Then in `main.dart`, use:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

(Adjust imports if you adopt this; keep `GoogleService-Info.plist` in `ios/Runner/` as created by FlutterFire.)

## Option B — Manual plist

1. [Firebase Console](https://console.firebase.google.com) → your project → Project settings → Your apps → iOS.
2. Download **GoogleService-Info.plist**.
3. Place it in **`ios/Runner/GoogleService-Info.plist`**.
4. Open `ios/Runner.xcworkspace` in Xcode and confirm the file is in the **Runner** target (copy if needed).

## v1 repo (`zoea`)

The older app at `~/projects/flutter/zoea` does **not** ship a plist in git; it loaded Firebase-related keys from **remote config** (`ConfigService` / `ApiKeyManager`). There is nothing to copy from v1 for a standard FlutterFire setup—you need the plist or `firebase_options.dart` from **your** Firebase project.
