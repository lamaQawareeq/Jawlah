import 'package:flutter/material.dart';
import 'package:jawlah/bottom_bar/bottomBar_static.dart';
import 'package:jawlah/contact_us/contact_us.dart';

import 'package:jawlah/suggestions/show_all_suggestions.dart';

import 'package:jawlah/hotel_reservations/show_all_hotel_reservations.dart';

import 'package:jawlah/public/alert_dialog.dart';

import 'package:geolocator/geolocator.dart';

import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Position? position;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation(); // Fetch location asynchronously
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position currentPosition = await _getCurrentLocation();
      setState(() {
        position = currentPosition; // Update state with the fetched location

        globals.last_position = currentPosition; //global
      });
    } catch (e) {
      // Handle location errors here
      showAlertDialog(context, "خطأ في الموقع", e.toString());
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('إذن الموقع مرفوض');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('إذن الموقع مرفوض بشكل دائم');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align the cards to the right
                children: [
                  const SizedBox(height: 20),
                  _buildCard(
                      context,
                      'hotel_reservations',
                      Icons.hotel,
                      "حجز فندق",
                      "يمكنك اختيار فندق وحجز خدمات فيه وسيتم الرد عليك",
                      "احجز الآن"),
                  _buildCard(
                      context,
                      'suggestions',
                      Icons.drafts,
                      "الاقترحات",
                      "يمكنك طرح مقترح للنظام وسيتم الاطلاع عليه في اقرب وقت",
                      "قدم الآن"),
                  _buildCard(
                      context,
                      'contact_us',
                      Icons.perm_phone_msg,
                      "تواصل معنا",
                      "بيانات التواصل مع الادارة مباشرة  لمساعدتك",
                      "تواصل الآن"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String action, IconData icon,
      String title, String description, String btnName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 5,
        color: const Color(0xFFFFFFFF), // Change background color to #ff0000
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align the card content to the right
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // Align the text to the right
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94a65d),
                      ),
                      textDirection: TextDirection
                          .rtl, // Set text direction to right-to-left
                    ),
                    const SizedBox(height: 5),
                    // Wrap description in a SizedBox to limit its height and force it to display in two lines
                    SizedBox(
                      height: 40, // Adjust this value based on your preference
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2, // Limit description to 2 lines
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection
                            .rtl, // Set text direction to right-to-left
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to another screen

                        if (action == "hotel_reservations") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowAllhotel_reservationsPage()));
                        } else if (action == "suggestions") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowAllSuggestionsPage()));
                        } else if (action == "contact_us") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactUsPage()));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            (action != "sosHelp")
                                ? const Color(0xFF94a65d)
                                : const Color(0xFFdb4444)),
                        foregroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFFFFFFF)),
                      ),
                      child: Text(btnName),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: const Color(0xFF94a65d)),
            ],
          ),
        ),
      ),
    );
  }
}
