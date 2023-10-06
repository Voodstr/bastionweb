import 'dart:convert';
import 'package:bastionweb/datamodel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DataLogic {
  String postgresAddress = "http://192.168.1.56:3000";
  String listLink = "/rpc/postgrest_prstest";
  bool _isAuthorized = false;

  Future<List<Person>> getPersonList()async{
    try {
      final response = await http.get(Uri.parse(postgresAddress+listLink));
      if (response.statusCode == 200) {
        List<Person> list = (json.decode(response.body) as List)
            .map((data) => Person.fromJson(data))
            .toList();
        return list;
      } else {
        return Future.error("response error: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('error caught: $e');
      }
      return Future.error('error caught: $e');
    }
    return [Person("surname", "name", "middlename")];
  }

  Future<bool> login(String login, String pwd) async{
    if(login=="admin"&&pwd=="123") {
      _isAuthorized = true;
      return true;
    }else {
      return false;
    }
  }


}