import 'package:flutter/material.dart';
import 'package:jawlah/bottom_bar/bottomBar_static.dart';
import 'package:jawlah/home/home_page.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

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
                  _buildCard(context, Icons.phone, "هاتف", "092000000"),
                  _buildCard(context, Icons.smartphone, "موبايل", "0500000000"),
                  _buildCard(
                      context, Icons.email, "بريد الكتروني", "info@site.com"),
                  _buildCard(
                      context, Icons.perm_phone_msg, "فاكس", "092000000"),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, IconData icon, String title, String description) {
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
                        fontSize: 15,
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
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2, // Limit description to 2 lines
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection
                            .rtl, // Set text direction to right-to-left
                      ),
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
