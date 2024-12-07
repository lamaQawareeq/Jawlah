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

import 'package:jawlah/models/hotel_roomType_model.dart';

import 'package:jawlah/hotel_reservations/new_hotel_roomType.dart';

import 'package:jawlah/hotel_reservations/show_all_hotel_reservations.dart';

Future<List<hotel_roomType>> createhotel_roomType(
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
      "action": "show_all_hotel_roomTypes",
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
    return (jsonDecode(response.body)['dataView'] as List)
        .map((data) => hotel_roomType.fromJson(data))
        .toList();
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create hotel_roomType.');
  }
}

class ShowAllhotel_roomTypesPage extends StatefulWidget {
  final int hotel_reservation_id;
  const ShowAllhotel_roomTypesPage(
      {Key? key, required this.hotel_reservation_id})
      : super(key: key);

  @override
  State<ShowAllhotel_roomTypesPage> createState() {
    return _ShowAllhotel_roomTypesPageState(
        hotel_reservation_id: hotel_reservation_id);
  }
}

class _ShowAllhotel_roomTypesPageState
    extends State<ShowAllhotel_roomTypesPage> {
  final TextEditingController _controller = TextEditingController();
  Future<hotel_roomType>? _futurehotel_roomType;

  final int hotel_reservation_id;

  _ShowAllhotel_roomTypesPageState({required this.hotel_reservation_id});
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
                gradient: const LinearGradient(colors: const [
              Color(0xFFECF7EA),
              Color(0xFF94a65d),
            ], begin: Alignment.topCenter, end: Alignment.center)),
          ),
          Scaffold(
            appBar: AppBar(
              title: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'نوع الغرف المحجوزة',
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
                                builder: (context) => Newhotel_roomType(
                                    hotel_reservation_id:
                                        hotel_reservation_id)));
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

  FutureBuilder<List<hotel_roomType>> buildFutureBuilder() {
    return FutureBuilder<List<hotel_roomType>>(
      future: createhotel_roomType(hotel_reservation_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<hotel_roomType> hotelRoomtypes = snapshot.data!;
          return List_of_hotel_roomTypes(hotelRoomtypes);
          //return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class List_of_hotel_roomTypes extends StatefulWidget {
  final List<hotel_roomType> hotel_roomTypes;
  const List_of_hotel_roomTypes(this.hotel_roomTypes, {Key? key})
      : super(key: key);

  @override
  State<List_of_hotel_roomTypes> createState() {
    return _List_of_hotel_roomTypes(hotel_roomTypes);
  }
}

class _List_of_hotel_roomTypes extends State<List_of_hotel_roomTypes> {
  final List<hotel_roomType> hotel_roomTypes;

  _List_of_hotel_roomTypes(this.hotel_roomTypes);

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: hotel_roomTypes.length,
      itemBuilder: (context, int currentIndex) {
        //if(hotel_roomTypes[currentIndex].type =="adv")
        //{
        //return createAdv(hotel_roomTypes[currentIndex], context,currentIndex);
        //}

        return createViewItem(
            hotel_roomTypes[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      hotel_roomType hotelRoomtype, BuildContext context, int currentIndex) {
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
            child: ListTile(
              title: Text(
                'نوع الغرفة: ' + hotelRoomtype.roomType_name,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'عدد الغرف: ' + hotelRoomtype.amount,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'وقت الارسال: ' + hotelRoomtype.insert_time,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () async {
                // Navigation logic here
              },
            ),
          ),
        ],
      ),
    );
  }
}
