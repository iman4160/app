import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer
import 'package:newproject/profile_page.dart'; // Import the Profile Page
import 'package:newproject/customers_screen.dart'; // Import the Customers Screen

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
  final Color primaryGreen = Color(0xFF1b9349);
  final Color accentBlue = Color(0xFF3753a2);
  final Color textColor = Colors.white; // For text on dark backgrounds

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

  // Widget to create a single dashboard grid item (modified to include an icon)
  Widget _buildDashboardGridItem(String title, Color color, IconData icon, double fontSize, double iconSize) {
    return Container(
      margin: const EdgeInsets.all(8), // Margin around each grid item
      padding: const EdgeInsets.all(16), // Padding inside the item
      decoration: BoxDecoration(
        color: color, // The specified color for this item
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Subtle shadow
          ),
        ],
      ),
      child: Column( // Use a Column to stack icon and text vertically
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize, // Responsive icon size
            color: textColor, // White icon for contrast
          ),
          const SizedBox(height: 8), // Space between icon and text
          Text(
            title,
            style: TextStyle(
              color: textColor, // White text for contrast
              fontSize: fontSize, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Adjust font sizes and padding based on screen width
    final double titleFontSize = screenWidth * 0.055; // For "Softnet Technologies"
    final double subtitleFontSize = screenWidth * 0.04; // For "Dashboard"
    final double clockFontSize = screenWidth * 0.045; // For live clock
    final double gridItemFontSize = screenWidth * 0.045; // For text in grid items
    final double gridIconSize = screenWidth * 0.08; // For icons in grid items
    final double buttonFontSize = screenWidth * 0.045; // For button text

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
                fontSize: titleFontSize, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: subtitleFontSize, // Responsive font size
              ),
            ),
          ],
        ),
        actions: [
          // Live Clock in the top right corner
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04), // Responsive padding
            child: Center(
              child: Text(
                _timeString, // Display the current time
                style: TextStyle(
                  color: textColor,
                  fontSize: clockFontSize, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.03), // Responsive overall padding for grid
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children
          children: <Widget>[
            // Grid for Dashboard Items (2x2 layout)
            GridView.count(
              shrinkWrap: true, // Make grid take only needed space
              physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
              crossAxisCount: screenWidth > 600 ? 4 : 2, // 2 columns on small screens, 4 on larger
              crossAxisSpacing: screenWidth * 0.025, // Responsive spacing between columns
              mainAxisSpacing: screenWidth * 0.025, // Responsive spacing between rows
              childAspectRatio: 1.2, // Maintain aspect ratio for squarish look
              children: <Widget>[
                _buildDashboardGridItem('Total Verifications', primaryGreen, Icons.check_circle_outline, gridItemFontSize, gridIconSize),
                _buildDashboardGridItem('New Customers Onboarded', accentBlue, Icons.group_add, gridItemFontSize, gridIconSize),
                _buildDashboardGridItem('Pending Verifications', accentBlue, Icons.pending_actions, gridItemFontSize, gridIconSize),
                _buildDashboardGridItem('Avg. Processing Time', primaryGreen, Icons.hourglass_empty, gridItemFontSize, gridIconSize),
              ],
            ),
            SizedBox(height: screenWidth * 0.06), // Responsive space after the grid

            // New Button for Customers Screen
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025), // Padding to match grid alignment
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CustomersScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue, // Use accent blue for this button
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04), // Responsive padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Manage Customers',
                    style: TextStyle(
                      fontSize: buttonFontSize, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between buttons
          ],
        ),
      ),
      // Persistent bottom navigation/button area (Profile button)
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
