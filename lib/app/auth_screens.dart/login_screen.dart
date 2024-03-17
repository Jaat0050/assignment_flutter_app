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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  height: size.height,
                  decoration: BoxDecoration(
                    color: MyColors.dullBlue,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
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
                      SizedBox(height: size.height * 0.05),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 15),
                            contentPadding: const EdgeInsets.all(0),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(Icons.mail_outline_rounded)),
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 15),
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.lock_open_outlined),
                        ),
                      ),
                      SizedBox(height: size.height * 0.16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_emailController.text.isEmpty) {
                                      toast('Enter email address');
                                    } else if (!_emailController.text
                                        .contains('@')) {
                                      toast('Enter correct email address');
                                    } else if (_passwordController
                                        .text.isEmpty) {
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
                                            userEmail: _emailController.text
                                                .toString(),
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
                                          SharedPreferencesHelper.setUserEmail(
                                            userEmail: _emailController.text
                                                .toString(),
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftJoined,
                                              child: const RegisterScreen(),
                                              childCurrent: widget,
                                            ),
                                          );
                                        }
                                      } else {
                                        toast('Something went wrong');
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
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
              ],
            ),
          ),
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