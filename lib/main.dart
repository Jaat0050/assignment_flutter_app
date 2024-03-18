import 'dart:developer';

import 'package:assignment_flutter_app/app/auth_screens.dart/onboarding_screen.dart';
import 'package:assignment_flutter_app/app/bottom_nav.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

var box;
bool? isLoggedIn = false;
bool? isFirstTime = true;

void main() async {
  try {
    await _initializePrefs();
  } catch (e) {
    log(e.toString());
  }
  await Hive.initFlutter().then((value) async {
    await Hive.openBox('myBox').then((value) => box = Hive.box('myBox'));
  });

  runApp(const MyApp());
}

Future<void> _initializePrefs() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: MyColors.green,
    statusBarIconBrightness: Brightness.light,
  ));
  await SharedPreferencesHelper.init();
  isFirstTime = SharedPreferencesHelper.getisFirstTime();
  isLoggedIn = SharedPreferencesHelper.getIsLoggedIn();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Product App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: false,
          ),
          home: child,
        );
      },
      child: Scaffold(
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            backgroundColor: const Color(0xffF3F5F7),
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              const StadiumBorder(),
              0.2,
            )!,
            width: 200,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'double tap to exit app',
              style: TextStyle(
                color: MyColors.green,
              ),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 1),
          ),
          child: SharedPreferencesHelper.getisFirstTime() == true
              ? const OnBoardingScreen()
              : BottomNav(
                  currentIndex: 0,
                ),

          // child: OnBoardingScreen(),
        ),
      ),
    );
  }
}
