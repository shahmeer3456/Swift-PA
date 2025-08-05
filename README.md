# SwiftPA - Your Personal Assistant App

A modern Flutter-based personal assistant application designed to help you manage tasks, notes, and stay organized with voice capabilities and smart features.

## 🚀 Features
## Screen shots: 
### 📋 Task Management
- Create, edit, and delete tasks with detailed descriptions
- Set due dates and recurring patterns
- Priority levels and status tracking
- Tag-based organization
- Completion tracking with timestamps

### 📝 Smart Notes
- Rich text note creation and editing
- Category-based organization
- Important note flagging
- Tag system for easy search and filtering
- Automatic timestamps for creation and updates

### 🎤 Voice Integration
- Text-to-speech functionality for hands-free operation
- Voice feedback for task and note operations
- Customizable speech rate and volume settings

### 🔔 Notifications
- Local notification system for task reminders
- Customizable notification settings
- Background notification handling

### 🔍 Search & Organization
- Advanced search functionality across tasks and notes
- Tag-based filtering and organization
- Category-based note management
- Quick access to important items

### 🎨 Modern UI/UX
- Material Design 3 implementation
- Responsive and adaptive interface
- Dark/light theme support
- Smooth animations and transitions
- Intuitive navigation

## 🛠️ Technology Stack

- **Framework**: Flutter 3.8+
- **Language**: Dart
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **HTTP Client**: Dio
- **Notifications**: flutter_local_notifications
- **Text-to-Speech**: flutter_tts
- **JSON Serialization**: json_annotation

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd swift_pa
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **For Android Development**
   - Ensure Android Studio is installed
   - Set up Android emulator or connect physical device
   - Run `flutter doctor` to verify setup

2. **For iOS Development** (macOS only)
   - Install Xcode
   - Set up iOS Simulator or connect physical device
   - Run `flutter doctor` to verify setup

3. **For Web Development**
   - Enable web support: `flutter config --enable-web`
   - Run `flutter run -d chrome`

## 📁 Project Structure

```
lib/
├── config/
│   └── app_config.dart          # App configuration
├── models/
│   ├── task.dart               # Task data model
│   ├── task.g.dart             # Generated task code
│   ├── note.dart               # Note data model
│   ├── note.g.dart             # Generated note code
│   ├── user.dart               # User data model
│   └── user.g.dart             # Generated user code
├── providers/
│   ├── task_provider.dart       # Task state management
│   └── note_provider.dart       # Note state management
├── screens/
│   ├── home_screen.dart         # Main dashboard
│   ├── tasks_screen.dart        # Task management
│   ├── notes_screen.dart        # Note management
│   ├── search_screen.dart       # Search functionality
│   └── settings_screen.dart     # App settings
├── services/
│   ├── gemini_service.dart      # AI integration
│   └── local_storage_service.dart # Local data storage
├── utils/                       # Utility functions
├── widgets/                     # Reusable UI components
└── main.dart                    # App entry point
```

## 🔧 Configuration

### Environment Setup

The app uses environment-based configuration through `lib/config/app_config.dart`:

- **Development**: Debug mode with detailed logging
- **Production**: Optimized performance with minimal logging

### API Configuration

For local development with Android emulator:
- Use `10.0.2.2` instead of `localhost` for API requests
- Configure backend to listen on `0.0.0.0` for emulator connections

## 📖 Usage

### Task Management
1. Navigate to the Tasks section
2. Tap the "+" button to create a new task
3. Fill in task details including title, description, due date, and priority
4. Add tags for better organization
5. Set recurring patterns if needed
6. Mark tasks as complete when finished

### Note Taking
1. Go to the Notes section
2. Create new notes with rich text content
3. Add titles and categories for organization
4. Use tags for easy searching
5. Mark important notes for quick access

### Voice Commands
1. Enable text-to-speech in settings
2. Use voice feedback for hands-free operation
3. Customize speech rate and volume as needed

### Search & Filter
1. Use the search screen to find tasks and notes
2. Filter by tags, categories, or status
3. Sort by date, priority, or importance

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/your-repo/issues) page
2. Create a new issue with detailed information
3. Include device information and error logs

## 🔄 Version History

- **v1.0.0** - Initial release with core task and note management features
- Future versions will include AI integration and enhanced voice capabilities

---

**SwiftPA** - Making productivity personal and accessible! 🚀
