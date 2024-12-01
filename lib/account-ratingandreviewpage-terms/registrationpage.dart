import 'package:babysitter/account-ratingandreviewpage-terms/privacypolicy.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/termspage.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool acceptTerms = false;
  bool acceptPrivacyPolicy = false;

  void _onPrivacyPolicyAccepted() {
    setState(() {
      acceptPrivacyPolicy = true;
    });
  }

  void _onTermsAccepted() {
    setState(() {
      acceptTerms = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFED7D6), // Light pink background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'REGISTRATION',
                            style: TextStyle(
                              fontFamily:
                                  'Baloo', // Used for headings and titles
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily:
                                    'Balsamiq Sans', // Used for body and subtitles
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily:
                                    'Balsamiq Sans', // Used for body and subtitles
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: 'Email Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelStyle: const TextStyle(
                                fontFamily:
                                    'Balsamiq Sans', // Used for body and subtitles
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Checkbox(
                                value: acceptTerms,
                                onChanged: (bool? value) {
                                  setState(() {
                                    acceptTerms = value ?? false;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TermsAndConditionsPage(
                                        onAccept:
                                            _onTermsAccepted, // Pass the callback
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'I have read and accept the Terms and Conditions',
                                  style: TextStyle(
                                    fontFamily:
                                        'Balsamiq Sans', // Used for body and subtitles
                                    fontSize: 12,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: acceptPrivacyPolicy,
                                onChanged: (bool? value) {
                                  setState(() {
                                    acceptPrivacyPolicy = value ?? false;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrivacyPolicyPage(
                                        onAccept: _onPrivacyPolicyAccepted,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'I agree with the Privacy Policy',
                                  style: TextStyle(
                                    fontFamily:
                                        'Balsamiq Sans', // Used for body and subtitles
                                    fontSize: 12,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                if (acceptTerms && acceptPrivacyPolicy) {
                                  // Register logic here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Successfully Registered!'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please accept Terms and Privacy Policy.'),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Register Now!',
                                style: TextStyle(
                                  fontFamily:
                                      'Baloo', // Used for headings and titles
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
