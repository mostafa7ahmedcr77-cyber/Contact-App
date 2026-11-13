import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseFirestore.instance.collection('contacts').add({
    'name': 'Mostafa',
    'phone': '01000000000',
  });

  runApp(const myContactApp());
}

class myContactApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Material();
  }
}
