import 'package:flutter/material.dart';
// IMPORTANT: Replace 'your_project_name' below with the actual name of your Flutter project.
// For example, if your project is named 'my_auth_app', it would be:
// import 'package:my_auth_app/sign_in_page.dart';
import 'package:newproject/sign_in_page.dart';
// If you used 'untitled' as the project name, it would be:
// import 'package:untitled/sign_in_page.dart';


void main() {
  // runApp is the entry point for Flutter applications.
  // It takes a Widget (in this case, our MyApp) and attaches it to the screen.
  runApp(const MyApp());
}

// MyApp is the root widget of your application.
// It's a StatelessWidget because its properties don't change over time.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: A one-line description of the app for the device's task switcher.
      title: 'Flutter Sign In Demo',
      // Set this to false to remove the debug banner from the top right corner
      debugShowCheckedModeBanner: false,

      // theme: Defines the visual properties of the Material Design widgets
      // in your app. Here, we set the primary color and visual density.
      theme: ThemeData(
        // primarySwatch creates a MaterialColor from a single color.
        // It's a range of colors based on a single shade.
        primarySwatch: Colors.deepPurple,
        // visualDensity adjusts how densely packed the UI elements are.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // fontFamily sets the default font for the entire application.
        // Make sure 'Inter' is available (usually default or easily added via pubspec.yaml).
        fontFamily: 'Inter',
      ),

      // home: This is the default route of your app.
      // We set our SignInPage as the starting screen.
      home: const SignInPage(),
    );
  }
}
