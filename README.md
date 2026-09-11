# 🚀 Clarity — Cross-Platform Flutter Task & Productivity App

A modern, production-ready, full-featured personal and team productivity suite built with **Flutter (Dart 3)** and **Material 3**. 

Designed to be opened, edited, and run seamlessly inside **Visual Studio Code** (or Android Studio) across **Web (Chrome)**, **Windows Desktop**, and **Android**.

---

## 🌟 What's New & Converted

This app was originally a prototype and has been completely converted into a **true Flutter & Dart codebase** with:
- **Zero demo hardcoding**: Real-life authentication workflows with blank, user-friendly input fields.
- **Offline-ready persistence**: Full state and data persistence using `shared_preferences` and reactive `Provider` state architecture.
- **Full Task Lifecycle**: Add, edit, search, filter, complete, AI formatting, and delete with confirmation.
- **Interactive Calendar Schedule**: Dynamic week strip with week pagination (`<` and `>`), date selection, and timeline.
- **Daily Momentum Streak**: Real-time streak badge, progress bar, 7-day circular tracker, and completion stats.
- **Lists & Categories Hub**: Workspaces for Work, Personal, Urgent, and Tech with real-time progress.
- **Settings & Profile**: Profile editing modal, dark/light theme switching, and persistent preference toggles.

---

## 💻 How to Run in VS Code

### Prerequisites
1. **VS Code** installed on your system.
2. Flutter extension installed in VS Code (`Flutter` & `Dart` by Dart Code).
3. Flutter SDK installed (already installed on your machine at `D:\src\flutter\bin\flutter`).

### Step-by-Step Instructions

1. **Open the Project in VS Code**:
   - Launch VS Code.
   - Click **File** > **Open Folder...** (or press `Ctrl + K, Ctrl + O`).
   - Select the folder: `D:\flutter app`.

2. **Run on Chrome (Fastest & Recommended)**:
   - In VS Code, open the built-in terminal (`Ctrl + \`` or `Terminal` > `New Terminal`).
   - Run:
     ```bash
     flutter run -d chrome
     ```
   - Chrome will launch with the Clarity web application running with hot reload!

3. **Run via VS Code Debugger (One-Click F5)**:
   - Press `F5` or click the **Run and Debug** icon on the left sidebar.
   - At the bottom-right status bar of VS Code, click the device selector and pick **Chrome (web-javascript)** or **Windows (windows-x64)**.
   - Press **Start Debugging** (`F5`).

4. **Hot Reload & Hot Restart**:
   - Press `r` in the terminal to Hot Reload changes instantly.
   - Press `R` to Hot Restart the state.
   - Press `q` to quit the running app.

---

## 🌐 How to Deploy to Vercel

