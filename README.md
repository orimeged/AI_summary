# AI Summary App

## What’s This?

**AI_summary** is a Flutter app I built to:
- Record audio
- Summarize it using AI
- Let users ask questions about the summary or recording

It’s useful for lessons, meetings, or speeches, and was created as a way to practice Flutter and AI technologies.

---

## What It Does

- **Records Audio**  
  Teachers can record lessons, meetings, or speeches.

- **Summarizes Content**  
  Uses AI to generate a summary of the recording.

- **Chat Feature**  
  Allows users to ask questions about the summary or the original recording.

- **User Roles**  
  Different screens and permissions for teachers (admin) and students.

- **History**  
  Placeholder screen to view past recordings (not fully implemented yet).

---

## What You Need

### Software

- Flutter SDK (version 3.0 or later)
- Dart (comes with Flutter)
- Firebase account for Firestore and authentication
- Gemini API key for AI summarization and chat

### Hardware

- Android or iOS device/emulator for testing
- Microphone for recording

### Dependencies (in `pubspec.yaml`)

- `flutter`
- `cloud_firestore`
- `speech_to_text`
- `permission_handler`
- `flutter_gemini`

---

## How to Set It Up

1. Clone or download the project folder.
2. Install Flutter from [flutter.dev](https://flutter.dev).
3. Open the project in VS Code or Android Studio.
4. Add your Firebase configuration:
   - Set up a Firestore database.
   - Add `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) to the project.
5. Add your Gemini API key in the code (`recording_screen.dart` and `chat_screen.dart`).
6. Run `flutter pub get` to install dependencies.
7. Connect a device or emulator and run `flutter run`.

---

## How to Use It

### Register/Login

- Open the app and register with a username and password.
- Log in using your credentials (use password `admin` for teacher mode).

### Teacher Mode

- Navigate to the recording screen, select a type (e.g., lesson, meeting), and start recording.
- Stop recording to receive an AI-generated summary.
- Use the chat screen to ask questions or share the summary.

### Student Mode

- Use the chat screen to ask questions about the summary.
- View the history screen (still under development).

### Logout

- Press the logout button in the app bar.

---

## Important Notes

- You must allow microphone permissions to record audio.
- Ensure Firebase and Gemini API are set up correctly.
- The history screen is currently a placeholder.
- Use the app for legitimate purposes like studying or teaching.

---

## If It Doesn’t Work

- **App Crashes**: Check the Flutter console for errors (common issues include Firebase or Gemini setup).
- **Recording Fails**: Ensure microphone permissions are granted.
- **No Summary/Chat Response**: Check your Gemini API key and internet connection.
- **Login**
