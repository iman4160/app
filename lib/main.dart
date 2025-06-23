import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage
// IMPORTANT: Replace 'newproject' below with the actual name of your Flutter project.
import 'package:newproject/sign_in_page.dart';


void main() async { // Make main an async function
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await GetStorage.init(); // Initialize GetStorage
  runApp(const MyApp());
}

// MyApp is the root widget of your application.
// It's a StatelessWidget because its properties don't change over time.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sign In Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // This can be overridden by specific page colors
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: const SignInPage(),
    );
  }
}
