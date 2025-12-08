import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'landing/home_screen.dart'; // ✅ Your main home with navigation!

void main() async {
  // These 2 lines are REQUIRED before Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DMP App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF0B0B0D), // deep black
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF00FF9C), // neon green accent
            secondary: const Color(0xFF00C986),
            surface: const Color(0xFF111113),
            background: const Color(0xFF0B0B0D),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(), // ✅ Main home with navigation (components/home)
      ),
    );
  }
}
