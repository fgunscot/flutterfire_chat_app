import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/firebase_options.dart';

import 'package:lab1_provider_messager/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
