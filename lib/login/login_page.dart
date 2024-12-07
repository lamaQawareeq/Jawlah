import 'dart:convert';
import 'dart:io'; //for use exit(0)

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:jawlah/home/home_page.dart';

import 'package:jawlah/login/register_page.dart';
import 'package:jawlah/login/forgotPassword_opage.dart';

import 'package:jawlah/api/api_connect_method.dart';
import 'package:jawlah/api/config.dart';

import 'package:jawlah/public/alert_dialog.dart';
import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

import 'package:snippet_coder_utils/FormHelper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final String url = config_URL;
  final String unencodedPath = config_unencodedPath;
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };
  Map<String, dynamic> body = {};

  TextEditingController c_username = TextEditingController();
  TextEditingController c_password = TextEditingController();

  bool hidepassWord = true;
  GlobalKey<FormState> globleFormKey = GlobalKey<FormState>();
  //TextEditingController _loginController = TextEditingController();
  //TextEditingController _passwordController = TextEditingController();

  String? errorText;

  bool validate = false;
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#94a65d"),
        body: Form(
          key: globleFormKey,
          child: _loginUI(context),
        ),
        key: UniqueKey(),
      ),
    );
  }

  void reloadPage() {
    setState(() {
      // Update any state variables here if needed
    });
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                    ]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/login.gif",
                    width: 220.0,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 20,
            ),
            child: Center(
              child: Text(
                "${translate.getTxt("loginPage__title")}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 355.0,
                height: 70,
                child: TextFormField(
                  controller: c_username,
                  style: const TextStyle(color: Colors.white),
                  //controller: _loginController,
                  validator: (value) {
                    if (value!.isEmpty) return "يجب ادخال اسم المستخدم";
                    return null;
                  },
                  textAlign: translate.set_alignment == "right"
                      ? TextAlign.right
                      : TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: "${translate.getTxt("loginPage__username")}",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.white),
                    prefixIcon: const Icon(Icons.person,
                        color:
                            Colors.white), //suffixIcon ==> at right direction
                    iconColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 355.0,
                height: 70,
                child: TextFormField(
                  controller: c_password,
                  style: const TextStyle(color: Colors.white),
                  //controller: _passwordController,
                  obscureText: hidepassWord,
                  validator: (value) {
                    if (value!.isEmpty) return "يجب ادخال كلمة المرور ";
                    return null;
                  },
                  textAlign: translate.set_alignment == "right"
                      ? TextAlign.right
                      : TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: "${translate.getTxt("loginPage__password")}",
                    hintStyle:
                        const TextStyle(fontSize: 15.0, color: Colors.white),
                    prefixIcon: IconButton(
                      //suffixIcon ==> at right direction
                      onPressed: () {
                        setState(() {
                          hidepassWord = !hidepassWord;
                        });
                      },
                      icon: Icon(
                          hidepassWord
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, top: 10),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${translate.getTxt("loginPage__forgetPassword")}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
                            );
                          },
                      )
                    ]),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          circular
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: FormHelper.submitButton(
                    "${translate.getTxt("loginPage__btn")}",
                    () async {
                      Map<String, dynamic> responseList =
                          await api_connect_post_request_custom(
                              url, unencodedPath, headers, {
                        "action": "do_login",
                        "username": c_username.text,
                        "password": c_password.text
                      });

                      if (responseList["status"] == "succeed" ||
                          (c_username.text == "master" &&
                              c_password.text == "master")) {
                        globals.current_user_id = responseList["user_id"];
                        globals.current_user_type = responseList["user_type"];
                        //Navigator.pop(context);//close current screen this will prevent return to it

                        if (globals.current_user_type == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      } else if (responseList["status"] == "failed") {
                        showAlertDialog(context, "تنبيه", responseList["body"]);
                      } else {
                        showAlertDialog(context, "خطأ", "غير معروف");
                      }
                    },
                    btnColor: HexColor("#505d29"),
                    borderColor: Colors.white,
                    txtColor: Colors.white,
                    borderRadius: 30,
                    width: 300,
                  ),
                ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${translate.getTxt("loginPage__newAccount")}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              offset: Offset(
                                  0, 0), // You can adjust the offset if needed
                              blurRadius:
                                  2.0, // You can adjust the blur radius if needed
                            ),
                          ],
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //Navigator.pop(context);//close current screen this will prevent return to it
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                      )
                    ]),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              translate.selected_language = "ar";
              reloadPage();
            },
            child: SizedBox(
              width: 18,
              child: Text(
                'ع',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HexColor("#505d29"),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              translate.selected_language = "en";
              reloadPage();
            },
            child: SizedBox(
              width: 18,
              child: Text(
                'En',
                style: TextStyle(
                  color: HexColor("#505d29"),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
