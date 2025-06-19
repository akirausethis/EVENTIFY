import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/auth/screens/landing_page.dart';
import 'package:eventify_flutter/features/shell/main_scaffold.dart';
import 'package:eventify_flutter/firebase_options.dart';
import 'package:eventify_flutter/services/dummy_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // -- PANGGIL FUNGSI GENERATOR DI SINI --
  // Ini akan mengisi data hanya jika database kosong.
  await DummyDataGenerator().generateAndUploadDummyData();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventify',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          return const MainScaffold();
        }
        return const LandingPage();
      },
    );
  }
}
