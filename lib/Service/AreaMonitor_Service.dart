import 'dart:convert';
import 'package:design_pattern_login/Model/Country.dart';
import 'package:http/http.dart' as http;

class AreaMonitor_Service{
  static const String aPIRealTime = "https://flutter-api-2f232-default-rtdb.firebaseio.com/";

  Future<bool> InsertAreaMonitor(Country mon) async{
    try{
      Uri url = Uri.parse("$aPIRealTime/${mon.uid}.json");

      Map<String, dynamic> countryData = {
        "IDCountry": mon.uid,
        "NameCountry": mon.name,
        "Latitude": mon.latitude,
        "Longitude": mon.longtitude,
        "CreateAt": mon.createAt,
      };

      final response = await http.put(
        url,
        body: jsonEncode(countryData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<Map<String, Map<String, dynamic>>> ShowAllData() async {
    try {
      final response = await http.get(Uri.parse("$aPIRealTime.json"));
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);
        if (data == null) return {};

        final Map<String, Map<String, dynamic>> countries = {};

        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            countries[key] = value;
          }
        });
        return countries;
      } else {
        return {};
      }
    } catch (e) {
      print('Loi khi show $e');
      return {};
    }
  }}