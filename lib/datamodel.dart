import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PersonModel {
  String surname;
  String name;
  String middlename;
  List<String> param = ['Фамилия', 'Имя', 'Отчество'];

  PersonModel(this.surname, this.name, this.middlename);

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
        json['Фамилия'] ?? '', json['Имя'] ?? "", json['Отчество'] ?? "");
  }
}

class RequestModel {
  String f;
  String i;
  String o;
  DateTime bdate;
  String sPass;
  String nPass;
  String cardType;
  DateTime cardDateBegin;
  DateTime cardDateEnd;
  DateTime cardTimeBegin;
  DateTime cardTimeEnd;

  Map<String, dynamic> param() {
    return {
      'Фамилия': f,
      'Имя': i,
      'Отчество': o,
      'Дата рождения': bdate,
      'Серия документа': sPass,
      'Номер документа': nPass,
      'Тип пропуска': cardType,
      'Дата начала действия пропуска': cardDateBegin,
      'Дата окончания действия пропуска': cardDateBegin,
      'Время начала действия пропуска': cardTimeBegin,
      'Время окончания действия пропуска': cardTimeEnd
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
        json['Фамилия'] ?? '',
        json['Имя'] ?? "",
        json['Отчество'] ?? "",
        DateTime.parse(json['Дата рождения'] ?? ''),
        json['Серия документа'] ?? '',
        json['Номер документа'] ?? '',
        json['Тип пропуска'] ?? '',
        DateTime.parse(json['Дата начала действия пропуска'] ?? ''),
        DateTime.parse(json['Дата окончания действия пропуска'] ?? ''),
        DateTime.parse(json['Время начала действия пропуска'] ?? ''),
        DateTime.parse(json['Время окончания действия пропуска'] ?? ''));
  }

  String _dateFormater(DateTime dateTime) =>
      DateFormat('dd.MM.yyyy').format(dateTime);

  String _timeFormater(DateTime dateTime) => DateFormat.Hm().format(dateTime);

  RequestModel(
      this.f,
      this.i,
      this.o,
      this.bdate,
      this.sPass,
      this.nPass,
      this.cardType,
      this.cardDateBegin,
      this.cardDateEnd,
      this.cardTimeBegin,
      this.cardTimeEnd);

  Map<String, dynamic> toJson() => {
        'f': f,
        'i': i,
        'o': o,
        'd': _dateFormater(bdate),
        's': sPass,
        'n': nPass,
        't': cardType,
        'bd': _dateFormater(cardDateBegin),
        'ed': _dateFormater(cardDateEnd),
        'bt': _timeFormater(cardTimeBegin),
        'et': _timeFormater(cardTimeEnd),
      };
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
