import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'config/env_config.dart';
import 'theme/app_theme.dart';
import 'services/backend_service.dart';
import 'screens/image_upload_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_create_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await EnvConfig.initialize();

  // Initialize backend service and API clients
  BackendService.initialize();

  // Print configuration in debug mode
  if (EnvConfig.instance.debugMode) {
    EnvConfig.instance.printConfig();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login App',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/upload-image': (context) => const ImageUploadScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-category': (context) => const CategoryCreateScreen(),
      },
    );
  }
}
