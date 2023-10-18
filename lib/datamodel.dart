import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class PersonModel {
  String surname;
  String name;
  String middlename;
  List<String> param = ['Фамилия','Имя','Отчество'];
  PersonModel(this.surname,this.name,this.middlename);
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      json['Фамилия'] ?? '',
      json['Имя'] ?? "",
      json['Отчество'] ?? ""
    );
  }
}

class RequestModel{
  String fio;
  String date;
  bool status;
  RequestModel(this.fio, this.date,this.status);
}

/*
[{"Фамилия":"Самый","Имя":"Главный","Отчество":"Начальник"},
{"Фамилия":"Самый","Имя":"Обычный","Отчество":"Сотрудник"},
{"Фамилия":"Самый","Имя":"Мелкий","Отчество":"Подчиненный"},
{"Фамилия":"1231Иванов","Имя":"Bfsa","Отчество":"Sfdsf"},
{"Фамилия":"Иванов","Имя":"2","Отчество":"Ivanich"},
{"Фамилия":"Иванов","Имя":"Иван","Отчество":"Иванович"},
{"Фамилия":"Иванов","Имя":"Сергей","Отчество":null},
{"Фамилия":"Иванов","Имя":"Петр","Отчество":null},
{"Фамилия":"Иванов","Имя":"Владимир","Отчество":null},
{"Фамилия":"Иванов","Имя":"Петр","Отчество":null}]

 */