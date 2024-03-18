// ignore_for_file: use_build_context_synchronously
import 'package:assignment_flutter_app/app/auth_screens.dart/register.dart';
import 'package:assignment_flutter_app/app/bottom_nav.dart';
import 'package:assignment_flutter_app/services/api_value.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height * 0.32,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.12,
                      ),
                      Image.asset(
                        'assets/icon.png',
                        width: size.width * 0.3,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: size.height,
                  decoration: BoxDecoration(
                    color: MyColors.dullBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10, bottom: size.height * 0.05, top: 30),
                        child: Text(
                          "Login",
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: MyColors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      //---------------------------------------email--------------------------------//
                      textfieldBuilder(_emailController, 'Email',
                          Icons.mail_outline_rounded),

                      //---------------------------------------password--------------------------------//
                      textfieldBuilder(_passwordController, 'Password',
                          Icons.lock_open_outlined),

                      //---------------------------------------button--------------------------------//

                      Padding(
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: size.height * 0.1),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.green,
                            disabledBackgroundColor: MyColors.green,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (_emailController.text.isEmpty) {
                                    toast('Enter email address');
                                  } else if (!_emailController.text
                                      .contains('@')) {
                                    toast('Enter correct email address');
                                  } else if (_passwordController.text.isEmpty) {
                                    toast('Enter password');
                                  } else if (_passwordController.text.length <
                                      6) {
                                    toast('Weak password');
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    var loginResponse = await apiValue.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    if (loginResponse != null) {
                                      if (loginResponse['title'] ==
                                          'Logged In!') {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        SharedPreferencesHelper.setIsLoggedIn(
                                            isLoggedIn: true);

                                        SharedPreferencesHelper.settoken(
                                          token: loginResponse['data']
                                              ['user_token'],
                                        );
                                        SharedPreferencesHelper.setId(
                                          id: loginResponse['data']['id'],
                                        );
                                        SharedPreferencesHelper.setName(
                                          name: loginResponse['data']['name'],
                                        );
                                        SharedPreferencesHelper.setUserPhone(
                                          userPhone: loginResponse['data']
                                              ['mobile'],
                                        );
                                        SharedPreferencesHelper.setUserEmail(
                                          userEmail: loginResponse['data']
                                              ['email'],
                                        );

                                        Navigator.popUntil(
                                            context, (route) => false);
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .rightToLeftJoined,
                                            child: BottomNav(currentIndex: 0),
                                            duration: const Duration(
                                                milliseconds: 900),
                                            reverseDuration: const Duration(
                                                milliseconds: 400),
                                            childCurrent: widget,
                                          ),
                                        );
                                      } else {
                                        toast(loginResponse['message']);
                                      }
                                    } else {
                                      toast('Something went wrong');
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                          child: isLoading
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.rubik(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeftJoined,
                                    child: const RegisterScreen(),
                                    childCurrent: widget,
                                  ),
                                );
                              },
                              child: Text(
                                "Register",
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: MyColors.green,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textfieldBuilder(controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          contentPadding: const EdgeInsets.all(0),
          isDense: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  void toast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: MyColors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
