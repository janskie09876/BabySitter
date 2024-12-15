import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Send restore link via Firebase Authentication
  void _sendRestoreLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Reset error message on each request
      });

      try {
        // Call Firebase Authentication to send password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text,
        );

        setState(() {
          _isLoading = false;
          _errorMessage =
              'A restore link has been sent to ${emailController.text}';
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to send the restore link. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light Background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

              // Title
              const Text(
                "Recover password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000), // Primary Text (Black)
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                "Enter your account email to recover password",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7D7D7D), // Secondary Text (Gray)
                ),
              ),

              const SizedBox(height: 20),

              // Email Field Label
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000), // Primary Text (Black)
                ),
              ),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(
                        color: Color(
                            0xFF7D7D7D)), // Secondary Text (Gray) for hint
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFE3C3A3), // Beige border color
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Simple email validation regex
                    final emailRegex = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  style: TextStyle(
                      color: Color(0xFF000000)), // Primary Text (Black)
                ),
              ),

              // Error message or success feedback
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: _errorMessage!.startsWith('A restore link')
                        ? Color(0xFF4CAF50) // Success color (Green)
                        : Color(0xFFFBC02D), // Warning color (Yellow)
                    fontSize: 16,
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Send Restore Link Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendRestoreLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC47F42), // Orange button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Send restore link",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
