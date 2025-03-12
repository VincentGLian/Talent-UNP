import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './skill.dart';

class Mahasiswa extends ChangeNotifier {
  final String id;
  final String nama;
  final String email;
  final String np;
  final String professi;
  final String noTelp;
  final String deskripsi;
  final String photo;
  final List<Skill> skills;

  Mahasiswa({
    this.id = '',
    required this.nama,
    required this.email,
    required this.np,
    required this.professi,
    required this.noTelp,
    required this.deskripsi,
    required this.photo,
    required this.skills,
  });
}

class Mahasiswas extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Mahasiswa> _mahasiswa = [];
  String _sorting = '';
  bool _isSearching = false;

  void searching() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  bool get searchingIndex {
    return _isSearching;
  }

  void changeSearchString(String searchString) {
    _sorting = searchString;
    notifyListeners();
  }

  UnmodifiableListView<Mahasiswa> get mahasiswa => _sorting.isEmpty
      ? UnmodifiableListView(_mahasiswa)
      : UnmodifiableListView(_mahasiswa.where((element) =>
          element.nama.toLowerCase().contains(_sorting.toLowerCase())));

  List<Mahasiswa> skilledMahasiswa(String skill) {
    List<Mahasiswa> data = [];
    data.addAll(_mahasiswa
        .where((element) => element.skills.toString() == skill)
        .toList());
    return data;
  }

  List<Mahasiswa> findBySkill(String skill) {
    return _mahasiswa
        .where((mahasiswa) => mahasiswa.skills.toString().contains(skill))
        .toList();
  }

  List<Mahasiswa> mahasiswaBySkill(String id) {
    return _mahasiswa.where((element) {
      return element.skills.any((skill) => skill.id == id);
    }).toList();
  }

  String nama(String id) {
    int index = _mahasiswa.indexWhere((element) => element.id == id);
    return _mahasiswa[index].nama;
  }

  Mahasiswa findById(String id) {
    return _mahasiswa.firstWhere((element) => element.id == id);
  }

  Future<void> fetchMahasiswa() async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.3',
      port: 5000,
      path: '/api/user/all',
    );
    try {
      final response = await http.get(url);
      print(response.body);
      final rawdata = json.decode(response.body);
      List<dynamic> data = rawdata['data'] as List<dynamic>;
      final List<Mahasiswa> temp = [];
      data.forEach((element) {
        var skills = element['skills'] as List<dynamic>;
        List<Skill> tempskill = [];
        skills.forEach((element) {
          tempskill.add(
            Skill(
              id: element['id'].toString(),
              nama: element["skill"].toString(),
            ),
          );
        });
        temp.add(Mahasiswa(
          id: element['id'].toString(),
          nama: element['name'].toString(),
          email: element['email'].toString(),
          np: element['np'].toString(),
          professi: element['Professi'].toString(),
          noTelp: element['no_telp'].toString(),
          deskripsi: element['deskripsi'].toString(),
          photo: element['photo'] ?? 'assets/images/komputer.png',
          skills: tempskill,
        ));
      });

      _mahasiswa = (temp);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> delMahasiswa(String id) async {
    final index = _mahasiswa.indexWhere((element) => element.id == id);
    if (index >= 0) {
      var tempMahasiswa = _mahasiswa[index];
      _mahasiswa.removeAt(index);
      notifyListeners();
      final url = Uri.parse('http://192.168.1.3:5000/api/user/$id/delete');
      var response;
      response = await http.delete(url);
      if (response.statusCode >= 400) {
        _mahasiswa.insert(index, tempMahasiswa);
        notifyListeners();
        throw HttpException('Could Not Delete Product');
      }
    }
  }

  Future<void> addMahasiswa(Mahasiswa mahasiswa) async {
    final url = Uri.parse('http://192.168.1.3:5000/api/user/');
    try {
      final response = await http.post(url, body: {
        "nama": "${mahasiswa.nama}",
        "nim": "${mahasiswa.np}",
        "no_telp": "${mahasiswa.noTelp}",
        "email": "${mahasiswa.email}"
      });
      notifyListeners();
      fetchMahasiswa();
    } catch (error) {
      print(error);
    }
  }

  Future<void> editMahasiswa(String id, Mahasiswa mahasiswa) async {
    int index = _mahasiswa.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url = Uri.parse('http://192.168.1.3:5000/api/user/$id/edit');
      await http.put(url, body: {
        "nama": "${mahasiswa.nama}",
        "nim": "${mahasiswa.np}",
        "no_telp": "${mahasiswa.noTelp}",
        "email": "${mahasiswa.email}"
      });
      _mahasiswa[index] = mahasiswa;
      notifyListeners();
    } else {
      return;
    }
  }
}

