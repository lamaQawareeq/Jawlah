import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawlah/login/login_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:jawlah/api/api_connect_method.dart';

import 'package:jawlah/personal_account/edit_profile.dart';

import 'package:jawlah/public/alert_dialog.dart';
import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  bool hidepassWord = true;
  bool hiderepassWord = true;

  final globleFormKey = GlobalKey<FormState>();
  bool vis = true;
  final TextEditingController _c_loginname = TextEditingController();
  final TextEditingController _c_password = TextEditingController();
  final TextEditingController _c_repassword = TextEditingController();

  bool validate = false;
  bool circular = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#94a65d"),
        body: Form(
          key: globleFormKey,
          child: _registerUI(context),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
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
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/signup.png",
                    width: 280.0,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: Center(
              child: Text(
                "${translate.getTxt("register_page__title")}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 355.0,
              height: 70,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _c_loginname,
                validator: (value) {
                  if (value!.isEmpty) return "loginname can't be empty";
                  return null;
                },
                textAlign: translate.set_alignment == "right"
                    ? TextAlign.right
                    : TextAlign.left,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: "${translate.getTxt("register_page__loginname")}",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  errorText: validate ? null : errorText,
                  suffixIcon: const Icon(Icons.person),
                  iconColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 355.0,
              height: 70,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                textAlign: translate.set_alignment == "right"
                    ? TextAlign.right
                    : TextAlign.left,
                obscureText: hidepassWord,
                controller: _c_password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: "${translate.getTxt("register_page__password")}",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  suffixIcon: IconButton(
                    //suffixIcon ==> at right direction
                    onPressed: () {
                      setState(() {
                        hidepassWord = !hidepassWord;
                      });
                    },
                    icon: Icon(
                        hidepassWord ? Icons.visibility_off : Icons.visibility),
                  ),
                  iconColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 355.0,
              height: 70,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                textAlign: translate.set_alignment == "right"
                    ? TextAlign.right
                    : TextAlign.left,
                obscureText: hiderepassWord,
                controller: _c_repassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: "${translate.getTxt("register_page__repassword")}",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  suffixIcon: IconButton(
                    //prefixIcon ==> at left direction
                    onPressed: () {
                      setState(() {
                        hiderepassWord = !hiderepassWord;
                      });
                    },
                    icon: Icon(hiderepassWord
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  iconColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                ),
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
                    "${translate.getTxt("register_page__title")}",
                    () async {
                      if (_c_loginname.text.isEmpty) {
                        setState(() {
                          // circular = false;
                          validate = false;
                          errorText = "loginname Can't be empty";
                        });
                        return;
                      }

                      if (_c_password.text != _c_repassword.text) {
                        showAlertDialog(context, "Check Password!",
                            "Your password is not equal");
                        return;
                      }

                      Map<String, dynamic> responseList =
                          await api_connect_post_request({
                        "action": "do_signup",
                        "loginname": _c_loginname.text,
                        "password": _c_password.text
                      });

                      if (responseList["status"] == "succeed") {
                        globals.current_user_id = responseList["user_id"];
                        //Navigator.pop(context);//close current screen this will prevent return to it
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );
                      } else if (responseList["status"] == "failed") {
                        showAlertDialog(context, "تنبيه", responseList["body"]);
                      } else {
                        showAlertDialog(context, "خطأ", "غير معروف");
                      }
                    },
                    btnColor: HexColor("#7E953A"),
                    borderColor: Colors.white,
                    txtColor: Colors.white,
                    borderRadius: 30,
                    width: 300,
                  ),
                ),
          const SizedBox(
            height: 33,
          ),
          Center(
              child: Text(
            "${translate.getTxt("register_page__toToLogin")}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          )),
          /*SizedBox(
                      height: 20,
                    ),*/
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 5),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${translate.getTxt("register_page__login")}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
