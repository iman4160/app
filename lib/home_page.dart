import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer
import 'package:newproject/profile_page.dart'; // Import the new Profile Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to hold the current time, updated by a timer
  late String _timeString;
  late Timer _timer;

  // Define the custom colors for the rectangles, consistent with the Sign In page
  final Color primaryGreen = const Color(0xFF1b9349);
  final Color accentBlue = const Color(0xFF3753a2);
  final Color textColor = Colors.white; // For text on dark backgrounds
  final Color iconColor = Colors.white; // Color for the icons

  @override
  void initState() {
    super.initState();
    // Initialize the time string immediately
    _timeString = _formatDateTime(DateTime.now());
    // Set up a timer to update the time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  // Method to update the time string
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    // Update the state only if the widget is mounted to prevent errors
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  // Helper method to format the DateTime object into a readable string
  String _formatDateTime(DateTime dateTime) {
    // Format as HH:MM:SS (e.g., 14:35:01)
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  // Helper method to ensure two digits for time components (e.g., 01, 05)
  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  // Widget to create a single dashboard rectangle with an icon
  Widget _buildDashboardRectangle(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15), // Padding inside the rectangle
      decoration: BoxDecoration(
        color: color, // The specified color for this rectangle
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Slightly darker shadow
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 4), // More pronounced shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          Icon(
            icon,
            color: iconColor, // White icon color
            size: 40, // Larger icon size
          ),
          const SizedBox(height: 10), // Spacing between icon and text
          Text(
            title,
            style: TextStyle(
              color: textColor, // White text for contrast
              fontSize: 18, // Slightly smaller font for grid items
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2, // Allow text to wrap to two lines if needed
            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background for the page
      appBar: AppBar(
        backgroundColor: accentBlue, // Use accent blue for the app bar
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Softnet Technologies',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          // Live Clock in the top right corner
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                _timeString, // Display the current time
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column( // Use a Column to hold the GridView and any other widgets below it
          children: [
            GridView.count(
              shrinkWrap: true, // Important: allows GridView to take only needed space
              physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
              crossAxisCount: 2, // Two columns
              crossAxisSpacing: 15, // Spacing between columns
              mainAxisSpacing: 15, // Spacing between rows
              childAspectRatio: 1.0, // Make the children square (width/height ratio)
              children: <Widget>[
                // First Rectangle: Total Verifications (Green)
                _buildDashboardRectangle('Total Verifications', Icons.check_circle_outline, primaryGreen),
                // Second Rectangle: New Customers Onboarded (Blue)
                _buildDashboardRectangle('New Customers Onboarded', Icons.person_add_alt_1, accentBlue),
                // Third Rectangle: Pending Verifications (Green)
                _buildDashboardRectangle('Pending Verifications', Icons.hourglass_empty, accentBlue),
                // Fourth Rectangle: Avg. Processing Time (Blue)
                _buildDashboardRectangle('Avg. Processing Time', Icons.timer, primaryGreen),
              ],
            ),
            const SizedBox(height: 20), // Space before the button
          ],
        ),
      ),
      // Persistent bottom navigation/button area
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen, // Green button
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
