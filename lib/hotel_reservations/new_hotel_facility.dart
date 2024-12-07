import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:jawlah/login/login_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:http/http.dart' as http;

import 'package:jawlah/api/api_connect_method.dart';
import 'package:jawlah/api/config.dart';

import 'package:jawlah/api/api_connect_method.dart';

import 'package:jawlah/hotel_reservations/show_all_hotel_facilities.dart';

import 'package:jawlah/models/hotel_facility_model.dart';

import 'package:jawlah/public/alert_dialog.dart';
import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

import 'package:jawlah/bottom_bar/bottomBar_static.dart';

Future<Ui_hotel_facility> create_thisPage_Model(
    final int hotelReservationId) async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(config_URL, config_unencodedPath);
  } else {
    uri = Uri.http(config_URL, config_unencodedPath);
  }

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      "action": "show_hotel_facility_ui_data",
      "hotel_reservation_id": hotelReservationId,
      "user_id": globals.current_user_id
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    //List<UserModel> users = (json.decode(response.body) as List)
    // .map((data) => UserModel.fromJson(data))
    // .toList();
    dynamic jsonD = jsonDecode(response.body);
    Ui_hotel_facility hotelUi = Ui_hotel_facility.fromJson(jsonD['dataView']);

    return hotelUi;
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create hotel_facility_ui .');
  }
}

class Newhotel_facility extends StatefulWidget {
  final int hotel_reservation_id;
  const Newhotel_facility({Key? key, required this.hotel_reservation_id})
      : super(key: key);

  @override
  State<Newhotel_facility> createState() {
    return _Newhotel_facilitiestate(hotel_reservation_id: hotel_reservation_id);
  }
}

class _Newhotel_facilitiestate extends State<Newhotel_facility> {
  final TextEditingController _controller = TextEditingController();

  final int hotel_reservation_id;
  _Newhotel_facilitiestate({required this.hotel_reservation_id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: footer(context),
        body: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: const [
            Color(0xFFECF7EA),
            Color(0xFF94a65d),
          ], begin: Alignment.topCenter, end: Alignment.center)),
          child: buildFutureBuilder(),
        ),
      ),
    );
  }

  FutureBuilder<Ui_hotel_facility> buildFutureBuilder() {
    return FutureBuilder<Ui_hotel_facility>(
      future: create_thisPage_Model(hotel_reservation_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Ui_hotel_facility hotelUi = snapshot.data!;
          return Newhotel_facilityPage(hotelUi,
              hotel_reservation_id: hotel_reservation_id);
          //return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class Newhotel_facilityPage extends StatefulWidget {
  final int hotel_reservation_id;
  Ui_hotel_facility hotel_ui;
  Newhotel_facilityPage(this.hotel_ui,
      {Key? key, required this.hotel_reservation_id})
      : super(key: key);

  @override
  _Newhotel_facilityPage createState() => _Newhotel_facilityPage(hotel_ui,
      hotel_reservation_id: hotel_reservation_id);
}

class _Newhotel_facilityPage extends State<Newhotel_facilityPage> {
  final int hotel_reservation_id;
  Ui_hotel_facility hotel_ui;

  _Newhotel_facilityPage(this.hotel_ui, {required this.hotel_reservation_id});

  final globleFormKey = GlobalKey<FormState>();

  final TextEditingController _c_amount = TextEditingController();

  String? _c_facility_id;
  List<Map> _hotel_namesJSON = [];

  bool validate = false;
  bool circular = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    _hotel_namesJSON = hotel_ui.hotel_facility_names;

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
                    "assets/images/hotel_facilities.png",
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
                "حجز مرافق",
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
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      hint: const Text(
                        "اختر المرفق المطلوب",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _c_facility_id,
                      onChanged: (String? newValue) {
                        setState(() {
                          _c_facility_id = newValue!.toString();
                        });
                        print(_c_facility_id);
                      },
                      items: _hotel_namesJSON.map((Map map) {
                        return DropdownMenuItem(
                          value: map["id"].toString(),
                          child: Center(
                            child: Text(
                              map["name"],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                      style: const TextStyle(color: Colors.white),
                      underline: Container(), // Remove the underline here
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 355.0,
              height: 70,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _c_amount,
                validator: (value) {
                  if (value!.isEmpty) return "amount can't be empty";
                  return null;
                },
                textAlign: TextAlign.right,
                keyboardType:
                    TextInputType.number, // Set keyboardType to number
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: " عدد الحضور",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  errorText: validate ? null : errorText,
                  suffixIcon: const Icon(Icons.group, color: Color(0xFFFFFFFF)),
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
                      if (_c_amount.text.isEmpty) {
                        setState(() {
                          // circular = false;
                          validate = false;
                          errorText = "amount Can't be empty";
                        });
                        return;
                      }

                      if (_c_facility_id == "" || _c_facility_id == null) {
                        showAlertDialog(context, "Check facility_id!",
                            "Your facility_id is empty");
                        return;
                      }

                      Map<String, dynamic> responseList =
                          await api_connect_post_request({
                        "action": "new_hotel_facility",
                        "amount": _c_amount.text,
                        "facility_id": _c_facility_id,
                        "hotel_reservation_id": hotel_reservation_id,
                        "user_id": globals.current_user_id
                      });

                      if (responseList["status"] == "succeed") {
                        //Navigator.pop(context);//close current screen this will prevent return to it
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowAllhotel_facilitiesPage(
                                        hotel_reservation_id:
                                            hotel_reservation_id)));
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
