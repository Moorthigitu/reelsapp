# 🎬 Reels App - Flutter Short Video Feed

A production-grade, highly optimized Reels-style short-video application built with **Flutter**, featuring smooth vertical scrolling through 50 reels, intelligent video preloading, automated lifecycle memory management, double-tap heart animations, comments bottom sheet, and local storage persistence.

---

## ✨ Features

- **50 Vertically Scrollable Reels**: Fast, responsive vertical `PageView` feed displaying 50 reel items with 12 empirically verified HTTP 200 public video URLs.
- **Smart Dio Preloading & Caching Strategy**: Uses `Dio` package via `VideoDownloadService` to pre-download upcoming reels in the background to local disk cache (`/reels_cache/`) for lag-free playback.
- **Efficient Memory Management**: Does **NOT** load all 50 videos simultaneously. Active controller window (`[currentIndex - 1, currentIndex + 2]`) is maintained, and distant video controllers are automatically paused, disposed, and removed from memory.
- **Seamless Loading UI**: No intrusive "Loading Reel..." text screens. Immediate creator info overlay (handle, caption, like/comment/share buttons) rendering for instantaneous feel.
- **Like & Double-Tap Heart Animation**: Tap the heart button or double-tap anywhere on the video screen to trigger a scaling heart burst animation and update like counts.
- **Interactive Comments Bottom Sheet**: Glassmorphic dark modal bottom sheet to view existing comments, like comments, and post new comments in real-time.
- **Persistent Local Storage**: Saves all Like states, updated like counts, and newly added comments using `SharedPreferences`. States remain intact even after full application restart.

---

## 🏗️ Architecture & Project Structure

```text
lib/
├── models/
│   ├── reel_model.dart          # Data model for Reel items, likes, and comments
│   └── comment_model.dart       # Data model for comments & comment likes
├── services/
│   ├── storage_service.dart     # SharedPreferences persistence layer
│   ├── video_download_service.dart # Dio background pre-downloader and disk cacher
│   └── reel_data_provider.dart  # Data source providing 50 reels with 12 verified HTTP 200 video URLs
├── views/
│   ├── reels_feed_screen.dart   # Main vertical feed screen managing controller lifecycle & Dio preloading
│   └── widgets/
│       ├── reel_player_widget.dart     # Video player view, gestures & overlays
│       ├── reel_right_sidebar.dart     # Action buttons (Like, Comment, Share, Spinning Disc)
│       ├── reel_bottom_info.dart       # Creator handle, caption expander & audio ticker
│       ├── comments_bottom_sheet.dart  # Modal bottom sheet for viewing & posting comments
│       └── heart_animation_widget.dart # Double-tap heart pop animation
└── main.dart                     # App entry point, system overlays & theme configuration
```

---

## ⚡ Video Preloading & Lifecycle Strategy

1. **Active Window Management**:
   The feed maintains an active window around the visible index `N`:
   - `N` (Current Reel): Playing (`play()`), looping, audio enabled.
   - `N + 1` & `N + 2` (Next Reels): Initialized and paused in background buffer (`initialize()`, `pause()`).
   - `N - 1` (Previous Reel): Retained briefly for instant back-scrolling.

2. **Controller Disposal**:
   Any controller at index `< N - 1` or `> N + 2` is immediately paused, disposed (`controller.dispose()`), and purged from memory. This guarantees that **at most 3–4 video controllers exist in RAM** regardless of how far down the 50-reel list the user scrolls.

---

## 💾 Local Storage & Persistence

`StorageService` leverages `shared_preferences` to persist state across app launches:
- `reel_liked_<id>`: Boolean flag for user's like state.
- `reel_like_count_<id>`: Total like count.
- `reel_comments_<id>`: Serialized JSON array of comments.

Upon app initialization, `StorageService.applySavedStates()` automatically merges saved storage states into the 50 reels dataset.

---

## 🚀 Setup & Execution Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.19.0 or higher)
- Android Studio / VS Code with Flutter extension
- Connected Android Device, Emulator, or Windows/Web runner

### Steps

1. **Clone the Repository**:
   ```bash
   git clone <YOUR_GITHUB_REPO_URL>
   cd reelsapp
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Code Analysis**:
   ```bash
   flutter analyze
   ```

4. **Run Application**:
   ```bash
   flutter run
   ```

5. **Generate Testing APK**:
   ```bash
   # Release APK
   flutter build apk --release

   # Debug APK
   flutter build apk --debug
   ```
   *The generated APK will be available at:* `build/app/outputs/flutter-apk/app-release.apk` (or `app-debug.apk`).


