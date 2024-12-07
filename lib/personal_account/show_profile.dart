import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui';
import 'dart:io'; //for use exit(0)

import 'package:flutter/material.dart';
import 'package:jawlah/personal_account/edit_profile.dart';

import 'package:jawlah/bottom_bar/bottomBar_static.dart';

import 'package:http/http.dart' as http;

import 'package:jawlah/api/api_connect_method.dart';
import 'package:jawlah/api/config.dart';

import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

Future<Map<dynamic, dynamic>> fetchData(int userId) async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(config_URL, config_unencodedPath);
  } else {
    uri = Uri.http(config_URL, config_unencodedPath);
  }

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({"action": "show_profile", "user_id": userId}),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    //List<UserModel> users = (json.decode(response.body) as List)
    // .map((data) => UserModel.fromJson(data))
    // .toList();
    //contacts=(jsonDecode(response.body)['dataView']).toList();
    return (jsonDecode(response.body)['dataView'] as Map<dynamic, dynamic>);
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create card.');
  }
}

class ShowProfile extends StatefulWidget {
  //ShowProfile({Key? key, this.title}) : super(key: key);

  int user_id;
  ShowProfile(this.user_id, {Key? key}) : super(key: key);

  @override
  _ShowProfileState createState() => _ShowProfileState(user_id);
}

class _ShowProfileState extends State<ShowProfile> {
  int user_id;
  _ShowProfileState(this.user_id);

  Map<dynamic, dynamic> _dataView_fetched = {};

  @override
  void initState() {
    super.initState();

    fetchData(user_id).then((result) {
      setState(() {
        _dataView_fetched = result;
      });
    });

    //_contacts = await fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
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
            backgroundColor: Colors.transparent,
            bottomNavigationBar: footer(context),
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: height / 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://$config_URL$show_img_on_server" +
                                    _dataView_fetched['img']),
                            radius: height / 10,
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          Text(
                            _dataView_fetched['fname'] +
                                " " +
                                _dataView_fetched['lname'],
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: const Color(0xFFffffff),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 2.2),
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height / 2.6, left: width / 20, right: width / 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Colors.black45,
                                blurRadius: 2.0,
                                offset: const Offset(0.0, 2.0))
                          ]),
                          child: Padding(
                            padding: EdgeInsets.all(width / 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  headerChild(
                                      '${translate.getTxt("show_profile__surname")}',
                                      _dataView_fetched['surname']),
                                ]),
                          ),
                        ),
                        Container(
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Colors.black45,
                                blurRadius: 2.0,
                                offset: const Offset(0.0, 2.0))
                          ]),
                          child: Padding(
                            padding: EdgeInsets.all(width / 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  headerChild(
                                      '${translate.getTxt("show_profile__phone")}',
                                      _dataView_fetched['phone']),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 20),
                          child: Column(
                            children: <Widget>[
                              infoChild(
                                  width,
                                  Icons.person,
                                  _dataView_fetched['fname'] +
                                      " " +
                                      _dataView_fetched['lname']),
                              infoChild(
                                  width,
                                  Icons.wc,
                                  _dataView_fetched['gender_id'] == 1
                                      ? "Male"
                                      : (_dataView_fetched['gender_id'] == 2
                                          ? "Female"
                                          : "")),
                              infoChild(width, Icons.map,
                                  _dataView_fetched['country_name']),
                              infoChild(width, Icons.date_range,
                                  _dataView_fetched['birthdate']),
                              if (user_id == globals.current_user_id)
                                Padding(
                                  padding: EdgeInsets.only(top: height / 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(
                                          context); //close current page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfilePage()),
                                      );
                                    },
                                    child: Container(
                                      width: width / 3,
                                      height: height / 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFFFFFFF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(height / 40)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black87,
                                                blurRadius: 2.0,
                                                offset: const Offset(0.0, 1.0))
                                          ]),
                                      child: Center(
                                        child: Text(
                                            '${translate.getTxt("show_profile__editProfile")}',
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: const Color(0xFF94a65d),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerChild(String header, String value) => Expanded(
          child: Column(
        children: <Widget>[
          Text(header),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14.0,
                color: const Color(0xFF834900),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 10,
              ),
              Icon(
                icon,
                color: const Color(0xFFffffff),
                size: 36.0,
              ),
              SizedBox(
                width: width / 20,
              ),
              Text(data,
                  style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
