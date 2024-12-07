import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawlah/login/login_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:jawlah/api/api_connect_method.dart';

import 'package:jawlah/personal_account/edit_profile.dart';
import 'package:jawlah/suggestions/show_all_suggestions.dart';

import 'package:jawlah/public/alert_dialog.dart';
import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

class NewSuggestion extends StatefulWidget {
  const NewSuggestion({Key? key}) : super(key: key);
  @override
  _NewSuggestion createState() => _NewSuggestion();
}

class _NewSuggestion extends State<NewSuggestion> {
  final globleFormKey = GlobalKey<FormState>();

  final TextEditingController _c_title = TextEditingController();
  final TextEditingController _c_content = TextEditingController();

  bool validate = false;
  bool circular = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#94A65D"),
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
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/suggestions.gif",
                    width: 210.0,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              bottom: 15,
              top: 15,
            ),
            child: Center(
              child: Text(
                "اقتراح جديد",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
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
                controller: _c_title,
                validator: (value) {
                  if (value!.isEmpty) return "title can't be empty";
                  return null;
                },
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: "العنوان",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  errorText: validate ? null : errorText,
                  suffixIcon: const Icon(Icons.title, color: Color(0xFFFFFFFF)),
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
              height: 140,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.right,
                controller: _c_content,
                maxLines: null, // Set maxLines to null for multiline support
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: "المحتوى",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  suffixIcon: IconButton(
                    //suffixIcon ==> at right direction
                    onPressed: () {},
                    icon: const Icon(Icons.textsms, color: Color(0xFFFFFFFF)),
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
                    "ارسال",
                    () async {
                      if (_c_title.text.isEmpty) {
                        setState(() {
                          // circular = false;
                          validate = false;
                          errorText = "title Can't be empty";
                        });
                        return;
                      }

                      if (_c_content.text == "") {
                        showAlertDialog(
                            context, "Check content!", "Your content is empty");
                        return;
                      }

                      Map<String, dynamic> responseList =
                          await api_connect_post_request({
                        "action": "new_suggestion",
                        "title": _c_title.text,
                        "content": _c_content.text,
                        "user_id": globals.current_user_id
                      });

                      if (responseList["status"] == "succeed") {
                        //Navigator.pop(context);//close current screen this will prevent return to it
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowAllSuggestionsPage()));
                      } else if (responseList["status"] == "failed") {
                        showAlertDialog(context, "تنبيه", responseList["body"]);
                      } else {
                        showAlertDialog(context, "خطأ", "غير معروف");
                      }
                    },
                    btnColor: Colors.white,
                    borderColor: HexColor("#7d913f"),
                    txtColor: HexColor("#7d913f"),
                    borderRadius: 30,
                    width: 355,
                  ),
                ),
          const SizedBox(
            height: 33,
          ),
        ],
      ),
    );
  }
}
