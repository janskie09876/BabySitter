import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/home-paymentpage/dashboard_nanny.dart';
import 'package:babysitter/register-settingspage/changepass.dart';
import 'package:babysitter/register-settingspage/registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeBack extends StatefulWidget {
  @override
  _WelcomeBackState createState() => _WelcomeBackState();
}

class _WelcomeBackState extends State<WelcomeBack> {
  bool _isPasswordVisible = false; // Toggle password visibility
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = "";
  bool isError = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    try {
      // Authenticate user with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the logged-in user's ID
      User user = userCredential.user!;

      // Retrieve user role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Navigate based on the role
        if (role == "Babysitter") {
          // Navigate to Babysitter Dashboard if the role is Babysitter
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardNanny(
                      nannyId: '',
                      chatId: '',
                      babysitterName: '',
                      userId: '',
                    )), // Assuming BabysitterDashboard exists
          );
        } else {
          // Navigate to the default Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        }
      } else {
        // If no role found in Firestore, handle it as an error
        setState(() {
          isError = true;
          errorMessage = "User role not found.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isError = true;
        // Check for specific error codes
        if (e.code == 'invalid-email') {
          errorMessage = 'The email address format is invalid.';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'The email address is not registered.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'The password entered is incorrect.';
        } else if (e.code == 'user-disabled') {
          errorMessage =
              'The account associated with this email has been disabled.';
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDEDE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFDEDE),
        elevation: 0, // Remove shadow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Hello!",
                style: TextStyle(
                  fontFamily: 'Baloo', // Heading font
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE3838E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in with your account",
                style: TextStyle(
                  fontFamily: 'Balsamiq Sans', // Subtitle font
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Show error message
              if (isError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),

              // Email Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontFamily: 'Balsamiq Sans', // Subtitle font
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 16.0, top: 12.0),
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Balsamiq Sans', // Subtitle font
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              Container(
                width: double.infinity,
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3838E),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: loginUser, // Call login method
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Number font
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Forgot your Password? ",
                    style: TextStyle(
                      fontFamily: 'Balsamiq Sans', // Subtitle font
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Change Password page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Changepass(title: 'Change Password'),
                        ),
                      );
                    },
                    child: const Text(
                      "Reset here",
                      style: TextStyle(
                        fontFamily: 'Balsamiq Sans', // Subtitle font
                        fontSize: 16.0,
                        color: Color(0xFFFF7A8F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'Balsamiq Sans', // Subtitle font
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Registration page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registration(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'Baloo', // Heading font
                          fontSize: 16.0,
                          color: Color(0xFFE3838E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