// Future<void> fetchMahasiswaFirebase() async {
  //   final url = Uri.parse(
  //       "https://shop-78ba1-default-rtdb.asia-southeast1.firebasedatabase.app/mahasiswa.json");
  //   final List<Mahasiswa> temp = [];
  //   final response = await http.get(url);
  //   final data = jsonDecode(response.body) as Map<String, dynamic>;
  //   data.forEach((key, value) {
  //     temp.add(Mahasiswa(
  //       id: key,
  //       nama: value['nama'] ?? '',
  //       professi: value['Professi'] ?? '',
  //       nim: value['nim'] ?? '',
  //       noteTlp: value['noTelp'] ?? '',
  //       talent: value['talent'] ?? '',
  //       email: value['email'] ?? '',
  //       deskripsi: value['deskripsi'] ?? '',
  //     ));
  //   });
  //   _mahasiswa = temp;
  //   notifyListeners();
  // }

  // Future<void> addMahasiswaFirebase(Mahasiswa mahasiswa) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')!.toString());
  //   final token = extractedUserData['token'].toString();
  //   final url = Uri.parse(
  //       "https://shop-78ba1-default-rtdb.asia-southeast1.firebasedatabase.app/mahasiswa.json?auth=$token");
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           "nama": mahasiswa.nama,
  //           "nim": mahasiswa.nim,
  //           "Professi": mahasiswa.professi,
  //           "talent": mahasiswa.talent,
  //           "no_telp": mahasiswa.noteTlp,
  //           "email": mahasiswa.email,
  //           "deskripsi": mahasiswa.deskripsi,
  //         }));
  //     fetchMahasiswaFirebase();
  //     notifyListeners();
  //     if (response.statusCode > 400) {
  //       print(response.body);
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> editMahasiswaFirebase(String id, Mahasiswa mahasiswa) async {
  //   int index = _mahasiswa.indexWhere((element) => element.id == id);
  //   final prefs = await SharedPreferences.getInstance();
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')!.toString());
  //   final token = extractedUserData['token'].toString();
  //   final url = Uri.parse(
  //       "https://shop-78ba1-default-rtdb.asia-southeast1.firebasedatabase.app/mahasiswa/$id.json?auth=$token");
  //   try {
  //     if (index >= 0) {
  //       final response = await http.patch(url,
  //           body: json.encode({
  //             "nama": mahasiswa.nama,
  //             "nim": mahasiswa.nim,
  //             "Professi": mahasiswa.professi,
  //             "talent": mahasiswa.talent,
  //             "no_telp": mahasiswa.noteTlp,
  //             "email": mahasiswa.email,
  //             "deskripsi": mahasiswa.deskripsi,
  //           }));

  //       _mahasiswa[index] = mahasiswa;
  //       notifyListeners();
  //     } else {
  //       return;
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> delMahasiswaFirebase(String id) async {
  //   final index = _mahasiswa.indexWhere((element) => element.id == id);
  //   if (index >= 0) {
  //     var tempMahasiswa = _mahasiswa[index];
  //     _mahasiswa.removeAt(index);
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final extractedUserData =
  //         json.decode(prefs.getString('userData')!.toString());
  //     final token = extractedUserData['token'].toString();
  //     final url = Uri.parse(
  //         "https://shop-78ba1-default-rtdb.asia-southeast1.firebasedatabase.app/mahasiswa/$id.json?auth=$token");
  //     var response;
  //     response = await http.delete(url);
  //     if (response.statusCode >= 400) {
  //       _mahasiswa.insert(index, tempMahasiswa);
  //       notifyListeners();
  //       throw HttpException('Could Not Delete Product');
  //     }
  //   }
  // }