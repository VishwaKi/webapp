// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sunteknolozy/Screens/Homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //textfieldcontrollers
  TextEditingController email = TextEditingController();

  TextEditingController passcode = TextEditingController();
  //checking password visibility
  bool _isVisible = true;

  //regex validation for password
  final RegExp passwordregex = RegExp(
      r'^\S*(?=\S{6,})(?=\S*\d)(?=\S*[A-Z])(?=\S*[a-z])(?=\S*[!@#$%^&*? ])\S*$');

  //dispose
  @override
  void dispose() {
    // TODO: implement dispose

    email.dispose();
    passcode.dispose();
    super.dispose();
  }

  //store the login time value
  //login time
  void Logintime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('loginHours')) {
      prefs.setInt('loginHours', DateTime.now().hour);
      prefs.setInt('loginMinutes', DateTime.now().minute);
      prefs.setInt('loginSeconds', DateTime.now().second);
      prefs.setString('loginTime', DateTime.now().toString());
    }
  }

  //for validate login credentials
  void Loginvalidation() {
    if (email.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email is required",
        snackPosition: SnackPosition.TOP,
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: Get.width * 0.713),
      );
    } else if (passcode.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Passcode is required",
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: Get.width * 0.713),
      );
    } else if (passcode.text.length > 8 || passcode.text.length < 8) {
      Get.snackbar(
        "Error",
        "Passcode must be 8 characters",
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: Get.width * 0.713),
      );
    } else if (!passwordregex.hasMatch(passcode.text)) {
      Get.snackbar(
        "Error",
        "Passcode must have Uppercase,lowercase,special characters,numbers ",
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: Get.width * 0.713),
      );
    } else if (!email.text.isEmail) {
      Get.snackbar(
        "Error",
        "Enter a valid Email Id",
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: Get.width * 0.713),
      );
    } else {
      // email.text = '';
      // passcode.text = '';
      Get.snackbar(
        "Success",
        "Login Successful",
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: Get.width * 0.713),
      );
      Logintime();
      Get.toNamed(
        '/home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.purple, width: 3),
                borderRadius: BorderRadius.circular(6)),
            width: Get.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 10,
                  ),
                  child: SizedBox(
                    height: Get.height * 0.45,
                    width: Get.width * 0.3,
                    child: Stack(
                      children: [
                        Container(
                          height: Get.height * 0.47,
                        ),
                        //1
                        Positioned(
                          top: 15,
                          left: Get.width * 0.35,
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: HexColor("b7efc2"),
                          ),
                        ),
                        //2
                        Positioned(
                          top: 80,
                          left: Get.width * 0.14,
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: HexColor("dcd1fc"),
                          ),
                        ),
                        //3
                        Positioned(
                          top: 85,
                          left: 20,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: HexColor("ffe8a5"),
                          ),
                        ),
                        //4
                        Positioned(
                          top: Get.height * 0.285,
                          left: Get.width * 0.2,
                          child: CircleAvatar(
                            radius: 53,
                            backgroundColor: HexColor("dcd1fc"),
                          ),
                        ),
                        //5
                        Positioned(
                          top: 200,
                          left: Get.width * 0.085,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: HexColor("b7efc2"),
                          ),
                        ),
                        Positioned(
                          top: 200,
                          left: Get.width * 0.085,
                          child: const Image(
                            image: AssetImage("images/6.png"),
                            width: 130,
                          ),
                        ),
                        Positioned(
                          top: 95,
                          left: Get.width * 0.146,
                          child: const Image(
                            image: AssetImage("images/1.png"),
                            width: 73,
                          ),
                        ),
                        const Positioned(
                          top: 90,
                          left: 17,
                          child: Image(
                            image: AssetImage("images/5.png"),
                            width: 130,
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.277,
                          left: Get.width * 0.198,
                          child: const Image(
                            image: AssetImage("images/7.png"),
                            width: 125,
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.297,
                          left: Get.width * 0.574,
                          child: const Image(
                            image: AssetImage("images/2.png"),
                            width: 125,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    height: Get.height * 0.43,
                    width: Get.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Let's Get",
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff000000),
                          ),
                        ),
                        Text(
                          "Started",
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff000000),
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Text(
                          "Get ready to connect and share your\ninterests with a community of peoples",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Welcome back! 👋 💜\nGlad to see you again here!",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: Get.height * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.purple, width: 3),
                        borderRadius: BorderRadius.circular(6)),
                    width: Get.width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.06,
                          ),
                          Container(
                            height: 56,
                            decoration: ShapeDecoration(
                              color: HexColor("F7F7F7"),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.50,
                                  color: Colors.black
                                      .withOpacity(0.17000000178813934),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: email,
                              decoration: InputDecoration(
                                hintText: 'Email Id',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black
                                      .withOpacity(0.5400000214576721),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.5400000214576721),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            height: 56,
                            decoration: ShapeDecoration(
                              color: HexColor("f7f7f7"),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.50,
                                  color: Colors.black
                                      .withOpacity(0.17000000178813934),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: passcode,
                              keyboardType: TextInputType.text,
                              obscureText: _isVisible,
                              decoration: InputDecoration(
                                hintText: 'Passcode',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black
                                      .withOpacity(0.5400000214576721),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => setState(() {
                                    _isVisible = !_isVisible;
                                  }),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.5400000214576721),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color.fromARGB(255, 112, 110, 110),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              Loginvalidation();
                            },
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                color: HexColor("9979fc"),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      )),
    );
  }
}
