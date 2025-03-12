import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubTalent extends ChangeNotifier {
  final String id;
  final String subTalent;
  final String categoryId;

  SubTalent({
    required this.id,
    required this.subTalent,
    required this.categoryId,
  });
}

class SubTalents extends ChangeNotifier {
  List<SubTalent> _subTalent = [];

  SubTalent findById(String id) {
    return _subTalent.firstWhere((element) => element.id == id);
  }

  Future<void> fetchSubTalent() async {
    // final url = Uri.parse(uri);
    // final List<SubTalent> temp = [];
    // final response = await http.get(url);
    // final data = jsonDecode(response.body) as Map<String, dynamic>;
    // data.forEach((key, value) {
    //   temp.add(SubTalent(
    //     id: key,
    //     subTalent: value['subtalent'] ?? '',
    //     categoryId: value['categoryid'] ?? '',
    //   ));
    // });
    // _subTalent = temp;
    // notifyListeners();
  }

  Future<void> addSubTalent(SubTalent subTalent) async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')!.toString());
    final _token = extractedUserData['token'].toString();
    // final url = Uri.parse(uri);
    // try {
    //   final response = await http.post(url,
    //       body: json.encode({
    //         "subtalent": subTalent.subTalent,
    //         "categoryid": subTalent.categoryId,
    //       }));
    //   fetchSubTalent();
    //   notifyListeners();
    //   if (response.statusCode > 400) {
    //     print(response.body);
    //   }
    // } catch (error) {
    //   print(error);
    // }
  }
}
