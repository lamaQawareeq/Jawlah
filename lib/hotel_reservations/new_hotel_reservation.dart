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

import 'package:jawlah/hotel_reservations/show_all_hotel_reservations.dart';

import 'package:jawlah/models/hotel_reservation_model.dart';

import 'package:jawlah/public/alert_dialog.dart';
import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

import 'package:jawlah/bottom_bar/bottomBar_static.dart';

Future<Ui_hotel_reservation> create_thisPage_Model(final int landmarkId) async {
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
      "action": "show_hotel_ui_data",
      "landmark_id": landmarkId,
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
    Ui_hotel_reservation hotelUi =
        Ui_hotel_reservation.fromJson(jsonD['dataView']);

    return hotelUi;
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create hotel_ui .');
  }
}

class Newhotel_reservation extends StatefulWidget {
  final int landmark_id;
  const Newhotel_reservation({Key? key, required this.landmark_id})
      : super(key: key);

  @override
  State<Newhotel_reservation> createState() {
    return _Newhotel_reservationState(landmark_id: landmark_id);
  }
}

class _Newhotel_reservationState extends State<Newhotel_reservation> {
  final TextEditingController _controller = TextEditingController();

  final int landmark_id;

  _Newhotel_reservationState({required this.landmark_id});

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

  FutureBuilder<Ui_hotel_reservation> buildFutureBuilder() {
    return FutureBuilder<Ui_hotel_reservation>(
      future: create_thisPage_Model(landmark_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Ui_hotel_reservation hotelUi = snapshot.data!;
          return Newhotel_reservationPage(hotelUi);
          //return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class Newhotel_reservationPage extends StatefulWidget {
  Ui_hotel_reservation hotel_ui;
  Newhotel_reservationPage(this.hotel_ui, {Key? key}) : super(key: key);

  @override
  _Newhotel_reservationPage createState() =>
      _Newhotel_reservationPage(hotel_ui);
}

class _Newhotel_reservationPage extends State<Newhotel_reservationPage> {
  Ui_hotel_reservation hotel_ui;

  _Newhotel_reservationPage(this.hotel_ui);

  //final globleFormKey = GlobalKey<FormState>();

  final TextEditingController _c_capacity = TextEditingController();
  final TextEditingController _c_booking_date = TextEditingController();

  String? _c_hotel_id;
  List<Map> _hotel_namesJSON = [];

  bool validate = false;
  bool circular = false;
  String? errorText;

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month + 3, DateTime.now().day),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _c_booking_date.text = picked
            .toLocal()
            .toString()
            .split(' ')[0]; // Extracting only the date part not datetime
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _hotel_namesJSON = hotel_ui.hotel_names;

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#94A65D"),
        body: Form(
          //key: globleFormKey,//--------------------------------here
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
                    "assets/images/hotel_reservations.png",
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
                "حجز فندق",
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
                controller: _c_capacity,
                validator: (value) {
                  if (value!.isEmpty) return "capacity can't be empty";
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
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 355.0,
              height: 70,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.right,
                controller: _c_booking_date,
                readOnly: true, // Make the text field read-only
                onTap: () => _selectDate(context), // Show date picker on tap
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: "موعد الحجز",
                  hintStyle:
                      const TextStyle(fontSize: 15.0, color: Colors.white),
                  suffixIcon: IconButton(
                    //suffixIcon ==> at right direction
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon:
                        const Icon(Icons.access_time, color: Color(0xFFFFFFFF)),
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
                        "حدد الفندق المطلوب",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _c_hotel_id,
                      onChanged: (String? newValue) {
                        setState(() {
                          _c_hotel_id = newValue!.toString();
                        });
                        print(_c_hotel_id);
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
          circular
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: FormHelper.submitButton(
                    "ارسال",
                    () async {
                      if (_c_capacity.text.isEmpty) {
                        setState(() {
                          // circular = false;
                          validate = false;
                          errorText = "capacity Can't be empty";
                        });
                        return;
                      }

                      if (_c_booking_date.text == "") {
                        showAlertDialog(context, "Check booking_date!",
                            "Your booking_date is empty");
                        return;
                      }

                      if (_c_hotel_id == "" || _c_hotel_id == null) {
                        showAlertDialog(context, "Select Facility!",
                            "Your Facility is empty");
                        return;
                      }

                      Map<String, dynamic> responseList =
                          await api_connect_post_request({
                        "action": "new_hotel_reservation",
                        "capacity": _c_capacity.text,
                        "booking_date": _c_booking_date.text,
                        "hotel_id": _c_hotel_id,
                        "user_id": globals.current_user_id
                      });

                      if (responseList["status"] == "succeed") {
                        //Navigator.pop(context);//close current screen this will prevent return to it
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowAllhotel_reservationsPage()));
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
