import 'package:flutter/material.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/termspage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'BalsamiqSans'),
      home: Scaffold(
        body: ListView(
          children: [
            const SettingsScreen(),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar section
        Container(
          width: double.infinity,
          height: 80,
          color: AppStyles.primaryColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                ),
                Text(
                  'Settings',
                  style: AppStyles.headingStyle.copyWith(
                    fontFamily: 'Baloo', // Headings and Titles
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),

        // Settings options
        Container(
          padding: AppStyles.defaultPadding,
          color: AppStyles.backgroundColor,
          child: Column(
            children: [
              buildSettingsItem(
                icon: Icons.person_outline,
                title: "Account Settings",
                trailing:
                    const Icon(Icons.chevron_right, color: AppStyles.textColor),
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
                  activeColor: AppStyles.whiteColor,
                  activeTrackColor: AppStyles.secondaryColor,
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: AppStyles.whiteColor,
                ),
              ),
              buildDivider(),
              buildSettingsItem(
                icon: Icons.history,
                title: "Transaction History",
                trailing:
                    const Icon(Icons.chevron_right, color: AppStyles.textColor),
                onTap: () {
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
                trailing:
                    const Icon(Icons.chevron_right, color: AppStyles.textColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionsPage(
                        onAccept: () {
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
    );
  }

  // Build individual settings items
  Widget buildSettingsItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppStyles.secondaryColor, size: 28),
      title: Text(
        title,
        style: AppStyles.bodyStyle.copyWith(
          fontFamily: 'BalsamiqSans', // Body text and subtitles
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  // Divider styling
  Widget buildDivider() {
    return const Divider(
      color: AppStyles.secondaryColor,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
