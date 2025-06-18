import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // State variables for password visibility
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Define the custom colors, consistent with the other pages
  final Color primaryGreen = Color(0xFF1b9349);
  final Color accentBlue = Color(0xFF3753a2);
  final Color textColor = Colors.white;
  final Color hintColor = Colors.white70;
  final Color inputFillColor = Colors.white.withOpacity(0.1);

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: accentBlue, // Accent blue for app bar
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),

            // App Icon or Logo
            Icon(
              Icons.person_add_alt_1_outlined, // Icon for sign up
              size: 100,
              color: primaryGreen,
            ),
            const SizedBox(height: 30),

            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Fill in your details to create a new account',
              style: TextStyle(
                fontSize: 16,
                color: hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Name Input Field
            TextField(
              keyboardType: TextInputType.text,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: hintColor),
                hintText: 'Enter your full name',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.person, color: primaryGreen),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email Input Field
            TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: hintColor),
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.email, color: primaryGreen),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password Input Field with Visibility Toggle
            TextField(
              obscureText: !_passwordVisible,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: hintColor),
                hintText: 'Create your password',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.lock, color: primaryGreen),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: hintColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Password Input Field with Visibility Toggle
            TextField(
              obscureText: !_confirmPasswordVisible,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: hintColor),
                hintText: 'Re-enter your password',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.lock, color: primaryGreen),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: hintColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign-up logic
                  print('Sign Up button pressed');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign Up functionality not implemented yet!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Already have an account? Sign In link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: hintColor),
                ),
                TextButton(
                  onPressed: () {
                    // Pop back to the Sign In page
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
