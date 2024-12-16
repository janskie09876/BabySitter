import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

class NannyChangePassword extends StatefulWidget {
  @override
  _NannyChangePasswordState createState() => _NannyChangePasswordState();
}

class _NannyChangePasswordState extends State<NannyChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRepeatPasswordVisibility() {
    setState(() {
      _obscureRepeatPassword = !_obscureRepeatPassword;
    });
  }

  Future<void> _changePassword() async {
    String password = _passwordController.text.trim();
    String repeatPassword = _repeatPasswordController.text.trim();

    if (password.isEmpty || repeatPassword.isEmpty) {
      _showError("Please fill out both fields.");
      return;
    }

    if (password != repeatPassword) {
      _showError("Passwords do not match.");
      return;
    }

    if (!_validatePassword(password)) {
      _showError("Password must meet all requirements.");
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(password);
        _showSuccess("Password changed successfully.");
        Navigator.pop(context); // Navigate back after success
      } else {
        _showError("No user is currently logged in.");
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "An error occurred.");
    }
  }

  bool _validatePassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'\d'));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF000000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                "Enter new password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.grayColor,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Password Requirements
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PasswordRequirement(text: "8 characters length"),
                  PasswordRequirement(text: "1 number"),
                  PasswordRequirement(text: "1 uppercase letter"),
                ],
              ),

              const SizedBox(height: 20),

              // Repeat Password Field
              const Text(
                "Repeat password",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _repeatPasswordController,
                obscureText: _obscureRepeatPassword,
                decoration: InputDecoration(
                  hintText: "Repeat password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureRepeatPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.grayColor,
                    ),
                    onPressed: _toggleRepeatPasswordVisibility,
                  ),
                ),
              ),

              const Spacer(),

              // Confirm Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordRequirement extends StatelessWidget {
  final String text;

  const PasswordRequirement({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.grayColor,
          ),
        ),
      ],
    );
  }
}
