import 'dart:async';
import 'dart:convert';
import 'dart:io'; //for use exit(0)

import 'package:intl/intl.dart'
    as intl; //for dateformat and must use "as intl" to prevent error in other library like using TextDirection.ltr

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import 'package:jawlah/api/api_connect_method.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jawlah/bottom_bar/bottomBar_static.dart';

import 'package:jawlah/api/config.dart';

import 'package:jawlah/public/alert_dialog.dart';

import 'package:jawlah/personal_account/show_profile.dart';

import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

import 'package:jawlah/models/profile_model.dart';

Future<ProfileModel> createProfileModel() async {
  Uri uri;
  if (useHttps) {
    uri = Uri.https(config_URL, config_unencodedPath);
  } else {
    uri = Uri.http(config_URL, config_unencodedPath);
  }

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(
        {"action": "show_profile", "user_id": globals.current_user_id}),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    //List<UserModel> users = (json.decode(response.body) as List)
    // .map((data) => UserModel.fromJson(data))
    // .toList();
    dynamic jsonD = jsonDecode(response.body);
    ProfileModel profileModel = ProfileModel.fromJson(jsonD['dataView']);

    return profileModel;
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create profile_model.');
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() {
    return _EditProfilePageState();
  }
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _controller = TextEditingController();
  //Future<ProfileModel>? _futureProfileModel;

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

  FutureBuilder<ProfileModel> buildFutureBuilder() {
    return FutureBuilder<ProfileModel>(
      future: createProfileModel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ProfileModel profileModel = snapshot.data!;
          return PageContent(profileModel);
          //return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class PageContent extends StatefulWidget {
  ProfileModel profile_model;
  PageContent(this.profile_model, {Key? key}) : super(key: key);

  @override
  State<PageContent> createState() {
    return _PageContent(profile_model);
  }
}

int firstTime = 1;

class _PageContent extends State<PageContent> {
  ProfileModel profile_model;

  _PageContent(this.profile_model);

  File? _image;
  final picker = ImagePicker();

  Future choiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage == null ? null : File(pickedImage.path);
    });
  }

  Future uploadImage() async {
    final uri = Uri.parse("http://$config_URL$config_unencodedPath_upload_img");
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = globals.current_user_id.toString();
    var pic = await http.MultipartFile.fromPath("image", _image!.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }

  String? _country_id;
  List<Map> _countryJSON = [];

  int _gender_id = 0;
  String _gender_name = "";

  String _img_name = "";

  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();

  final TextEditingController _loginname = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
  Widget build(context) {
    if (firstTime == 1) //dont rebuild it at any change
    {
      firstTime = 0;
      _fname.text = profile_model.fname;
      _lname.text = profile_model.lname;
      _surname.text = profile_model.surname;
      _phone.text = profile_model.phone;
      _loginname.text = profile_model.loginname;
      //_password.text=profile_model.password;
      _birthdate.text = profile_model.birthdate;
      _country_id = profile_model.country_id.toString();

      _img_name = profile_model.img.toString();

      _gender_id = profile_model.gender_id;

      _countryJSON = profile_model.country;
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                choiceImage();
              },
            ),
          ),
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: _image == null
                  ? (profile_model.img == null
                      ? const Icon(Icons.image,
                          size: 50.0, color: Color(0xFFF7F7F7))
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              "http://$config_URL$show_img_on_server$_img_name"),
                          radius: 60,
                        ))
                  : CircleAvatar(
                      backgroundImage: FileImage(_image!), radius: 60),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                    width: 1, // the thickness
                    color: Color(0xFF94a65d) // the color of the border
                    ),
                backgroundColor: HexColor("#ffffff"),
                foregroundColor: HexColor("#94a65d"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text(
                '${translate.getTxt("edit_profile__saveImg")}',
                textAlign: translate.set_alignment == "right"
                    ? TextAlign.right
                    : TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF94a65d)),
              ),
            ),
          ),
          const Divider(
            color: Color(0xffffffff),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: TextField(
                      controller: _lname,
                      textDirection: translate.set_alignment == "right"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: translate.set_alignment == "right"
                          ? TextAlign.right
                          : TextAlign.left,
                      style: const TextStyle(
                          color: Color(0xffffffff), fontSize: 14.0),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: '${translate.getTxt("edit_profile__lname")}',
                        hintText: '${translate.getTxt("edit_profile__lname")}',
                        hintStyle: const TextStyle(
                            fontSize: 13.0, color: Color(0xffffffff)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when focused
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when enabled
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Border color on error
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .red), // Border color on error when focused
                        ),
                        prefixIcon: const SizedBox(
                            width:
                                10.0), // Empty SizedBox to create space for label alignment
                        prefixText:
                            '', // Empty prefixText to prevent the default label from appearing on the left
                        labelStyle: const TextStyle(
                            color: Color(0xffffffff)), // Label text color
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: TextField(
                      controller: _fname,
                      //textDirection: TextDirection.rtl,
                      //textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 14.0,
                      ),
                      textDirection: translate.set_alignment == "right"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: translate.set_alignment == "right"
                          ? TextAlign.right
                          : TextAlign.left,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Set border color to white
                        ),
                        labelText: '${translate.getTxt("edit_profile__fname")}',
                        hintText: '${translate.getTxt("edit_profile__fname")}',

                        hintStyle: const TextStyle(
                            fontSize: 13.0, color: Color(0xffffffff)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when focused
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when enabled
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Border color on error
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .red), // Border color on error when focused
                        ),
                        prefixIcon: const SizedBox(
                            width:
                                10.0), // Empty SizedBox to create space for label alignment
                        prefixText:
                            '', // Empty prefixText to prevent the default label from appearing on the left
                        labelStyle: const TextStyle(
                            color: Color(0xffffffff)), // Label text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: SizedBox(
                height: 35,
                width: 140,
                child: TextField(
                  controller: _surname,
                  //textDirection: TextDirection.rtl,
                  textDirection: translate.set_alignment == "right"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: translate.set_alignment == "right"
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(), //UnderlineInputBorder
                    labelText: '${translate.getTxt("edit_profile__surname")}',
                    hintText: '${translate.getTxt("edit_profile__surname")}',

                    hintStyle: const TextStyle(
                        fontSize: 13.0, color: Color(0xffffffff)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Border color when focused
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Border color when enabled
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red), // Border color on error
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.red), // Border color on error when focused
                    ),
                    prefixIcon: const SizedBox(
                        width:
                            10.0), // Empty SizedBox to create space for label alignment
                    prefixText:
                        '', // Empty prefixText to prevent the default label from appearing on the left
                    labelStyle: const TextStyle(
                        color: Color(0xffffffff)), // Label text color
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: SizedBox(
                height: 35,
                width: 140,
                child: TextField(
                  controller: _phone,
                  //textDirection: TextDirection.rtl,
                  textDirection: translate.set_alignment == "right"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: translate.set_alignment == "right"
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(), //UnderlineInputBorder
                    labelText: '${translate.getTxt("edit_profile__phone")}',
                    hintText: '${translate.getTxt("edit_profile__phone")}',

                    hintStyle: const TextStyle(
                        fontSize: 13.0, color: Color(0xffffffff)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Border color when focused
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Border color when enabled
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red), // Border color on error
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.red), // Border color on error when focused
                    ),
                    prefixIcon: const SizedBox(
                        width:
                            10.0), // Empty SizedBox to create space for label alignment
                    prefixText:
                        '', // Empty prefixText to prevent the default label from appearing on the left
                    labelStyle: const TextStyle(
                        color: Color(0xffffffff)), // Label text color
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: translate.set_alignment == "right"
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start, //spaceBetween or end
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: _gender_id,
                    onChanged: (int? val) {
                      setState(() {
                        _gender_name = 'male';
                        _gender_id = 1;
                        //profile_model.set_gender_id=val!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.white, // لون النص عند التحديد
                    hoverColor: Colors.white, // لون النص عند التحويم
                    focusColor: Colors.white, // لون النص عند التركيز
                    autofocus: true,
                  ),
                  Text(
                    '${translate.getTxt("edit_profile__male")}',
                    style: const TextStyle(
                        fontSize: 15.0, color: const Color(0xffffffff)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Radio(
                    value: 2,
                    groupValue: _gender_id,
                    onChanged: (int? val) {
                      setState(() {
                        _gender_name = 'famale';
                        _gender_id = 2;
                        //profile_model.set_gender_id=val!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.white, // لون النص عند التحديد
                    hoverColor: Colors.white, // لون النص عند التحويم
                    focusColor: Colors.white, // لون النص عند التركيز
                    autofocus: true,
                  ),
                  Text(
                    '${translate.getTxt("edit_profile__female")}',
                    style: const TextStyle(
                        fontSize: 15.0, color: const Color(0xffffffff)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white), // Border with white color
                borderRadius:
                    BorderRadius.circular(5), // Optional: Rounded corners
              ),
              child: Directionality(
                textDirection: translate.set_alignment == "right"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      hint: Text(
                        "${translate.getTxt("edit_profile__country")}",
                        textAlign: translate.set_alignment == "right"
                            ? TextAlign.right
                            : TextAlign.left,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: _country_id,
                      onChanged: (String? newValue) {
                        setState(() {
                          _country_id = newValue!.toString();
                        });
                        print(_country_id);
                      },
                      items: _countryJSON.map((Map map) {
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
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Center(
            child: SizedBox(
                width: 300,
                height: 35,
                child: TextField(
                  controller: _birthdate,
                  //editing controller of this TextField
                  textDirection: translate.set_alignment == "right"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: translate.set_alignment == "right"
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(color: Color(0xffffffff)),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(), //UnderlineInputBorder
                    alignLabelWithHint: true,
                    labelText: '${translate.getTxt("edit_profile__birthdate")}',
                    hintText: '${translate.getTxt("edit_profile__birthdate")}',

                    hintStyle: const TextStyle(
                        fontSize: 13.0, color: Color(0xffffffff)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Border color when focused
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Border color when enabled
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red), // Border color on error
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.red), // Border color on error when focused
                    ),
                    prefixIcon: const SizedBox(
                        width:
                            10.0), // Empty SizedBox to create space for label alignment
                    prefixText:
                        '', // Empty prefixText to prevent the default label from appearing on the left
                    labelStyle: const TextStyle(
                        color: Color(0xffffffff)), // Label text color
                  ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      String formattedDate =
                          intl.DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        _birthdate.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: TextField(
                      controller: _loginname,
                      textDirection: translate.set_alignment == "right"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: translate.set_alignment == "right"
                          ? TextAlign.right
                          : TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        border:
                            const OutlineInputBorder(), //UnderlineInputBorder
                        labelText:
                            '${translate.getTxt("edit_profile__username")}',
                        hintText:
                            '${translate.getTxt("edit_profile__username")}',

                        hintStyle: const TextStyle(
                            fontSize: 13.0, color: Color(0xffffffff)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when focused
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when enabled
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Border color on error
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .red), // Border color on error when focused
                        ),
                        prefixIcon: const SizedBox(
                            width:
                                10.0), // Empty SizedBox to create space for label alignment
                        prefixText:
                            '', // Empty prefixText to prevent the default label from appearing on the left
                        labelStyle: const TextStyle(
                            color: Color(0xffffffff)), // Label text color
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: TextField(
                      controller: _password,
                      textDirection: translate.set_alignment == "right"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: translate.set_alignment == "right"
                          ? TextAlign.right
                          : TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 14.0,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        border:
                            const OutlineInputBorder(), //UnderlineInputBorder
                        labelText:
                            '${translate.getTxt("edit_profile__password")}',
                        hintText:
                            '${translate.getTxt("edit_profile__password")}',

                        hintStyle: const TextStyle(
                            fontSize: 13.0, color: Color(0xffffffff)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when focused
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when enabled
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Border color on error
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .red), // Border color on error when focused
                        ),
                        prefixIcon: const SizedBox(
                            width:
                                10.0), // Empty SizedBox to create space for label alignment
                        prefixText:
                            '', // Empty prefixText to prevent the default label from appearing on the left
                        labelStyle: const TextStyle(
                            color: Color(0xffffffff)), // Label text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> responseList =
                      await api_connect_post_request({
                    "action": "update_your_profile",
                    "user_id": globals.current_user_id,
                    "fname": _fname.text,
                    "lname": _lname.text,
                    "phone": _phone.text,
                    "surname": _surname.text,
                    "birthdate": _birthdate.text,
                    "gender_id": _gender_id,
                    "country_id": _country_id,
                    "loginname": _loginname.text,
                    "password": _password.text
                  });

                  if (responseList["status"] == "succeed") {
                    showAlertDialog(context, "تم", responseList["body"]);
                    firstTime = 1;
                    Navigator.pop(context); //close current page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowProfile(globals.current_user_id!)),
                    );
                  } else if (responseList["status"] == "failed") {
                    showAlertDialog(context, "تنبيه", responseList["body"]);
                  } else {
                    showAlertDialog(context, "خطأ", "غير معروف");
                  }
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                      width: 1, // the thickness
                      color: Color(0xFF94a65d) // the color of the border
                      ),
                  backgroundColor: HexColor("#ffffff"),
                  foregroundColor: HexColor("#94a65d"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  '${translate.getTxt("edit_profile__saveChange")}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF94a65d)),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  firstTime = 1;
                  Navigator.pop(context); //close current page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowProfile(globals.current_user_id!)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                      width: 1, // the thickness
                      color: Color(0xFF94a65d) // the color of the border
                      ),
                  backgroundColor: HexColor("#ffffff"),
                  foregroundColor: HexColor("#94a65d"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  '${translate.getTxt("edit_profile__back")}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF94a65d)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
