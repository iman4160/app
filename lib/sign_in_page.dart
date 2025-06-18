import 'package:flutter/material.dart';
// Ensure 'newproject' matches your actual project name.
// If your project name is different, change 'newproject' to your project's package name.
import 'package:newproject/sign_up_page.dart';
import 'package:newproject/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for password visibility and validation
  bool _passwordVisible = false;
  bool _isEmailValid = false; // Tracks if the email is valid
  bool _isPasswordNotEmpty = false; // Tracks if password field has text

  // Define the custom colors
  final Color primaryGreen = const Color(0xFF1b9349);
  final Color accentBlue = const Color(0xFF3753a2);
  final Color textColor = Colors.white;
  final Color hintColor = Colors.white70;
  final Color inputFillColor = Colors.white.withOpacity(0.1);

  // Regular expression for basic email validation
  // This is a simple regex; for very strict validation, a more complex one might be needed.
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  @override
  void initState() {
    super.initState();
    _passwordVisible = false; // Initially hide the password

    // Add listeners to text controllers to perform real-time validation
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  // Method to validate email format
  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  // Method to check if password is not empty
  void _checkPasswordNotEmpty(String password) {
    setState(() {
      _isPasswordNotEmpty = password.isNotEmpty;
    });
  }

  // Master validation method for the button state
  void _validateForm() {
    _validateEmail(_emailController.text);
    _checkPasswordNotEmpty(_passwordController.text);
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the Sign In button should be enabled
    final bool isSignInButtonEnabled = _isEmailValid && _isPasswordNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: accentBlue,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),

              Icon(
                Icons.lock_outline,
                size: 100,
                color: primaryGreen,
              ),
              const SizedBox(height: 30),

              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Sign in to continue to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email Input Field with Validation
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: textColor),
                onChanged: (text) => _validateForm(), // Call master validation on change
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
                  // Error message for invalid email
                  errorText: _emailController.text.isNotEmpty && !_isEmailValid
                      ? 'Please enter a valid email'
                      : null,
                  errorStyle: TextStyle(color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 20),

              // Password Input Field with Visibility Toggle and Validation Check
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                style: TextStyle(color: textColor),
                onChanged: (text) => _validateForm(), // Call master validation on change
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: hintColor),
                  hintText: 'Enter your password',
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
              const SizedBox(height: 30),

              // Sign In Button (Enabled/Disabled based on validation)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // onPressed is null when button is disabled
                  onPressed: isSignInButtonEnabled ? () {
                    print('Sign In button pressed - Navigating to Home Page');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } : null, // Set to null to disable the button
                  style: ElevatedButton.styleFrom(
                    // Change background color to grey when disabled
                    backgroundColor: isSignInButtonEnabled ? primaryGreen : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // Text color for disabled button can also be adjusted if needed
                      color: isSignInButtonEnabled ? textColor : textColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot Password link
              TextButton(
                onPressed: () {
                  print('Forgot Password button pressed');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Forgot Password functionality not implemented yet!')),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: hintColor),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
      ),
    );
  }
}
