import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gloom/auth/login_page.dart';
import 'package:gloom/helper/helper_functions.dart';
import 'package:gloom/pages/home_page.dart';
import 'package:gloom/pages/admin_home_page.dart'; // Import Admin Home Page
import 'package:gloom/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedin = false;
  bool isAdmin = false; // Track if user is admin

  @override
  void initState() {
    super.initState();
    getuserloggedinstatus();
  }

  getuserloggedinstatus() async {
    await HelperFunctions.userloggedinstatus().then((value) async {
      if (value != null && value) {
        setState(() {
          isSignedin = true;
        });
        // Check if user email is admin@gmail.com
        String? email = await HelperFunctions.getuseremail();
        if (email == "admin@gmail.com") {
          setState(() {
            isAdmin = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isSignedin
          ? (isAdmin ? Admin_HomePage() : HomePage()) // Conditional navigation
          : LoginPage(),
    );
  }
}
