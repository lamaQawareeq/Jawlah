import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:jawlah/home/home_page.dart';

import 'package:jawlah/login/login_page.dart';

import 'package:jawlah/personal_account/edit_profile.dart';
import 'package:jawlah/personal_account/show_profile.dart';

import 'package:jawlah/public/globals.dart' as globals;
import 'package:jawlah/public/translate.dart' as translate;

int selectedIndex = 0;

BottomNavigationBar footer(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType
        .fixed, // Set type to fixed to always show labels
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.power_settings_new),
        label: 'تسجيل خروج',
        backgroundColor: Colors.white,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'حسابي',
        backgroundColor: Colors.white,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'الرئيسية',
        backgroundColor: Colors.white,
      ),
    ],
    currentIndex: selectedIndex,
    unselectedItemColor: const Color(0xff94a65d),
    selectedItemColor: const Color(0xff7E4A24),
    onTap: (index) {
      switch (index) {
        case 0:
          globals.current_user_id = null;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          break;
        case 1:
          if (globals.current_user_id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowProfile(globals.current_user_id!)),
            );
          }
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
      }
    },
  );
}
