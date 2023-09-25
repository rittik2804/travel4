import 'package:shared_preferences/shared_preferences.dart';

class Session {
  SharedPreferences? prefs;
  String? id;
  String? name;
  String? phone;
  String? email;

  Session({
    this.id,
    this.name,
    this.phone,
    this.email
  });

  Future user() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs!.getString('id');
    name = prefs!.getString('name');
    phone = prefs!.getString('phone');
    email = prefs!.getString('email');

    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  Future userSave(userData) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('id', userData['customer_id'].toString());
    prefs!.setString('name', userData['name'].toString());
    prefs!.setString('email', userData['email'].toString());
    prefs!.setString('phone', userData['phone'].toString());
  }

  Future userFlash() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.remove('id');
    prefs!.remove('name');
    prefs!.remove('phone');
    prefs!.remove('email');
    return true;
  }

  Future<bool> isLogin() async {
    prefs = await SharedPreferences.getInstance();
    final name = prefs!.getString('name');
    if (name != null) {
      return true;
    }
    return false;
  }
}
