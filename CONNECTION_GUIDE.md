# 🔗 SwiftPA App-Backend Connection Guide

This guide explains how to connect your Flutter app with the backend for both development and production environments.

## 📱 Connection Methods

### 1. **Local Development (Development Mode)**

#### For Android Emulator:
- **Backend URL**: `http://10.0.2.2:3000/api`
- **Socket URL**: `http://10.0.2.2:3000`
- **Requirements**: Backend server running on your computer

#### For Web/Chrome:
- **Backend URL**: `http://localhost:3000/api`
- **Socket URL**: `http://localhost:3000`
- **Requirements**: Backend server running on your computer

#### For iOS Simulator:
- **Backend URL**: `http://localhost:3000/api`
- **Socket URL**: `http://localhost:3000`
- **Requirements**: Backend server running on your computer

### 2. **Production (Vercel Deployment)**

#### For All Platforms:
- **Backend URL**: `https://your-app-name.vercel.app/api`
- **Socket URL**: `https://your-app-name.vercel.app`
- **Requirements**: Backend deployed on Vercel

## 🛠️ Configuration Setup

### Step 1: Update Production URL

Edit `lib/config/app_config.dart` and replace the production URL:

```dart
// Replace with your actual Vercel URL
static const String _prodUrl = 'https://your-actual-app-name.vercel.app/api';
static const String _prodSocketUrl = 'https://your-actual-app-name.vercel.app';
```

### Step 2: Environment Detection

The app automatically detects the environment:
- **Development**: When running in debug mode
- **Production**: When running in release mode

## 🧪 Testing the Connection

### Method 1: Using ConnectionTest Utility

```dart
import '../utils/connection_test.dart';

// Test basic connection
final result = await ConnectionTest.testBackendConnection();
print('Connection: ${result['success']}');

// Test health endpoint
final health = await ConnectionTest.testHealthEndpoint();
print('Health: ${health['health']}');

// Print connection info
ConnectionTest.printConnectionInfo();
```

### Method 2: Manual Testing

1. **Start the backend server:**
   ```bash
   cd backend
   npm run dev
   ```

2. **Run the Flutter app:**
   ```bash
   cd swift_pa
   flutter run
   ```

3. **Check the console output** for connection information

## 📋 Connection Checklist

### For Local Development:
- [ ] Backend server is running on port 3000
- [ ] MongoDB is connected (local or Atlas)
- [ ] Flutter app is in debug mode
- [ ] Android emulator is using 10.0.2.2
- [ ] Web browser can access localhost:3000

### For Production:
- [ ] Backend is deployed on Vercel
- [ ] Environment variables are set in Vercel
- [ ] MongoDB Atlas is configured
- [ ] Flutter app is built in release mode
- [ ] Production URL is updated in app_config.dart

## 🔧 Troubleshooting

### Common Issues:

1. **Connection Refused**
   - Check if backend server is running
   - Verify port 3000 is not blocked
   - For Android emulator, ensure backend listens on 0.0.0.0

2. **CORS Errors (Web)**
   - Backend CORS is configured for localhost
   - Check browser console for CORS errors

3. **Timeout Errors**
   - Increase timeout in AppConfig.apiTimeout
   - Check network connectivity
   - Verify server response time

4. **Production Connection Issues**
   - Verify Vercel deployment is successful
   - Check environment variables in Vercel dashboard
   - Test Vercel URL directly in browser

### Debug Commands:

```bash
# Test backend locally
cd backend && npm run dev

# Test Flutter app
cd swift_pa && flutter run

# Build for production
flutter build apk --release

# Test production connection
curl https://your-app-name.vercel.app/
```

## 📱 Platform-Specific Notes

### Android:
- Emulator uses 10.0.2.2 to access host machine
- Physical devices need internet for production
- APK works on any Android device with internet

### iOS:
- Simulator uses localhost
- Physical devices need internet for production
- App Store deployment requires production backend

### Web:
- Uses localhost for development
- Requires HTTPS for production
- CORS must be properly configured

## 🔄 Switching Between Environments

### Development to Production:
1. Deploy backend to Vercel
2. Update production URL in `app_config.dart`
3. Build release version: `flutter build apk --release`

### Production to Development:
1. Start local backend server
2. Run in debug mode: `flutter run`
3. App automatically uses development URLs

## 📊 Monitoring Connection

### Development:
- Check Flutter console for connection logs
- Monitor backend server logs
- Use ConnectionTest utility

### Production:
- Monitor Vercel function logs
- Check MongoDB Atlas metrics
- Use app analytics for connection issues

## 🚀 Quick Start Commands

```bash
# 1. Start backend (development)
cd backend && npm run dev

# 2. Run Flutter app (development)
cd swift_pa && flutter run

# 3. Test connection
# Check console output for connection status

# 4. Build for production
flutter build apk --release

# 5. Install on device
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📞 Support

If you encounter connection issues:
1. Check backend server status
2. Verify network connectivity
3. Test endpoints manually
4. Check environment configuration
5. Review error logs in console 