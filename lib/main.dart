import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soltalk/data/provider/user_provider.dart';
import 'package:soltalk/firebase_options.dart';
import 'package:soltalk/ui/screens/chat_screen.dart';
import 'package:soltalk/ui/screens/login_screen.dart';
import 'package:soltalk/ui/screens/matched_screen.dart';
import 'package:soltalk/ui/screens/register_screen.dart';
import 'package:soltalk/ui/screens/splash_screen.dart';
import 'package:soltalk/ui/screens/start_screen.dart';
import 'package:soltalk/ui/screens/top_navigation_screen.dart';
import 'package:soltalk/util/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MyApp());
}

void init() async {

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance
      // Your personal reCaptcha public key goes here:
      .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    //webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: 
        
        ThemeData(
          fontFamily: kFontFamily,
          colorScheme: ColorScheme.fromSwatch(
          accentColor: kSecondaryColor,
        ),
        
          //accentColor: kSecondaryColor,
          //buttonColor: kAccentColor,
          highlightColor: kAccentColor,
          indicatorColor: kAccentColor,
          primarySwatch:
          const MaterialColor(kBackgroundColorInt, kThemeMaterialColor),
          scaffoldBackgroundColor: kPrimaryColor,
          hintColor: kSecondaryColor,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ).apply(
            bodyColor: kSecondaryColor,
            displayColor: kSecondaryColor,
          ),
          buttonTheme: const ButtonThemeData(
            splashColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 14),
            buttonColor: kAccentColor,
            textTheme: ButtonTextTheme.accent,
            highlightColor: Color.fromRGBO(0, 0, 0, .3),
            focusColor: Color.fromRGBO(0, 0, 0, .3),
          ),
        )
        /*ThemeData(
         
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          
          useMaterial3: true,
        )*/,
      initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          StartScreen.id: (context) => const StartScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          TopNavigationScreen.id: (context) => TopNavigationScreen(),
          MatchedScreen.id: (context) => MatchedScreen(
            myProfilePhotoPath: (ModalRoute.of(context)!.settings.arguments
            as Map)['my_profile_photo_path'],
            myUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['my_user_id'],
            otherUserProfilePhotoPath: (ModalRoute.of(context)!
                .settings
                .arguments as Map)['other_user_profile_photo_path'],
            otherUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['other_user_id'],
          ),
          ChatScreen.id: (context) => ChatScreen(
            chatId: (ModalRoute.of(context)!.settings.arguments
            as Map)['chat_id'],
            otherUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['other_user_id'],
            myUserId: (ModalRoute.of(context)!.settings.arguments
            as Map)['user_id'],
          ),
        },
      ),
    );
  }
}