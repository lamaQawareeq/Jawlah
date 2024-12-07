import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import 'package:jawlah/api/api_connect_method.dart';
import 'package:jawlah/api/config.dart';

import 'package:jawlah/public/alert_dialog.dart';

import 'package:jawlah/public/globals.dart' as globals;

import 'package:jawlah/public/translate.dart' as translate;

import 'package:jawlah/bottom_bar/bottomBar_static.dart';

import 'package:jawlah/models/hotel_reservation_model.dart';

import 'package:jawlah/hotel_reservations/new_hotel_reservation.dart';

import 'package:jawlah/hotel_reservations/show_all_hotel_facilities.dart';
import 'package:jawlah/hotel_reservations/show_all_hotel_meals.dart';
import 'package:jawlah/hotel_reservations/show_all_hotel_roomTypes.dart';

Future<List<hotel_reservation>> createhotel_reservation() async {
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
      "action": "show_all_hotel_reservations",
      "user_id": globals.current_user_id
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    //List<UserModel> users = (json.decode(response.body) as List)
    // .map((data) => UserModel.fromJson(data))
    // .toList();
    return (jsonDecode(response.body)['dataView'] as List)
        .map((data) => hotel_reservation.fromJson(data))
        .toList();
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create hotel_reservation.');
  }
}

class ShowAllhotel_reservationsPage extends StatefulWidget {
  const ShowAllhotel_reservationsPage({Key? key}) : super(key: key);

  @override
  State<ShowAllhotel_reservationsPage> createState() {
    return _ShowAllhotel_reservationsPageState();
  }
}

class _ShowAllhotel_reservationsPageState
    extends State<ShowAllhotel_reservationsPage> {
  final TextEditingController _controller = TextEditingController();
  Future<hotel_reservation>? _futurehotel_reservation;

  @override
  void initState() {
    super.initState();

    //_contacts = await fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: const [
              Color(0xFFECF7EA),
              Color(0xFF94a65d),
            ], begin: Alignment.topCenter, end: Alignment.center)),
          ),
          Scaffold(
            appBar: AppBar(
              title: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'سجل حجوزات الفنادق',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF7E953A),
                    ),
                  )),
              backgroundColor: const Color(
                  0xFFFFFFFF), // Make header background transparent if needed
              //elevation: 0, // Remove shadow for transparency effect
            ),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: footer(context),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to another screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Newhotel_reservation(landmark_id: 0)));
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF94A65D)),
                        foregroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFFFFFFF)),
                      ),
                      child: const Text("احجز الآن"),
                    )),
                Expanded(
                  child: buildFutureBuilder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<hotel_reservation>> buildFutureBuilder() {
    return FutureBuilder<List<hotel_reservation>>(
      future: createhotel_reservation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<hotel_reservation> hotelReservations = snapshot.data!;
          return List_of_hotel_reservations(hotelReservations);
          //return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class List_of_hotel_reservations extends StatefulWidget {
  final List<hotel_reservation> hotel_reservations;
  const List_of_hotel_reservations(this.hotel_reservations, {Key? key})
      : super(key: key);

  @override
  State<List_of_hotel_reservations> createState() {
    return _List_of_hotel_reservations(hotel_reservations);
  }
}

class _List_of_hotel_reservations extends State<List_of_hotel_reservations> {
  final List<hotel_reservation> hotel_reservations;

  _List_of_hotel_reservations(this.hotel_reservations);

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: hotel_reservations.length,
      itemBuilder: (context, int currentIndex) {
        //if(hotel_reservations[currentIndex].type =="adv")
        //{
        //return createAdv(hotel_reservations[currentIndex], context,currentIndex);
        //}

        return createViewItem(
            hotel_reservations[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(hotel_reservation hotelReservation,
      BuildContext context, int currentIndex) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color(0xFFFFFFFF),
            width: 8.0,
          ),
          left: BorderSide(
            color: Color(0x00000000),
            width: 5.0,
          ),
          top: BorderSide(
            color: Color(0x00000000),
            width: 5.0,
          ),
          bottom: BorderSide(
            color: Color(0x00000000),
            width: 5.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            color: _getBackgroundColor(hotelReservation.status),
            child: ListTile(
              title: Text(
                'الفندق: ' + hotelReservation.hotel_name,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'عدد الحضور: ' + hotelReservation.capacity + ' شخص ',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'وقت الارسال: ' + hotelReservation.insert_time,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'موعد الحجز: ' + hotelReservation.booking_date,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Divider(
                    color: Color(0xBB888888),
                  ),
                  Text(
                    "الرد: " + hotelReservation.reply_msg,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xBB888888),
                    ),
                  ),
                ],
              ),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hotelReservation.status == "1")
                    const Icon(
                      Icons.done,
                      color: Color(0xFF278208),
                      size: 32,
                    )
                  else if (hotelReservation.status == "2")
                    const Icon(
                      Icons.close,
                      color: Color(0xFFD50008),
                      size: 32,
                    )
                  else
                    const Icon(
                      Icons.watch_later,
                      color: Color(0xFF3B7DA0),
                      size: 32,
                    ),
                ],
              ),
              onTap: () async {
                // Navigation logic here
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Button 1 action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAllhotel_facilitiesPage(
                                  hotel_reservation_id: hotelReservation.id)));
                    },
                    child: const Text('مرافق'),
                  ),
                ),
                const SizedBox(width: 8.0), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Button 2 action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAllhotel_mealsPage(
                                  hotel_reservation_id: hotelReservation.id)));
                    },
                    child: const Text('وجبات'),
                  ),
                ),
                const SizedBox(width: 8.0), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Button 3 action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAllhotel_roomTypesPage(
                                  hotel_reservation_id: hotelReservation.id)));
                    },
                    child: const Text('نوع الغرف'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(String status) {
    if (status == "1") {
      return const Color(
          0xFFEDFFEB); // Change the color as per your requirement
    } else if (status == "2") {
      return const Color(
          0xFFFFEBEB); // Change the color as per your requirement
    } else {
      return const Color(
          0xFFF2EBFF); // Change the color as per your requirement
    }
  }
}
