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

    // Get screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.06; // 6% of screen width
    final double iconSize = screenWidth * 0.2; // 20% of screen width for icon
    final double titleFontSize = screenWidth * 0.07; // Responsive title font size
    final double subtitleFontSize = screenWidth * 0.04; // Responsive subtitle font size
    final double inputFontSize = screenWidth * 0.045; // Responsive input font size
    final double buttonFontSize = screenWidth * 0.05; // Responsive button font size


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
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenWidth * 0.08), // Responsive space from app bar

              Icon(
                Icons.lock_outline,
                size: iconSize,
                color: primaryGreen,
              ),
              SizedBox(height: screenWidth * 0.06),

              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: screenWidth * 0.02),
              Text(
                'Sign in to continue to your account',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.08),

              // Email Input Field with Validation
              TextField(
                controller: _emailController, // Assign controller
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: textColor, fontSize: inputFontSize), // Responsive font size
                onChanged: (text) => _validateForm(), // Validate on text change
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: hintColor, fontSize: inputFontSize),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: hintColor, fontSize: inputFontSize),
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
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: subtitleFontSize), // Responsive error font size
                ),
              ),
              SizedBox(height: screenWidth * 0.04),

              // Password Input Field with Visibility Toggle and Validation Check
              TextField(
                controller: _passwordController, // Assign controller
                obscureText: !_passwordVisible, // Toggles based on state
                style: TextStyle(color: textColor, fontSize: inputFontSize), // Responsive font size
                onChanged: (text) => _validateForm(), // Check if not empty on text change
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: hintColor, fontSize: inputFontSize),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: hintColor, fontSize: inputFontSize),
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
                      // Choose the icon based on _passwordVisible state
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: hintColor, // Use hint color for the icon
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.06),

              // Sign In Button (Enabled/Disabled based on validation)
              SizedBox(
                width: double.infinity, // Make button fill width
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
                    backgroundColor: isSignInButtonEnabled ? primaryGreen : Colors.grey, // Grey when disabled
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04), // Responsive padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5, // Add some shadow
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: buttonFontSize, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: isSignInButtonEnabled ? textColor : textColor.withOpacity(0.6), // Text color for disabled button
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),

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
                    color: primaryGreen, // Use primary green for links
                    fontSize: subtitleFontSize, // Responsive font size
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: hintColor, fontSize: subtitleFontSize), // Responsive font size
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
                        fontSize: subtitleFontSize, // Responsive font size
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
