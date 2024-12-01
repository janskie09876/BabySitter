import 'package:flutter/material.dart';

void main() {
  runApp(const Registration(
    title: '',
  ));
}

class Registration extends StatefulWidget {
  const Registration({super.key, required String title});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const RegistrationDelaCerna(title: 'Baby Sitting'),
    );
  }
}

class RegistrationDelaCerna extends StatefulWidget {
  final String title;

  const RegistrationDelaCerna({super.key, required this.title});

  @override
  State<RegistrationDelaCerna> createState() => _RegistrationDelaCernaState();
}

class _RegistrationDelaCernaState extends State<RegistrationDelaCerna> {
  bool isChecked = false;
  String? selectedRole;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              // Background Decorations
              Positioned(
                left: screenWidth * 0.4,
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
                        colors: [Colors.white, Color(0xFFA43547)],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                top: screenHeight * 0.2,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Fields
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF48FB1)),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF48FB1)),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFFF48FB1),
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
                    SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF48FB1)),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFFF48FB1),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Dropdown for role
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          labelStyle: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF48FB1)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Parent',
                            child: Text('Parent'),
                          ),
                          DropdownMenuItem(
                            value: 'Baby Sitter',
                            child: Text('Baby Sitter'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFF48FB1),
                        ),
                        const Expanded(
                          child: Text(
                            "I have read and accepted the Terms and Conditions",
                            style: TextStyle(
                              color: Color(0xFFE3838E),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Register Button
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF48FB1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Register Now!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
