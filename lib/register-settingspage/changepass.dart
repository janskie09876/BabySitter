import 'package:flutter/material.dart';

class Changepass extends StatefulWidget {
  final String title;

  const Changepass({super.key, required this.title});

  @override
  _ChangepassState createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Change Password',
                      style: const TextStyle(
                        fontFamily: 'Baloo', // Title font (Baloo)
                        color: Color(0xFF424242),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Old Password Field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Old Password',
                    style: TextStyle(
                      fontFamily: 'BalsamiqSans', // Body font (Balsamiq Sans)
                      color: Color(0xFF424242),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildPasswordField(
                  obscureText: _obscureOldPassword,
                  toggleVisibility: _toggleOldPasswordVisibility,
                ),
                const SizedBox(height: 20),

                // New Password Field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Password',
                    style: TextStyle(
                      fontFamily: 'BalsamiqSans', // Body font (Balsamiq Sans)
                      color: Color(0xFF424242),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildPasswordField(
                  obscureText: _obscureNewPassword,
                  toggleVisibility: _toggleNewPasswordVisibility,
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontFamily: 'BalsamiqSans', // Body font (Balsamiq Sans)
                      color: Color(0xFF424242),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildPasswordField(
                  obscureText: _obscureConfirmPassword,
                  toggleVisibility: _toggleConfirmPasswordVisibility,
                ),
                const SizedBox(height: 30),

                // Change Password Button
                GestureDetector(
                  onTap: () {
                    // Handle change password action
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3838E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily:
                              'BalsamiqSans', // Body font (Balsamiq Sans)
                          color: Color(0xFFF2F2F2),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
