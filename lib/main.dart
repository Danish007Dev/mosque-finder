import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive for local storage (works on all platforms including web)
  await Hive.initFlutter();

  // Load environment variables
  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (_) {
    // .env file may not exist in all environments
  }

  // Run app with ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: MosqueFinderApp(),
    ),
  );
}