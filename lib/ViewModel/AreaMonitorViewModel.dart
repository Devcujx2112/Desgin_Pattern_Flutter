import 'dart:ffi';

import 'package:design_pattern_login/Model/Country.dart';
import 'package:design_pattern_login/Service/AreaMonitor_Service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AreaMontitorViewModel extends ChangeNotifier {
  final String aPIRealTime = "https://flutter-api-2f232-default-rtdb.firebaseio.com";
  TextEditingController nameCountries = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  AreaMonitor_Service areaMonitor_Service = AreaMonitor_Service();

  bool isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void _SetError(String message) {
    isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> InsertAreaMonitor() async {
    try {
      isLoading = true;

      _errorMessage = null;
      String uid = const Uuid().v4();
      String createAt = DateTime.now().toString();

      final la = double.tryParse(latitude.text);
      final long = double.tryParse(longitude.text);

      if (la == null || long == null) {
        _SetError("Vĩ độ/kinh độ phải là số hợp lệ");
        return false;
      }

      Country country = Country(uid, nameCountries.text, la, long, createAt);
      bool isSuccess = await areaMonitor_Service.InsertAreaMonitor(country);

      if (!isSuccess) {
        _SetError("Lỗi khi thêm thông tin");
        return false;
      }

      return true;
    } catch (e) {
      _SetError("Lỗi khi insert: ${e.toString()}");
      print('Lỗi VM $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String,dynamic>> ShowAllInformation() async{
    try{
      _errorMessage = null;

      Map<String,dynamic> data = await areaMonitor_Service.ShowAllData();
      if(data.isNotEmpty){
        return data;
      }
      else{
        _SetError("Khong co data");
        return {};
      }
    }catch(e){
      _SetError("Loi khi xuat du lieu $e");
      return {};
    }
  }
}