import 'package:assignment_flutter_app/app/auth_screens.dart/login_screen.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.dullWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            Text(
              ' Profile',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: MyColors.dullWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.person,
                color: MyColors.green,
                size: 120,
              ),
            ),

            const SizedBox(height: 10),
            //-----------------------------------------name-------------------------------------------//

            textRowBuilder('Full Name', SharedPreferencesHelper.getName()),

            //-----------------------------------------phone-------------------------------------------//

            textRowBuilder(
                'Phone no.', "+91 ${SharedPreferencesHelper.getUserPhone()}"),

            //-----------------------------------------email-------------------------------------------//

            textRowBuilder(
                'Email address', SharedPreferencesHelper.getUserEmail()),

            //-----------------------------------------button------------------------------------------//

            SizedBox(height: size.height * 0.3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.green,
                    disabledBackgroundColor: MyColors.green,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (SharedPreferencesHelper.getIsLoggedIn()) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const SuccessDialogBox();
                          });
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false);
                    }
                  },
                  child: Text(
                    SharedPreferencesHelper.getIsLoggedIn()
                        ? 'Logout'
                        : 'Login',
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textRowBuilder(String text1, String text2) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.3,
                child: Text(
                  text1,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(122, 122, 122, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.5,
                child: Text(
                  text2,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }
}

class SuccessDialogBox extends StatefulWidget {
  const SuccessDialogBox({super.key});

  @override
  SuccessDialogBoxState createState() => SuccessDialogBoxState();
}

class SuccessDialogBoxState extends State<SuccessDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Log out',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "DM_Sans",
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(88, 88, 88, 0.68),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "DM_Sans",
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(27, 27, 27, 1),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            border: Border.all(
                              color: MyColors.green,
                            ),
                          ),
                          width: 79,
                          height: 32,
                          child: Center(
                            child: Text(
                              "Go back",
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferencesHelper.clearShareCache();

                        SharedPreferencesHelper.setIsLoggedIn(
                            isLoggedIn: false);
                        SharedPreferencesHelper.setisFirstTime(
                            isFirstTime: false);

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);
                        setState(() {});
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: MyColors.green,
                          ),
                          width: 79,
                          height: 32,
                          child: Center(
                            child: Text(
                              "Logout",
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ],
    );
  }
}
