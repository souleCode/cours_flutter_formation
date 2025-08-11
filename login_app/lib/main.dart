import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/firebase_options.dart';
import 'package:login_app/pages/sign_in.dart';
import 'package:login_app/pages/sign_up.dart';
import 'package:login_app/pages/spash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: SplashScreen(),
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const SplashScreen(),
      },
    );
  }
}
