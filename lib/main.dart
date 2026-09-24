import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/reels_feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ReelsApp());
}

class ReelsApp extends StatelessWidget {
  const ReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reels App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.redAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.pinkAccent,
          surface: Color(0xFF1C1C1E),
        ),
        useMaterial3: true,
      ),
      home: const ReelsFeedScreen(),
    );
  }
}
