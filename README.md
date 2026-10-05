# Syncplay

Syncplay is a Flutter music app that lets people create or join shared listening rooms and keep playback in sync across connected devices using Firebase Firestore.

## Features

- Search and filter songs by title or artist
- Mark favorites and focus on favorites-only playback
- Create a listening room or join an existing one
- Sync the active track, playback state, and current position in real time
- Control playback from the shared room, including seeking through the current track

## Tech stack

- Flutter / Dart
- Firebase Firestore for room state synchronization
- audioplayers for playback
- audio_metadata_reader for track metadata extraction
- Material Design UI

## Project structure

```text
lib/
├── data/                     # audio asset metadata and sample data
├── logic/                    # room state, playback synchronization, media helpers
├── pages/                    # app pages and room flow
├── widgets/                  # UI components such as music cards and room controls
├── firebase_options.dart     # Firebase configuration for the current platform
├── main.dart                 # app entry point
assets/
├── audios/                   # bundled audio tracks
```

## Prerequisites

- Flutter SDK (compatible with the version in `pubspec.yaml`)
- Firebase project configured for your platform
- Android emulator or a physical device for running the app

## Getting started

1. Install dependencies:

```bash
flutter pub get
```

2. Configure Firebase for the project if it has not already been set up:

```bash
flutterfire configure
```

3. Start the Firestore emulator for local development (optional but recommended):

```bash
firebase emulators:start --only firestore
```

4. Run the app:

```bash
flutter run
```

## Local development notes

The app automatically configures the Firestore emulator in debug mode using `10.0.2.2:8080`, which is the standard host used by Android emulators to reach the machine running the emulator.

## Download APK

Download the latest APK here:

- [Syncplay APK](https://drive.google.com/file/d/17KcP8j72KIK66gP768Q3pQ8LDe8ybwOV/view?usp=sharing)

## Demo Video

Watch the project demo here:

- [Demo Video](https://drive.google.com/file/d/1aXGw6-tHXNmdWazRUq5ttgK8vZTiYnvb/view?usp=sharing)

## License

This project is licensed under the MIT License.

MIT License

Copyright (c) 2026 Syncplay

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
