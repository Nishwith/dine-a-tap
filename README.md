# <img src="assets/images/logo.png" width="45" alt="Dine-A-Tap Logo" align="center"> Dine-A-Tap

A full-stack, cashless smart canteen mobile application built with Flutter. Dine-A-Tap eliminates long cafeteria queues by bridging mobile pre-ordering with an automated, tap-to-retrieve physical hardware kiosk system.

## 📸 Application Previews

<p align="center">
  <img src="assets/UI/1.png" width="250" alt="Dine-A-Tap Screen 1">
  <img src="assets/UI/2.png" width="250" alt="Dine-A-Tap Screen 2">
  <img src="assets/UI/3.png" width="250" alt="Dine-A-Tap Screen 3">
</p>
<p align="center">
  <img src="assets/UI/4.png" width="250" alt="Dine-A-Tap Screen 4">
  <img src="assets/UI/5.png" width="250" alt="Dine-A-Tap Screen 5">
  <img src="assets/UI/6.png" width="250" alt="Dine-A-Tap Screen 6">
</p>
<p align="center">
  <img src="assets/UI/7.png" width="250" alt="Dine-A-Tap Screen 7">
  <img src="assets/UI/8.png" width="250" alt="Dine-A-Tap Screen 8">
  <img src="assets/UI/9.png" width="250" alt="Dine-A-Tap Screen 9">
</p>

## 🚀 Key Features

* **Dynamic Pre-Booking System:** Real-time menu fetching and complex cart state management utilizing custom RESTful APIs.
* **Integrated Digital Wallet:** Secure, in-app wallet system with real-time balance verification, powered by **Razorpay** and **Cashfree** SDKs.
* **Firebase Ecosystem:** * Secure user onboarding via **Firebase Auth**.
  * Real-time background and foreground order alerts using **Firebase Cloud Messaging (FCM)**.
  * User engagement tracking via **Firebase Analytics**.
* **Seamless OTA Updates:** Integrated `in_app_update` for flexible, over-the-air feature pushes and bug fixes.
* **Modern UI/UX:** Highly responsive design using advanced Flutter widgets like `CustomScrollView`, `SliverAppBar`, and `CarouselSlider`.

## 🛠️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Firebase, Custom REST API
* **Payment Gateways:** Razorpay, Cashfree

## ⚙️ Setup & Installation

1. Clone the repository.
2. Ensure you have the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files in their respective directories.
3. Create a `.env` file in the root directory and add your API credentials.
4. Run `flutter pub get` to install dependencies.
5. Run `flutter run` to build the application.
