import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:my_contact_app/core/app_routes.dart';
import 'package:my_contact_app/feature/view/screens/home_screen.dart';
import 'package:my_contact_app/feature/view/screens/new_contact_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.newContact: (context) => const NewContactScreen(),
      },
    );
  }
}
