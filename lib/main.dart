import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth.dart';
import 'models/mahasiswa.dart';
import 'models/talent.dart';
import 'screen/edit_mahasiswa_detail_screen.dart';
import 'screen/login_screen.dart';
import 'screen/talent_mahasiswa_screen.dart';
import 'screen/talent_mahasiswa_item_screen.dart';
import 'screen/home_page.dart';
import 'screen/register_screen.dart';
import 'screen/detail_mahasiswa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Talents(),
        ),
        ChangeNotifierProvider.value(
          value: Mahasiswas(),
        ),
      ],
      child: MaterialApp(
        title: 'Katalog Mahasiswa',
        theme: ThemeData(
          primaryColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.grey),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              color: Colors.black,
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.w900,
            ),
            titleSmall: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.w400,
            ),
            bodyLarge: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const HomePage(),
        routes: {
          HomePage.routeNamed: (context) => const HomePage(),
          EditMahasiswaScreen.routeName: (context) => EditMahasiswaScreen(),
          DetailMahasiswa.routeName: (context) => DetailMahasiswa(),
          TalentMahasiswaScreen.routeNamed: (context) =>
              const TalentMahasiswaScreen(),
          TalentMahasiswaItemScreen.routeNamed: (context) =>
              const TalentMahasiswaItemScreen(),
          LoginScreen.routeNamed: (context) => LoginScreen(),
          RegisterScreen.routeNamed: (context) => RegisterScreen(),
        },
      ),
    );
  }
}
