# StyleHub — Fashion Store
## CIT211 Mobile Software Development — Setup Guide

---

## Phase 1 Setup (Flutter UI Only — No Firebase)

### Prerequisites
- Flutter SDK 3.x installed → https://docs.flutter.dev/get-started/install
- Android Studio with Android SDK
- A physical Android device **or** Android Emulator (API 21+)

### Steps

```bash
# 1. Create a new Flutter project
flutter create fashion_store
cd fashion_store

# 2. Replace the lib/ folder with the provided lib/ folder
#    (copy all files from flutter_app/lib/ into your project's lib/)

# 3. Replace pubspec.yaml with the provided pubspec.yaml

# 4. Install dependencies
flutter pub get

# 5. Run the app
flutter run
```

That's it! The app runs with **mock data** — no Firebase needed for Phase 1.

---

## Phase 2 Setup (Full Firebase Integration)

### Step 1 — Create a Firebase Project

1. Go to https://console.firebase.google.com
2. Click **Add Project** → name it `fashion-store-cit211`
3. Disable Google Analytics (optional) → **Create Project**

### Step 2 — Enable Firebase Authentication

1. In Firebase Console → **Authentication** → **Get Started**
2. Under **Sign-in method**, enable **Email/Password**
3. Click **Save**

### Step 3 — Create Firestore Database

1. In Firebase Console → **Firestore Database** → **Create Database**
2. Choose **Start in test mode** (for development)
3. Select a region close to you → **Done**

### Step 4 — Set Firestore Security Rules

Go to **Firestore → Rules** and paste:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /cart/{cartItem} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      match /orders/{orderId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Products are public read-only
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // No client writes to products
    }

    // Orders (top-level) — write only
    match /orders/{orderId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null &&
                     request.auth.uid == resource.data.userId;
    }
  }
}
```

### Step 5 — Connect Flutter to Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Connect your app to Firebase
flutterfire configure
# → Select your project: fashion-store-cit211
# → Select platforms: android, ios
# This auto-generates lib/firebase_options.dart
```

### Step 6 — Uncomment Firebase in pubspec.yaml

Open `pubspec.yaml` and uncomment:

```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_storage: ^11.5.6
```

Then run:
```bash
flutter pub get
```

### Step 7 — Uncomment Firebase in main.dart

Open `lib/main.dart` and uncomment:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
```

And in `main()`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Step 8 — Uncomment Firebase in auth_service.dart

Open `lib/services/auth_service.dart`:
- Uncomment all Firebase import lines
- Uncomment all Phase 2 code blocks
- Delete / comment out Phase 1 mock code blocks

### Step 9 — Uncomment Firebase in firestore_service.dart

Open `lib/services/firestore_service.dart`:
- Uncomment all Firebase import lines
- Uncomment all Phase 2 code blocks
- Delete / comment out Phase 1 mock code blocks

### Step 10 — Pre-load Products into Firestore

Products must be seeded into Firestore before they appear in the app.

**Option A — Run the seeder in the app (easiest):**

Add this temporary button to any screen:

```dart
ElevatedButton(
  onPressed: () async {
    final service = FirestoreService();
    await service.seedProducts();
    print('Products seeded!');
  },
  child: const Text('Seed Products'),
)
```

Run the app once, tap the button, then remove it.

**Option B — Firebase Console (manual):**

Go to Firestore Console → `products` collection → Add documents manually.

Each product document needs these fields:
```
id          (string)
name        (string)
description (string)
category    (string)  — "Women" | "Men" | "Kids" | "Accessories"
imageUrl    (string)
price       (number)
originalPrice (number, nullable)
rating      (number)
reviewCount (number)
badge       (string)  — "Sale" | "New" | "Best Seller" | ""
sizes       (array of strings)
```

---

## Firestore Data Structure

```
firestore/
├── products/           ← Pre-loaded product catalogue
│   └── {productId}/
│       ├── name
│       ├── price
│       ├── category
│       ├── imageUrl
│       └── ...
│
├── users/              ← Created on registration
│   └── {userId}/
│       ├── name
│       ├── email
│       ├── phone
│       ├── address
│       ├── cart/       ← Persisted cart items
│       │   └── {cartKey}/
│       └── orders/     ← User's order history
│           └── {orderId}/
│
└── orders/             ← Global orders collection
    └── {orderId}/
        ├── userId
        ├── items[]
        ├── totalAmount
        ├── deliveryAddress{}
        ├── paymentMethod
        ├── status
        └── createdAt
```

---

## Running on a Physical Android Device

```bash
# Enable Developer Options on your phone
# Enable USB Debugging
# Connect via USB

flutter devices          # verify device is detected
flutter run              # runs on the connected device
flutter build apk        # builds release APK
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## Project Structure

```
lib/
├── main.dart                    ← App entry point + routes
├── firebase_options.dart        ← Auto-generated by flutterfire (Phase 2)
├── theme/
│   └── app_theme.dart           ← Colours, typography, button styles
├── models/
│   ├── product_model.dart
│   ├── cart_item_model.dart
│   ├── order_model.dart
│   └── user_model.dart
├── data/
│   └── products_data.dart       ← 18 mock products (Phase 1)
├── services/
│   ├── auth_service.dart        ← Firebase Auth wrapper
│   └── firestore_service.dart   ← Firestore CRUD operations
├── providers/
│   ├── auth_provider.dart       ← Login / Register / Logout state
│   ├── cart_provider.dart       ← Cart items + Firestore sync
│   ├── product_provider.dart    ← Product list, filters, wishlist
│   └── order_provider.dart      ← Place order + order history
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── main/
│   │   └── main_screen.dart     ← Bottom navigation scaffold
│   ├── home/
│   │   └── home_screen.dart     ← Banner, categories, featured
│   ├── shop/
│   │   ├── shop_screen.dart     ← Product grid + filters
│   │   └── product_detail_screen.dart
│   ├── cart/
│   │   └── cart_screen.dart
│   ├── checkout/
│   │   └── checkout_screen.dart
│   ├── orders/
│   │   └── orders_screen.dart
│   └── profile/
│       └── profile_screen.dart
└── widgets/
    ├── product_card.dart
    ├── custom_button.dart
    └── star_rating.dart
```

---

## Screens Summary (Phase 1 ✅ | Phase 2 🔥)

| Screen | Phase 1 | Phase 2 Firebase |
|---|---|---|
| Splash | ✅ Animated logo | — |
| Login | ✅ Mock auth | 🔥 Firebase Auth |
| Register | ✅ Mock auth | 🔥 Firebase Auth |
| Home | ✅ Mock products | 🔥 Firestore products |
| Shop / Product List | ✅ Filter + sort | 🔥 Firestore query |
| Product Detail | ✅ Full UI | 🔥 Firestore product |
| Cart | ✅ In-memory | 🔥 Firestore persisted |
| Checkout | ✅ Full form | 🔥 Saves to Firestore |
| Orders | ✅ In-memory | 🔥 Firestore history |
| Profile | ✅ Edit locally | 🔥 Firestore update |
