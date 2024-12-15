import 'package:babysitter/account-ratingandreviewpage-terms/privacypolicy.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/termspage.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // Form field controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late String errorMessage;
  late bool isError;
  String? selectedRole;

  // Add variables to track checkbox states
  bool acceptTerms = false;
  bool acceptPrivacyPolicy = false;

  @override
  void initState() {
    super.initState();
    errorMessage = "This is an error";
    isError = false;
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Send verification email
        await user.sendEmailVerification();

        // Save additional user data in Firestore
        String userId = user.uid;
        final userData = {
          "id": userId,
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "role": selectedRole ?? "Not Specified",
          "emailVerified": false,
        };

        // Choose Firestore collection based on the selected role
        if (selectedRole == 'Babysitter') {
          // Save to babysitters collection
          await FirebaseFirestore.instance
              .collection('babysitters')
              .doc(userId)
              .set(userData);
        } else if (selectedRole == 'Parent') {
          // Save to parents collection
          await FirebaseFirestore.instance
              .collection('parents')
              .doc(userId)
              .set(userData);
        } else {
          // Default to a general collection if role is not specified
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .set(userData);
        }

        // Show dialog prompting the user to verify their email
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Verify Your Email"),
              content: const Text(
                  "A verification email has been sent to your email address. Please verify your email to proceed."),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await checkEmailVerification(user); // Verify the email
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors
      String errorMsg;
      if (e.code == 'email-already-in-use') {
        errorMsg = 'This email is already registered.';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'The email address format is invalid.';
      } else if (e.code == 'weak-password') {
        errorMsg = 'The password is too weak.';
      } else {
        errorMsg = 'Registration failed: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }

  Future<void> checkEmailVerification(User user) async {
    bool emailVerified = false;

    while (!emailVerified) {
      await Future.delayed(
          const Duration(seconds: 2)); // Wait before checking again
      await user.reload(); // Reload the user to fetch the latest data
      emailVerified = user.emailVerified;

      if (emailVerified) {
        // Update Firestore to mark the email as verified
        final docUser =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await docUser.update({"emailVerified": true});

        // Navigate to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email verified! Welcome!")),
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light Background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color(0xFF000000)), // Primary Text (Black)
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFC47F42), // Orange
                  child: Icon(Icons.directions_walk,
                      size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000), // Primary Text (Black)
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Full Name
              const Text(
                "Full name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000), // Primary Text (Black)
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  hintStyle: TextStyle(
                      color: Color(0xFF7D7D7D)), // Secondary Text (Gray)
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0xFFE3C3A3)), // Beige border
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              const Text("Email", style: TextStyle(color: Color(0xFF000000))),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Color(0xFF7D7D7D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFE3C3A3)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              const Text("Password",
                  style: TextStyle(color: Color(0xFF000000))),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Min 8 characters",
                  hintStyle: TextStyle(color: Color(0xFF7D7D7D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFE3C3A3)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number
              const Text("Phone number",
                  style: TextStyle(color: Color(0xFF000000))),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  hintStyle: TextStyle(color: Color(0xFF7D7D7D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFE3C3A3)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Role
              const Text("Role", style: TextStyle(color: Color(0xFF000000))),
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFFE3C3A3)),
                  ),
                ),
                items: <String>['Babysitter', 'Parent']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Terms and Privacy Policy Checkbox Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: acceptTerms,
                            onChanged: (bool? newValue) {
                              setState(() {
                                acceptTerms = newValue!;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TermsAndConditionsPage(
                                    onAccept: () {
                                      print("Terms Accepted");
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text("I accept the Terms of Service",
                                style: TextStyle(color: Color(0xFF7D7D7D))),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: acceptPrivacyPolicy,
                            onChanged: (bool? newValue) {
                              setState(() {
                                acceptPrivacyPolicy = newValue!;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyPage(
                                    onAccept: () {
                                      print("Privacy Policy Accepted");
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text("I accept the Privacy Policy",
                                style: TextStyle(color: Color(0xFF7D7D7D))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Register Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (acceptTerms && acceptPrivacyPolicy) {
                        registerUser();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "You must accept the Terms and Privacy Policy."),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC47F42), // Orange Button color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Log In
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Color(0xFFC47F42), // Orange color for login
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
