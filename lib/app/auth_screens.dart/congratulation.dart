import 'package:assignment_flutter_app/app/bottom_nav.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratScreen extends StatefulWidget {
  const CongratScreen({super.key});

  @override
  State<CongratScreen> createState() => _CongratScreenState();
}

class _CongratScreenState extends State<CongratScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the next screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(
              currentIndex: 0,
            ),
          ),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image(
              image: const AssetImage(
                'assets/auth/congrats.gif',
              ),
              fit: BoxFit.contain,
              width: size.width * 0.4,
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              'Congratulations',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You have successfully registered On',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(101, 101, 100, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
                height: size.height * 0.13,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon.png', width: size.width * 0.09),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      "Product App",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: MyColors.green,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
