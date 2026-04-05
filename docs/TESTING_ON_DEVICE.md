# Testing the Flutter Web App on a Real Phone or Android Simulator

This guide walks you through two methods to test the Yellow Loan Signup Flutter web app on a mobile device — using either a **real phone** or an **Android emulator**. No Docker or advanced mobile setup is required.

---

## Prerequisites

Make sure you have completed the project setup described in the main [README](../README.md) and the [Flutter app README](../frontend/yellow_loan_signup_flutter_app/README.md) before continuing.

- Flutter SDK ≥ 3.x installed and on your `PATH`
- Run `flutter doctor` and confirm there are no critical errors
- Dependencies installed:
  ```bash
  cd frontend/yellow_loan_signup_flutter_app
  flutter pub get
  ```

---

## Method 1 — Real Phone (via Local Network)

This is the quickest way to preview the app on a physical device. Your phone opens the app in its own browser — no app installation needed.

### Step 1 — Connect to the same Wi-Fi

Both your development computer and your phone must be on the **same Wi-Fi network**. Mobile data or hotspot sharing will not work with this method.

### Step 2 — Start the Flutter web server

Open a terminal, navigate to the Flutter app folder, and run:

```bash
cd frontend/yellow_loan_signup_flutter_app

flutter run \
  --flavor development \
  --target lib/main_development.dart \
  -d web-server \
  --web-hostname 0.0.0.0 \
  --web-port 8000
```

- `--web-hostname 0.0.0.0` makes the server reachable on all network interfaces (not just `localhost`).
- `--web-port 8000` sets the port — you can change this if 8000 is already in use.

Wait for the terminal to print `Serving at http://0.0.0.0:8000` (or similar) before continuing.

### Step 3 — Find your computer's local IP address

Run one of the following depending on your operating system:

| OS | Command |
|----|---------|
| macOS / Linux | `ifconfig \| grep "inet " \| grep -v 127.0.0.1` |
| Windows (PowerShell) | `ipconfig` (look for **IPv4 Address** under your Wi-Fi adapter) |

Your local IP will look something like `192.168.1.42`.

### Step 4 — Open the app on your phone

On your phone, open any browser (Chrome, Safari, Firefox) and navigate to:

```
http://<your-computer-ip>:8000
```

Example: `http://192.168.1.42:8000`

The Yellow Loan Signup app should load in the browser.

### Tips

- If the page does not load, check your computer's firewall and ensure port 8000 is allowed for inbound connections.
- On macOS, go to **System Settings → Firewall → Options** and allow incoming connections for the app if prompted.
- If your router uses **AP isolation** (common in public/hotel Wi-Fi), devices on the same network cannot talk to each other — switch to your home Wi-Fi or use a personal hotspot.
- Hot reload works: press `r` in the terminal where Flutter is running to reload after a code change, or `R` for a full restart.

---

## Method 2 — Android Emulator

You can run the app either as a **web app inside the emulator's browser** (simplest) or as a **native Android app** (closest to a real install).

### Option A — Web app inside the emulator browser

This mirrors Method 1 but uses the emulator instead of a physical phone.

#### Step 1 — Install and start an Android emulator

