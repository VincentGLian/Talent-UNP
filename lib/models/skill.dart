import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Skill extends ChangeNotifier {
  final String id;
  final String nama;

  Skill({required this.id, required this.nama});
}

class Skills extends ChangeNotifier {
  List<Skill> _skills = [];

  Future<void> fetchSkills() async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.3',
      port: 5000,
      path: '/api/allskill',
    );

    final response = await http.get(url);
    final rawData = json.decode(response.body);
    List<dynamic> data = rawData['data'] as List<dynamic>;
    List<Skill> temp = [];
    data.forEach(
      (element) {
        temp.add(Skill(
          id: element['id'].toString(),
          nama: element['name'].toString(),
        ));
      },
    );
    _skills = temp;
    notifyListeners();
  }
}
