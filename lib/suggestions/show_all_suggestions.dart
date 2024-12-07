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

import 'package:jawlah/models/suggestion_model.dart';

import 'package:jawlah/suggestions/new_suggestion.dart';

Future<List<Suggestion>> createSuggestion() async {
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
        {"action": "show_all_suggestions", "user_id": globals.current_user_id}),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    //List<UserModel> users = (json.decode(response.body) as List)
    // .map((data) => UserModel.fromJson(data))
    // .toList();
    return (jsonDecode(response.body)['dataView'] as List)
        .map((data) => Suggestion.fromJson(data))
        .toList();
  } else {
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create suggestion.');
  }
}

class ShowAllSuggestionsPage extends StatefulWidget {
  const ShowAllSuggestionsPage({Key? key}) : super(key: key);

  @override
  State<ShowAllSuggestionsPage> createState() {
    return _ShowAllSuggestionsPageState();
  }
}

class _ShowAllSuggestionsPageState extends State<ShowAllSuggestionsPage> {
  final TextEditingController _controller = TextEditingController();
  Future<Suggestion>? _futureSuggestion;

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
                    'سجل المقترحات',
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
                                builder: (context) => NewSuggestion()));
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF94A65D)),
                        foregroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFFFFFFF)),
                      ),
                      child: const Text("اقتراح جديد"),
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

  FutureBuilder<List<Suggestion>> buildFutureBuilder() {
    return FutureBuilder<List<Suggestion>>(
      future: createSuggestion(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Suggestion> suggestions = snapshot.data!;
          return List_of_suggestions(suggestions);
          //return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class List_of_suggestions extends StatefulWidget {
  final List<Suggestion> suggestions;
  const List_of_suggestions(this.suggestions, {Key? key}) : super(key: key);

  @override
  State<List_of_suggestions> createState() {
    return _List_of_suggestions(suggestions);
  }
}

class _List_of_suggestions extends State<List_of_suggestions> {
  final List<Suggestion> suggestions;

  _List_of_suggestions(this.suggestions);

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, int currentIndex) {
        //if(suggestions[currentIndex].type =="adv")
        //{
        //return createAdv(suggestions[currentIndex], context,currentIndex);
        //}

        return createViewItem(suggestions[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      Suggestion suggestion, BuildContext context, int currentIndex) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color(0xFFFFFFFF),
              width: 8.0, // Adjust the width as needed
            ),
            left: BorderSide(
              color: Color(0x00000000), // Border color
              width: 5.0, // Border width
            ),
            top: BorderSide(
              color: Color(0x00000000), // Border color
              width: 5.0, // Border width
            ),
            bottom: BorderSide(
              color: Color(0x00000000), // Border color
              width: 5.0, // Border width
            ),
          ),
        ),
        child: Container(
            color: _getBackgroundColor(suggestion
                .status), // Call a function to get the background color
            child: ListTile(
              title: Text(
                suggestion.title,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align content to the right
                children: [
                  Text(
                    'الوقت: ${suggestion.insert_time!}',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    suggestion.content,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Divider(
                    color: Color(0xBB888888),
                  ),
                  Text(
                    "الرد: ${suggestion.reply_msg!}",
                    textAlign: TextAlign.right,
                    textDirection:
                        TextDirection.rtl, // Set text direction to RTL
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
                  if (suggestion.status == "1")
                    const Icon(
                      Icons.done,
                      color: Color(0xFF278208),
                      size: 32,
                    )
                  else if (suggestion.status == "2")
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
                    ), // Replace YourNewIconHere with the desired icon
                ],
              ),
              onTap: () async {
                // Navigate to another screen when the list item is clicked
                //Navigator.push(context,MaterialPageRoute(builder: (context) => OneSuggestionPage(suggestion.id!)),);
              },
            )));
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
