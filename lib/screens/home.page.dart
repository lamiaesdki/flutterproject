import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/screens/login.page.dart'; // Import the LoginPage
import 'dart:convert'; // for base64 decoding

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  String? fullName;
  String? profilePicture;

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
      if (user != null) {
        fetchUserDetails();
      }
    });
  }

  // Fetch user details from Firestore
  Future<void> fetchUserDetails() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            fullName = snapshot.data()?['fullName'];
            profilePicture = snapshot.data()?['imageBase64'];
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  // Function to return a personalized welcome message based on the time of day
  String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome!',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: profilePicture != null
                        ? MemoryImage(base64Decode(profilePicture!))
                        : AssetImage("images/avatar.jpeg"),
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                   Text(
                    "${fullName ?? "Guest"}",
                     style: TextStyle(
                       fontSize: 18,
                        color: Colors.black,
                        ),
                    ),
                     Text(
                    "${user?.email ?? "No Email"}",
                     style: TextStyle(
                       fontSize: 12,
                        color: Colors.black,
                        ),
                    ),

                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                // Navigate to Profile page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to Settings page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                FirebaseAuth.instance.signOut(); // Log out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Message with Background
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/slay.jpeg'), // Add a background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTimeBasedGreeting(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                   Text(
                    "You're logged in as: ${fullName ?? "Guest"}",
                     style: TextStyle(
                       fontSize: 18,
                        color: Colors.white,
                        ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Action Cards with minimalist vibe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      leading: Icon(Icons.account_circle, color: Colors.black, size: 30),
                      title: Text(
                        'Profile',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        // Navigate to Profile
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      leading: Icon(Icons.settings, color: Colors.black, size: 30),
                      title: Text(
                        'Settings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        // Navigate to Settings
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Additional Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      leading: Icon(Icons.help, color: Colors.black, size: 30),
                      title: Text(
                        'Help & Support',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        // Navigate to Help & Support page
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
