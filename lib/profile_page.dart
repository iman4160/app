import 'package:flutter/material.dart';
import 'package:newproject/sign_in_page.dart'; // Import the Sign In Page for navigation

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Define the custom colors, consistent with the other pages
  final Color primaryGreen = const Color(0xFF1b9349);
  final Color accentBlue = const Color(0xFF3753a2);
  final Color textColor = Colors.white;
  final Color hintColor = Colors.white70; // Used for labels/subtle text

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.06;
    final double profileImageRadius = screenWidth * 0.15; // 15% of screen width for radius
    final double profileIconSize = screenWidth * 0.2; // Adjusted to be bigger than radius
    final double nameFontSize = screenWidth * 0.055;
    final double headingFontSize = screenWidth * 0.05;
    final double infoLabelFontSize = screenWidth * 0.04;
    final double infoValueFontSize = screenWidth * 0.04;
    final double buttonFontSize = screenWidth * 0.045;


    return Scaffold(
      backgroundColor: Colors.black87, // Consistent dark background
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: accentBlue, // Accent blue for app bar
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
          children: <Widget>[
            SizedBox(height: screenWidth * 0.06),

            // Circular Profile Picture
            CircleAvatar(
              radius: profileImageRadius, // Responsive size
              backgroundColor: primaryGreen.withOpacity(0.8),
              child: Icon(
                Icons.person, // Placeholder icon
                size: profileIconSize, // Responsive icon size
                color: textColor.withOpacity(0.9),
              ),
            ),
            SizedBox(height: screenWidth * 0.04),

            // User's Full Name
            Text(
              'Ahmad Smith', // Placeholder Name
              style: TextStyle(
                fontSize: nameFontSize, // Responsive font size
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: screenWidth * 0.08),

            // User Info Section Heading
            Align(
              alignment: Alignment.centerLeft, // Align heading to the left
              child: Text(
                'User Info',
                style: TextStyle(
                  fontSize: headingFontSize, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ),
            const Divider(color: Colors.white38, thickness: 1, height: 20), // Divider for separation

            // User Info Details (using a Column with Rows for alignment)
            _buildInfoRow('Name', 'Ahmad Smith', infoLabelFontSize, infoValueFontSize), // Placeholder
            _buildInfoRow('Email', 'ahmad.smith@example.com', infoLabelFontSize, infoValueFontSize), // Placeholder
            _buildInfoRow('D.O.B', '01/01/1990', infoLabelFontSize, infoValueFontSize), // Placeholder
            _buildInfoRow('Phone Number', '+1 555-123-4567', infoLabelFontSize, infoValueFontSize), // Placeholder
            SizedBox(height: screenWidth * 0.1), // Responsive space before the button

            // Log Out Button
            SizedBox(
              width: double.infinity, // Make button fill width
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Sign In page and remove all routes below it
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                        (Route<dynamic> route) => false, // This predicate ensures all previous routes are removed
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue, // Use accent blue for the logout button
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04), // Responsive padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: buttonFontSize, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: textColor, // White text on blue button
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build a row for information display (responsive font sizes)
  Widget _buildInfoRow(String label, String value, double labelFontSize, double valueFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for labels for alignment - can be made responsive
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: labelFontSize, // Responsive font size
                fontWeight: FontWeight.bold,
                color: hintColor, // Use hint color for labels
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize, // Responsive font size
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

