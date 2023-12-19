import 'dart:convert';
import 'package:bastionweb/datamodel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DataLogic {
  String postgresAddress = "http://192.168.1.56:3000";
  String listLink = "/rpc/postgrest_prstest";
  String loginLink = "/rpc/login";
  String _token = "";
  bool _isAuthorized = false;

  Future<List<PersonModel>> getPersonList() async {
    if (kDebugMode) { //TODO remove test implementation GET_PERSON_LIST
      Future.delayed(const Duration(seconds: 5));
      return (json.decode(_mockedList) as List)
          .map((data) => PersonModel.fromJson(data))
          .toList();
    } else {
      if (_isAuthorized || _token.length > 10) {
        try {
          final response = await http.post(
              Uri.parse(postgresAddress + listLink),
              headers: {"Authorization": "Bearer $_token"});
          if (response.statusCode == 200) {
            List<PersonModel> list = (json.decode(response.body) as List)
                .map((data) => PersonModel.fromJson(data))
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
      } else {
        if (kDebugMode) {
          print("token = $_token");
        }
        return Future.error('error caught: NOT AUTHORIZED');
      }
    }
  }


  final String _mockedList = '['
      '{"Фамилия":"Самый","Имя":"Главный","Отчество":"Начальник"},'
      '{"Фамилия":"Самый","Имя":"Обычный","Отчество":"Сотрудник"},'
      '{"Фамилия":"Самый","Имя":"Мелкий","Отчество":"Подчиненный"},'
      '{"Фамилия":"1231Иванов","Имя":"Bfsa","Отчество":"Sfdsf"},'
      '{"Фамилия":"Иванов","Имя":"2","Отчество":"Ivanich"},'
      '{"Фамилия":"Иванов","Имя":"Иван","Отчество":"Иванович"},'
      '{"Фамилия":"Иванов","Имя":"Сергей","Отчество":null},'
      '{"Фамилия":"Иванов","Имя":"Петр","Отчество":null},'
      '{"Фамилия":"Иванов","Имя":"Владимир","Отчество":null},'
      '{"Фамилия":"Иванов","Имя":"Петр","Отчество":null}]';

  Future<bool> login(String login, String pwd) async {
    /*if(kDebugMode){  //TODO remove test implementation LOGIN
      _isAuthorized = true;
      return true;
    }else{

     */
    try {
      final response = await http.post(Uri.parse(postgresAddress + loginLink),
          headers: {"Content-Type": "application/json"},
          body: '{ "username": "$login", "password": "$pwd" }');
      if (response.statusCode == 200) {
        setToken(jsonDecode(response.body)['token']);
        _isAuthorized = true;
        return true;
      } else {
        _isAuthorized = false;
        return Future.error("response error: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('error caught: $e');
      }
      _isAuthorized = false;
      return Future.error('error caught: $e');
    }
  //}
  }

  void logout(){
    _token = "";
    _isAuthorized = false;
  }

  void setToken(String tkn) {
    _token = tkn;
  }
}
