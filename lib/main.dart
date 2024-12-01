import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/editparentprofile.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/privacypolicy.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/rateandreview.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/registrationpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/review.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/reviewratings.dart';
import 'package:babysitter/firebase_options.dart';
import 'package:babysitter/home-paymentpage/babysitter_payment_confirmation.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/home-paymentpage/dashboard_nanny.dart';
import 'package:babysitter/home-paymentpage/gpay2_page.dart';
import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:babysitter/register-settingspage/registration.dart';
import 'package:babysitter/notifications-stylepage/notification_utils.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/requirement-babysitterprofilepage/view_babysitter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login-bookingrequestpage/welcome_back.dart';
import 'package:babysitter/pages/map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationUtils.initializeFCM(); // Uncommented if needed
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}
