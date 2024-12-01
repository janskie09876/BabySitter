import 'package:babysitter/account-ratingandreviewpage-terms/termspage.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/home-paymentpage/dashboard_nanny.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:flutter/material.dart';

class BabySettings extends StatelessWidget {
  const BabySettings({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'BalsamiqSans', // Set the default body font
      ),
      home: Scaffold(
        body: ListView(children: [
          Settings6DelaCerna(),
        ]),
      ),
    );
  }
}

class Settings6DelaCerna extends StatefulWidget {
  @override
  _Settings6DelaCernaState createState() => _Settings6DelaCernaState();
}

class _Settings6DelaCernaState extends State<Settings6DelaCerna> {
  bool isNotificationsEnabled = true; // Default is ON

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 430,
          height: 932,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFFFFDEDE)),
          child: Stack(
            children: [
              // AppBar-like container with back arrow and centered "Settings" title
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 430,
                  height: 120,
                  decoration: const BoxDecoration(color: Color(0xFFFFDEDE)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            // Navigate explicitly back to the Dashboard page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DashboardNanny(), // babysitter Dashboard page
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'Baloo', // Title font (Baloo)
                            color: Color(0xFF424242),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 48), // Placeholder for alignment
                      ],
                    ),
                  ),
                ),
              ),
              // Menu items
              Positioned(
                top: 130, // Spaced below the title
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    buildSettingsItem(
                      icon: Icons.person_outline,
                      title: "Account Settings",
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xFF424242)),
                    ),
                    buildDivider(),
                    buildSettingsItem(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                      trailing: Switch(
                        value: isNotificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            isNotificationsEnabled = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFFF48FB1),
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                      ),
                    ),
                    buildDivider(),
                    buildSettingsItem(
                      icon: Icons.history,
                      title: "Transaction History",
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xFF424242)),
                      onTap: () {
                        // Navigate to Transaction History page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionHistoryPage(),
                          ),
                        );
                      },
                    ),
                    buildDivider(),
                    buildSettingsItem(
                      icon: Icons.description_outlined,
                      title: "Terms and Conditions",
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xFF424242)),
                      onTap: () {
                        // Navigate to Terms and Conditions page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndConditionsPage(
                              onAccept: () {
                                // Action when terms are accepted
                                print("Terms accepted");
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSettingsItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap, // Add an optional onTap for handling item clicks
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFE3838E),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'BalsamiqSans', // Body font (Balsamiq Sans)
          color: Color(0xFF424242),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: trailing,
      onTap: onTap, // Handle the tap event
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: Color(0xFFE3838E),
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
