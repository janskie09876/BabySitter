import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/home-paymentpage/dashboard_nanny.dart';
import 'package:babysitter/register-settingspage/recoverpassword.dart';
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      isError = false; // Reset error state before login attempt
      errorMessage = "";
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User user = userCredential.user!;

      DocumentSnapshot userDocParent = await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .get();

      DocumentSnapshot userDocBabysitter = await FirebaseFirestore.instance
          .collection('babysitters')
          .doc(user.uid)
          .get();

      if (userDocParent.exists) {
        String role = userDocParent['role'];
        if (role == "Parent") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          setState(() {
            isError = true;
            errorMessage = "Role mismatch for Parent user.";
          });
        }
      } else if (userDocBabysitter.exists) {
        String role = userDocBabysitter['role'];
        if (role == "Babysitter") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardNanny()),
          );
        } else {
          setState(() {
            isError = true;
            errorMessage = "Role mismatch for Babysitter user.";
          });
        }
      } else {
        setState(() {
          isError = true;
          errorMessage =
              "User not found in either parents or babysitters collection.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isError = true;
        if (e.code == 'invalid-email') {
          errorMessage = 'The email address format is invalid.';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'The email address is not registered.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect email and password.';
        } else if (e.code == 'user-disabled') {
          errorMessage =
              'The account associated with this email has been disabled.';
        } else {
          errorMessage = 'Incorrect email and password. Please try again!';
        }
      });
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'Incorrect email and password. Please try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light Background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const CircleAvatar(
                radius: 40,
                backgroundColor:
                    Color(0xFFC47F42), // Orange background for avatar
                child:
                    Icon(Icons.directions_walk, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000), // Primary Text (Black)
                ),
              ),
              const SizedBox(height: 20),

              // Email Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000), // Primary Text (Black)
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Email Field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  labelStyle: const TextStyle(
                      color: Color(0xFF000000)), // Primary Text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFFE3C3A3)), // Beige border color
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Color(0xFF000000)), // Primary Text in input
              ),
              const SizedBox(height: 20),

              // Password Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000), // Primary Text (Black)
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Password Field
              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  labelStyle: const TextStyle(
                      color: Color(0xFF000000)), // Primary Text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFFE3C3A3)), // Beige border color
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(
                          0xFF000000), // Primary Text (Black) icon color
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                    color: Color(0xFF000000)), // Primary Text in input
              ),

              // Error Message
              if (isError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red, // Error message color
                      fontSize: 14,
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFC47F42), // Orange button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: loginUser,
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password (Below Login Button)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecoverPassword(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFC47F42), // Orange for link
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Are you new here? ",
                    style: TextStyle(
                      color: Color(0xFF000000), // Primary Text (Black)
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registration()),
                      );
                    },
                    child: const Text(
                      "Create account",
                      style: TextStyle(
                        color: Color(0xFFC47F42), // Orange for link
                        fontWeight: FontWeight.bold,
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