The web production bundle has already been compiled (`build/web`) and configured with [`vercel.json`](file:///d:/flutter%20app/vercel.json).

### Quick 1-Step Deploy (CLI)
1. In your VS Code terminal (or PowerShell), run:
   ```bash
   npx vercel --prod
   ```
   *(Or double-click the included [`deploy.bat`](file:///d:/flutter%20app/deploy.bat) file).*
2. Follow the prompt to log in via browser (if not already logged in).
3. Vercel will upload the pre-built `build/web` directory and output your live production URL (e.g. `https://clarity-workspace.vercel.app`)!

### CI/CD via GitHub + Vercel
1. Initialize git and push your repository to GitHub:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Clarity Flutter Web App"
   git remote add origin https://github.com/YOUR_USERNAME/clarity-app.git
   git branch -M main
   git push -u origin main
   ```
2. Go to [vercel.com/new](https://vercel.com/new), select **Import Git Repository**, choose your `clarity-app` repo, and click **Deploy**.


## 📱 Features Breakdown

### 1. 🔐 Real-Life Authentication & Session
- **Sign In & Sign Up Modes**: Clean tabbed toggle between logging in and registering a new account.
- **Clean Default Inputs**: No pre-filled demo passwords or mock emails.
- **Remember Me**: Saves your email locally across restarts.
- **Show/Hide Password**: Convenient visibility toggle for passwords.
- **Forgot Password Modal**: Clean interactive dialog to request a reset link.
- **Fast 1-Tap Access**: Optional "Explore Demo Account" button for instant testing with seed data.

### 2. 📋 Task Management & Productivity
- **Add New Tasks**: Fresh blank form with title, category, due date & time, priority (High/Medium/Low), and reminder toggle.
- **Edit Existing Tasks**: Pre-fills existing task data for quick updates.
- **Interactive Date & Time Pickers**: Quick chips ("Today", "Tomorrow", "Next Monday") + custom dialog pickers.
- **Smart AI Summarizer Helper**: Formats plain notes into structured action items, design specs, and sync tags with one tap.
- **Task Detail Bottom Sheet**:
  - Full notes & subtasks viewing.
  - Priority pills and category badges.
  - Status toggle (Pending / Completed).
  - Direct edit and delete with confirmation dialog.
- **Search & Filter**: Real-time search bar across titles and notes, plus category filter chips.

### 3. 🔥 Daily Momentum & Streak Tracker
- **Streak Flame Badge**: Dynamic streak counter with celebratory milestones.
- **Progress Gauge**: Real-time completion percentage and motivational feedback.
- **7-Day Week Dots**: Visual Monday–Sunday indicators showing daily activity.
- **Expandable Metrics Breakdown**: Detailed modal dialog showing complete productivity analytics.

### 4. 📅 Interactive Calendar Schedule
- **Dynamic Week Strip**: Displays days of the week with day name, date number, and active dots.
- **Week-by-Week Pagination**: Navigate forward and backward across weeks (`<` and `>`).
- **Interactive Timeline**: Highlights tasks scheduled for the selected date with empty state fallback.

### 5. 🗂️ Categories & Lists Hub
- 4 Core workspaces: **Work**, **Personal**, **Urgent**, and **Tech**.
- Live completion progress bars and percentages.
- Tap any category card to instantly filter tasks on the main dashboard.

### 6. ⚙️ Settings & User Profile
- **Dynamic Profile Card**: Initials avatar fallback, full name, role, and department.
- **Edit Profile Modal**: Update your name, title, and team in local storage.
- **Preferences & Switches**:
  - Dark Mode (smooth light/dark theme switching).
  - Push Notifications toggle.
  - Daily Morning Digest toggle.
  - Sound & Haptic feedback toggle.
  - Biometric App Lock toggle.
- **Workspace Cleanup**: Mark all tasks completed or clear finished tasks.
- **Reset Demo Data**: Restore default sample tasks at any time.
- **Sign Out**: Confirmation dialog returning you to the login screen.

---

## 🏛️ Project Structure

```
lib/
├── main.dart                   # App entry point, MultiProvider & screen shell
├── models/                     # Data models (JSON serializable)
│   ├── task_model.dart         # Task entity & copyWith
│   ├── user_model.dart         # User entity & initials
│   └── streak_model.dart       # Momentum & streak data structures
├── providers/                  # State management (Provider pattern)
│   ├── auth_provider.dart      # User session, login, register, profile
│   ├── task_provider.dart      # CRUD operations, filters, momentum calculation
│   └── theme_provider.dart     # Light/Dark mode & preference toggles
├── screens/                    # UI screens
│   ├── auth/login_screen.dart  # Sign In / Sign Up
│   ├── dashboard/dashboard_screen.dart # Main task list & momentum
│   ├── add_task/add_task_screen.dart   # Create & edit task form
│   ├── calendar/calendar_screen.dart   # Week strip & timeline
│   ├── lists/lists_screen.dart         # Workspace categories
│   └── settings/settings_screen.dart   # Profile & preferences
├── services/                   # Storage & persistence
│   ├── session_service.dart    # SharedPreferences session manager
│   ├── task_repository.dart    # Task persistence & starter seed tasks
│   └── user_repository.dart    # User accounts persistence
├── theme/
│   └── app_theme.dart          # Material 3 light/dark theme & brand tokens
└── widgets/                    # Modular components
    ├── app_drawer.dart         # Side navigation drawer
    ├── bottom_nav_bar.dart     # 5-tab bar with quick add FAB
    ├── daily_momentum_card.dart# Streak card with 7-day indicators
    ├── task_card.dart          # Task item with priority & status
    └── task_detail_sheet.dart  # Bottom sheet with task actions
```

---

## 🧪 Testing & Verification

Run the test suite:
```bash
flutter test
```

Analyze the code:
```bash
flutter analyze
```
