import 'package:assignment_flutter_app/app/auth_screens.dart/congratulation.dart';
import 'package:assignment_flutter_app/app/auth_screens.dart/login_screen.dart';
import 'package:assignment_flutter_app/app/bottom_nav.dart';
import 'package:assignment_flutter_app/services/api_value.dart';
import 'package:assignment_flutter_app/utils/constant.dart';
import 'package:assignment_flutter_app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: size.height,
          height: size.height,
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          decoration: BoxDecoration(
            color: MyColors.dullBlue,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 30, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Register",
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/icon.png',
                        width: size.width * 0.08,
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: MyColors.green),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: MyColors.green,
                      size: 80,
                    ),
                  ),
                ),
                //---------------------------------------name--------------------------------//
                textfieldBuilder(
                    _nameController, 'Name', Icons.person_2, false),

                //---------------------------------------email--------------------------------//
                textfieldBuilder(_emailController, 'Email',
                    Icons.mail_outline_rounded, false),

                //---------------------------------------mobile--------------------------------//
                textfieldBuilder(
                    _mobileController, 'Mobile no.', Icons.phone_rounded, true),

                //---------------------------------------password--------------------------------//
                textfieldBuilder(_passwordController, 'Password',
                    Icons.lock_open_outlined, false),

                //---------------------------------------confirm password--------------------------------//
                textfieldBuilder(_confirmPasswordController, 'Confirm password',
                    Icons.lock_clock_outlined, false),

                //---------------------------------------button--------------------------------//

                Padding(
                  padding: EdgeInsets.only(
                      left: 60, right: 60, top: size.height * 0.05),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.green,
                      disabledBackgroundColor: MyColors.green,
                      minimumSize: const Size(double.infinity, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_nameController.text.isEmpty) {
                              toast('Enter name');
                            } else if (_emailController.text.isEmpty) {
                              toast('Enter email address');
                            } else if (!_emailController.text.contains('@')) {
                              toast('Enter correct email address');
                            } else if (_mobileController.text.isEmpty) {
                              toast('Enter mobile number');
                            } else if (_mobileController.text.length != 10) {
                              toast('Invalid mobile number');
                            } else if (_passwordController.text.isEmpty) {
                              toast('Enter password');
                            } else if (_passwordController.text.length < 6) {
                              toast('Weak password');
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              toast("Confirm password does't match");
                            } else {
                              setState(() {
                                isLoading = true;
                              });

                              var registerResponse = await apiValue.register(
                                _nameController.text,
                                _emailController.text,
                                _mobileController.text,
                                _passwordController.text,
                              );

                              if (registerResponse != null) {
                                if (registerResponse['title'] ==
                                    'Congratulations!') {
                                  SharedPreferencesHelper.setIsLoggedIn(
                                      isLoggedIn: true);

                                  SharedPreferencesHelper.settoken(
                                    token: registerResponse['data']
                                        ['user_token'],
                                  );
                                  SharedPreferencesHelper.setId(
                                    id: registerResponse['data']['id']
                                        .toString(),
                                  );
                                  SharedPreferencesHelper.setName(
                                    name: registerResponse['data']['name'],
                                  );
                                  SharedPreferencesHelper.setUserPhone(
                                    userPhone: registerResponse['data']
                                        ['mobile'],
                                  );
                                  SharedPreferencesHelper.setUserEmail(
                                    userEmail: registerResponse['data']
                                        ['email'],
                                  );

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CongratScreen(),
                                      ),
                                      (route) => false);

                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  toast(registerResponse['message']);
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
                            'Register',
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
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
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
                              child: const LoginScreen(),
                              childCurrent: widget,
                            ),
                          );
                        },
                        child: Text(
                          "Login",
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
        ),
      ),
    );
  }

  Widget textfieldBuilder(
      controller, String hintText, IconData icon, bool isphone) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 40,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            keyboardType: isphone ? TextInputType.number : TextInputType.text,
            inputFormatters: isphone
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : [],
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
              prefixIcon: Icon(icon),
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
