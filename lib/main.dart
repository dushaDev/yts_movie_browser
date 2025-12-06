import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yts_movie_browser/screens/wrappers/connection_wrapper.dart';
import 'package:yts_movie_browser/theme/theme.dart';
import 'providers/movie_provider.dart';
import 'screens/wrappers/main_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Initialize the MovieProvider so it's available everywhere
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YTS Movie Browser',
      theme: lightTheme,
      darkTheme: darkTheme,

      // Automatically switch based on phone settings (Dark/Light)
      themeMode: ThemeMode.system,

      // Start the app at the Wrapper (which contains the Floating Bar)
      home: ConnectionWrapper(child: const MainWrapper()),
    );
  }
}
