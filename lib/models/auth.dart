import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  String? _userName;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  String? get username {
    return _userName;
  }

//   Future<void> _authenticate(String name, String email, String password,
//       String urlSegment, String professi) async {
//     final url = Uri.parse(
//         'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD-XAmB9Vvn9ILTM8w5FG3u4QutZsstTWo');
// // http://192.168.202.88:5000/api/user/$urlSegment
//     try {
//       final response = await http.post(url,
//           body: json.encode({
//             'email': email,
//             'password': password,
//             'returnSecureToken': true
//           }));
//       final responseData = json.decode(response.body);
//       if (responseData['error'] != null) {
//         throw HttException(responseData['error']['message']);
//       }
//       print(responseData);
//       _token = responseData['idToken'];
//       _userId = responseData['localId'];
//       _expiryDate = DateTime.now()
//           .add(Duration(seconds: int.parse(responseData['expiresIn'])));
//     } catch (error) {
//       print(error);
//     }
//     print(urlSegment);
//     if (urlSegment == 'signUp') {
//       final url = Uri.parse(
//           "https://shop-78ba1-default-rtdb.asia-southeast1.firebasedatabase.app/mahasiswa/$_userId.json?auth=$_token");
//       try {
//         final response = await http.put(url,
//             body: json.encode({"nama": name, "Professi": professi}));
//       } catch (error) {
//         print(error);
//       }
//     }
//     print("dummi");
//     _autoLogout();
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userData = json.encode({
//         'token': _token,
//         'userId': _userId,
//         'expiryDate': _expiryDate!.toIso8601String(),
//       });
//       prefs.setString('userData', userData);
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> register(
//       String name, String email, String password, String professi) async {
//     return _authenticate(name, email, password, 'signUp', professi);
//   }

  Future<void> register(
      String name, String email, String password, String professi) async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.3',
      port: 5000,
      path: '/api/user/register',
    );
    try {
      final response = await http.post(url, body: {
        'nama': name,
        'email': email,
        'password': password,
        'professi': professi,
      });
      if (response.statusCode > 400) {
        throw HttpException(response.body);
      }
      login(email, password);
      // Perform any necessary actions after successful registration
    } catch (error) {
      print(error);
      // Handle and display the error appropriately
    }
  }

  // Future<void> login(String email, String password) async {
  //   final url = Uri(
  //     scheme: 'http',
  //     host: '192.168.1.3',
  //     port: 5000,
  //     path: '/api/user/login',
  //   );
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({'email': email, 'password': password}));
  //     if (response.statusCode > 400) {
  //       throw HttpException(response.body);
  //     }
  //     print(response.body);
  //     if (response.body.isEmpty) {
  //       throw FormatException('Unexpected end of input');
  //     }
  //     var data = json.decode(response.body);
  //     _userId = data['userId'];
  //     _userName = data['username'];
  //     _token = data['token'];
  //     _expiryDate =
  //         DateTime.now().add(Duration(seconds: int.parse(data['expiryDate'])));
  //   } catch (error) {
  //     print(error);
  //   }
  //   _autoLogout();
  //   notifyListeners();
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode({
  //       'userId': _userId,
  //       'username': _userName,
  //       'token': _token,
  //       'expiryDate': _expiryDate!.toIso8601String(),
  //     });
  //     prefs.setString('userData', userData);
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<void> login(String email, String password) async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.3',
      port: 5000,
      path: '/api/user/login',
    );
    try {
      print('Sending login request to: $url');
      print('Email: $email');
      print('Password: $password');

      final response =
          await http.post(url, body: {'email': email, 'password': password});
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      if (response.body.isEmpty) {
        throw FormatException('Unexpected end of input');
      }
      var data = json.decode(response.body);
      _userId = data['id'].toString();
      _userName = data['name'];
      _token = data['token'];
      _expiryDate = DateTime.tryParse(data['expiryDate']);
    } catch (error) {
      print('Error during login: $error');
    }
    _autoLogout();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'username': _userName,
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      print('Error saving user data: $error');
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      final extractedUserData =
          json.decode(prefs.getString('userData')!.toString());
      final expiryDate =
          DateTime.parse(extractedUserData['expiryDate'].toString());

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }

      _token = extractedUserData['token'].toString();
      _userId = extractedUserData['userId'].toString();
      _expiryDate = expiryDate;
      _userName = extractedUserData['username'].toString();
      notifyListeners();
    } catch (error) {
      print(error);
    }
    return true;
  }

  Future<void> logout() async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.3',
      port: 5000,
      path: '/api/user/logout',
    );
    try {
      final response = await http.post(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token'
      });
    } catch (error) {}
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
