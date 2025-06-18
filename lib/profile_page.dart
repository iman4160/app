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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
          children: <Widget>[
            const SizedBox(height: 30),

            // Circular Profile Picture
            CircleAvatar(
              radius: 60, // Size of the circle
              backgroundColor: primaryGreen.withOpacity(0.8), // A slightly transparent green for background
              child: Icon(
                Icons.person, // Placeholder icon
                size: 80,
                color: textColor.withOpacity(0.9), // Slightly faded white icon
              ),
              // You can add a background image here later:
              // backgroundImage: NetworkImage('https://placehold.co/120x120/000000/FFFFFF?text=P'),
            ),
            const SizedBox(height: 20),

            // User's Full Name
            Text(
              'User Name', // Placeholder Name
              style: TextStyle(
                fontSize: 22, // Increased from 16 for better visibility as a main name
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 40),

            // User Info Section Heading
            Align(
              alignment: Alignment.centerLeft, // Align heading to the left
              child: Text(
                'User Info',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen, // Green for subheading
                ),
              ),
            ),
            const Divider(color: Colors.white38, thickness: 1, height: 20), // Divider for separation

            // User Info Details (using a Column with Rows for alignment)
            _buildInfoRow('Name', 'User Name'), // Placeholder
            _buildInfoRow('Email', 'user.name@example.com'), // Placeholder
            _buildInfoRow('D.O.B', '01/01/1990'), // Placeholder
            _buildInfoRow('Phone Number', '+1 555-123-4567'), // Placeholder
            const SizedBox(height: 50), // Increased space before the button

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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 18,
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

  // Helper widget to build a row for information display
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for labels for alignment
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: hintColor, // Use hint color for labels
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
