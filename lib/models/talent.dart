import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './skill.dart';

class Talent extends ChangeNotifier {
  final String id;
  final String judul;
  final String imageUrl;
  final List<Skill> skills;

  Talent({
    required this.id,
    required this.judul,
    required this.imageUrl,
    required this.skills,
  });
}

class Talents extends ChangeNotifier {
  List<Talent> _talent = [];
  String _sorting = '';
  bool _isSearching = false;
  UnmodifiableListView<Talent> get talents => _sorting.isEmpty
      ? UnmodifiableListView(_talent)
      : UnmodifiableListView(_talent.where((element) =>
          element.judul.toLowerCase().contains(_sorting.toLowerCase())));

  List<Skill> findById(String id) {
    int index = _talent
        .indexWhere((element) => element.id.toLowerCase() == id.toLowerCase());
    var data = _talent;
    return data[index].skills;
  }

  String findByTitle(String id) {
    int index = _talent
        .indexWhere((element) => element.id.toLowerCase() == id.toLowerCase());
    var data = _talent;
    return data[index].judul;
  }

  String findSkillTitle(String id) {
    for (var talent in _talent) {
      for (var skill in talent.skills) {
        if (skill.id.toLowerCase() == id.toLowerCase()) {
          return skill.nama;
        }
      }
    }
    return ''; // Return an empty string or handle the case when the skill with the given ID is not found
  }

  int findSubTalent(String judul) {
    int index = _talent.indexWhere((talent) => talent.judul == judul);
    return index;
  }

  List<String> get getTalentJudul {
    List<String> listtalent = [];
    _talent.forEach((element) {
      listtalent.add(element.judul);
    });
    return listtalent;
  }

  void changeSearchString(String searchString) {
    _sorting = searchString;
    notifyListeners();
  }

  void searching() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  bool get searchingIndex {
    return _isSearching;
  }

  Future<void> fetchTalent() async {
    final url = Uri(
        scheme: 'http',
        host: '192.168.1.3',
        port: 5000,
        path: '/api/talent/all');

    final response = await http.get(url);
    final rawData = json.decode(response.body);
    print(rawData);
    List<dynamic> data = rawData['data'] as List<dynamic>;

    List<Talent> temp = [];
    data.forEach(
      (element) {
        List<Skill> tempskill = [];
        var rawskills = element['Skills'] as List<dynamic>;
        rawskills.forEach((element) {
          tempskill
              .add(Skill(id: element['id'].toString(), nama: element['nama']));
        });
        temp.add(Talent(
          id: element['id'].toString(),
          judul: element['nama_kategori'],
          imageUrl: element['imageUrl'] ?? 'assets/images/komputer.png',
          skills: tempskill,
        ));
      },
    );
    _talent = temp;
    notifyListeners();
  }
}

// Future<void> fetchTalentFirebase() async {
  //   final url = Uri.parse(
  //       "https://shop-78ba1-default-rtdb.asia-southeast1.firebasedatabase.app/talents.json");
  //   final response = await http.get(url);
  //   final List<Talent> temp = [];

  //   final data = jsonDecode(response.body) as Map<String, dynamic>;
  //   data.forEach((key, value) {
  //     temp.add(Talent(
  //         id: key,
  //         judul: value['judul'],
  //         ket: value['ket'],
  //         imageUrl: value['imageUrl']));
  //   });
  //   _talent = temp;
  //   notifyListeners();
  // }