1. Install [Android Studio](https://developer.android.com/studio) if you haven't already.
2. Open Android Studio → **Virtual Device Manager** (the phone icon in the toolbar).
3. Click **Create device**, choose a phone profile (e.g. Pixel 6), select a system image (API 33 or higher recommended), and click **Finish**.
4. Press the ▶ (Play) button next to your new emulator to launch it, or from the terminal:
   ```bash
   flutter emulators
   # Lists available emulators, e.g. "Pixel_6_API_33"
   flutter emulators --launch Pixel_6_API_33
   ```

#### Step 2 — Start the Flutter web server on your computer

```bash
cd frontend/yellow_loan_signup_flutter_app

flutter run \
  --flavor development \
  --target lib/main_development.dart \
  -d web-server \
  --web-hostname 0.0.0.0 \
  --web-port 8000
```

#### Step 3 — Open the app in the emulator browser

Inside the running Android emulator, open **Chrome** and navigate to:

```
http://10.0.2.2:8000
```

> **Why `10.0.2.2`?**  
> Android emulators map `10.0.2.2` to your development computer's `localhost`. This is the standard address for reaching host-machine services from inside an emulator.

---

### Option B — Native Android app (run directly on emulator)

This installs and runs the Flutter app natively on the emulator — useful for testing platform-specific behaviour, file pickers, and camera/image functionality.

#### Step 1 — Ensure an emulator is running

Follow Step 1 from Option A above to launch an emulator, then verify Flutter detects it:

```bash
flutter devices
# You should see your emulator listed, e.g.:
# sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 13 (API 33)
```

#### Step 2 — Run the app on the emulator

```bash
cd frontend/yellow_loan_signup_flutter_app

flutter run \
  --flavor development \
  --target lib/main_development.dart \
  -d emulator-5554
```

Replace `emulator-5554` with the device ID shown by `flutter devices`.

Flutter will compile and install the app, then launch it automatically on the emulator.

#### Step 3 — Use hot reload

While the app is running, press `r` in the terminal to hot reload after code changes, or `R` for a full restart.

---

## Useful Flutter Commands

| Command | What it does |
|---------|-------------|
| `flutter devices` | Lists all connected devices and emulators |
| `flutter emulators` | Lists available Android Virtual Devices |
| `flutter emulators --launch <id>` | Launches a specific emulator |
| `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8000` | Serves the web app on all interfaces |
| `flutter run -d <device-id>` | Runs the app on a specific device |
| `flutter doctor` | Checks your Flutter installation for issues |
| `flutter clean` | Clears cached build artifacts (fixes many odd build errors) |
| `flutter pub get` | Fetches/refreshes dependencies |

---

## Troubleshooting

### The app loads but shows a blank white screen

- Wait a few seconds — the initial JS bundle can take a moment to load, especially on first run.
- Open the browser developer tools (if on desktop) or check the terminal output for errors.
- Try a hard refresh: long-press the refresh icon in Chrome and choose **Empty Cache and Hard Reload**.

### `flutter run` fails with "No supported devices connected"

- Make sure an emulator is running (`flutter emulators --launch <id>`) **before** running `flutter run`.
- For web-server mode, no device needs to be connected — the `-d web-server` flag is self-contained.
- Run `flutter devices` to see what Flutter can detect.

### Port 8000 is already in use

```bash
# On macOS/Linux, find what is using the port:
lsof -i :8000
# Then kill it by PID, e.g.:
kill 12345

# Or simply choose a different port:
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### My phone can't connect to the web server

1. Confirm both devices are on the same Wi-Fi network.
2. Verify the IP address is correct — run `ifconfig` or `ipconfig` again.
3. Temporarily disable your computer's firewall and retry.
4. Check that the Flutter server is still running in your terminal (it will say `Serving at http://0.0.0.0:8000`).

### The file upload / image picker doesn't work on the emulator web browser

File picking via the browser on an Android emulator can be limited. For full file picker testing, use **Option B (native Android app)** instead.

### `Gradle` or Android build errors on first run

```bash
cd frontend/yellow_loan_signup_flutter_app
flutter clean
flutter pub get
flutter run --flavor development --target lib/main_development.dart -d emulator-5554
```

If the error mentions a missing Android SDK component, open Android Studio → **SDK Manager** and install the missing SDK platform or build tools.

---

## Summary

| Goal | Method | Command |
|------|--------|---------|
| Quick test on your own phone | Real phone via Wi-Fi | `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8000`, then open `http://<your-ip>:8000` on the phone |
| Test in Android emulator browser | Emulator web (Option A) | Same command, then open `http://10.0.2.2:8000` in the emulator browser |
| Test as a native Android app | Emulator native (Option B) | `flutter run --flavor development --target lib/main_development.dart -d <emulator-id>` |
