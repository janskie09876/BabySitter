import 'package:babysitter/account-ratingandreviewpage-terms/privacypolicy.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/termspage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';

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
  void initState() {
    errorMessage = "This is an error";
    isError = false;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorations
          Positioned(
            left: screenWidth * 0.2,
            top: -screenHeight * 0.3,
            child: Transform(
              transform: Matrix4.identity()..rotateZ(0.60),
              child: Container(
                width: screenWidth * 2,
                height: screenHeight * 2.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [
                      Color(0x00D9D9D9),
                      Colors.white,
                      Color(0xFFA43547),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.4,
            top: screenHeight * 0.4,
            child: Transform(
              transform: Matrix4.identity()..rotateZ(0.65),
              child: Container(
                width: screenWidth * 1.5,
                height: screenHeight,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE3838E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(66),
                  ),
                ),
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Centered content with form fields
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name Text Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                            fontFamily: 'BalsamiqSans',
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF48FB1),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Password Text Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                            fontFamily: 'BalsamiqSans',
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF48FB1),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                  // Email Text Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                            fontFamily: 'BalsamiqSans',
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF48FB1),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Phone Number Text Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                            fontFamily: 'BalsamiqSans',
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF48FB1),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Role Dropdown Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: DropdownButtonFormField<String>(
                        value: selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Role',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                            fontFamily: 'BalsamiqSans',
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFF48FB1),
                            ),
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
                    ),
                  ),
                  // Terms and Privacy Policy Checkbox Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      // Center the column containing the checkboxes
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Minimize the height of the Column
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize
                                .min, // Minimize the width of the Row
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
                                  // Navigate to the Terms and Conditions page when tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TermsAndConditionsPage(
                                        onAccept: () {
                                          // Handle any action when terms are accepted, if needed
                                          print("Terms Accepted");
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child:
                                    const Text("I accept the Terms of Service"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize
                                .min, // Minimize the width of the Row
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
                                  // Navigate to the Privacy Policy page when tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrivacyPolicyPage(
                                        onAccept: () {
                                          // Handle any action when privacy policy is accepted, if needed
                                          print("Privacy Policy Accepted");
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child:
                                    const Text("I accept the Privacy Policy"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Register Button
                  ElevatedButton(
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
                      backgroundColor: const Color(0xFFE3838E),
                    ),
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
