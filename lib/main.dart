import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/bottomnav.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/screen/splash_screen.dart';


// import 'screen/inventory_screen.dart';
// import 'screen/daily_check_screen.dart';
// import 'screen/daily_month_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    final apiKey = dotenv.env['API_KEY']!;
    final authDomain = dotenv.env['AUTH_DOMAIN']!;
    final projectId = dotenv.env['PROJECT_ID']!;
    final storageBucket = dotenv.env['STORAGE_BUCKET']!;
    final messagingSenderId = dotenv.env['MESSAGING_SENDER_ID']!;
    final appId = dotenv.env['APP_ID']!;
    final measurementId = dotenv.env['MEASUREMENT_ID']!;

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: apiKey,
        authDomain: authDomain,
        projectId: projectId,
        storageBucket: storageBucket,
        messagingSenderId: messagingSenderId,
        appId: appId,
        measurementId: measurementId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   androidProvider: AndroidProvider.debug,
  // );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
