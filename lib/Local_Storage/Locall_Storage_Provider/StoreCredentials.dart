import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageProvider extends ChangeNotifier {
  String phoneNumber = '';
  String userName = '';
  Future<void> storePhoneNumber(String number) async {
    /// THIS FUNCTION STORES THE PHONE NUMBER WHEN THE USER LOGS IN AND
    /// DISPLAYS IT IN THE PROFILE VIEW
    /// IT ALSO MAKES IT AVAILABLE TO BE SENT TO THE VENDOR WHEN THE USER ORDERS
    ///
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('Telephone', number);
    notifyListeners();
  }

  Future getPhoneNumber() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    phoneNumber = pref.getString('Telephone').toString();
    notifyListeners();
  }

  Future<void> storeUsername(String userName) async {
    /// THIS FUNCTION STORES THE USERNAME WHEN THE USER LOGS IN AND
    /// DISPLAYS IT IN THE PROFILE VIEW
    /// IT ALSO MAKES IT AVAILABLE TO BE SENT TO THE VENDOR WHEN THE USER ORDERS
    ///
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('userName', userName);
    getUserName();
    notifyListeners();
  }

  Future getUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userName = pref.getString('userName').toString();
    notifyListeners();
  }
}
