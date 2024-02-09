import 'package:bastionweb/widgets/fields/titledcard.dart';
import 'package:flutter/material.dart';

class PersonalInfoWidget extends StatelessWidget {
  const PersonalInfoWidget({
    super.key,
    required this.surnameController,
    required this.nameController,
    required this.middleNameController,
    required this.selectDate,
    required this.serialNumberController,
  });

  final TextEditingController surnameController;
  final TextEditingController nameController;
  final TextEditingController middleNameController;
  final TextEditingController serialNumberController;
  final void Function(DateTime dateTime) selectDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: MediaQuery.of(context).size.width > 650
            ? TitledCard(
                color: Theme.of(context).primaryColorDark,
                title: 'Персональные данные',
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  fit: FlexFit.loose,
                                  flex: 1,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: TextField(
                                        controller: surnameController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Фамилия"),
                                      ))),
                              Flexible(
                                  fit: FlexFit.loose,
                                  flex: 1,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Имя"),
                                      ))),
                              Flexible(
                                  fit: FlexFit.loose,
                                  flex: 1,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: TextField(
                                        controller: middleNameController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Отчество"),
                                      )))
                            ],
                          )),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    fit: FlexFit.loose,
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        child: TextField(
                                          controller: serialNumberController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  "Серия и номер паспорта"),
                                        ))),
                                Flexible(
                                    fit: FlexFit.loose,
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        child: InputDatePickerFormField(
                                          keyboardType: TextInputType.datetime,
                                          firstDate: DateTime.now(),
                                          fieldLabelText: "Дата рождения",
                                          onDateSaved: (dateTimeSaved) =>
                                              {selectDate(dateTimeSaved)},
                                          lastDate: DateTime.now(),
                                        ))),
                              ]))
                    ]))
            : TitledCard(
                color: Theme.of(context).primaryColorDark,
                title: 'Персональные данные',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: surnameController,
                              decoration:
                                  const InputDecoration(labelText: "Фамилия"),
                            ))),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: nameController,
                              decoration:
                                  const InputDecoration(labelText: "Имя"),
                            ))),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: middleNameController,
                              decoration:
                                  const InputDecoration(labelText: "Отчество"),
                            ))),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: serialNumberController,
                              decoration: const InputDecoration(
                                  labelText: "Серия и номер паспорта"),
                            ))),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: InputDatePickerFormField(
                              fieldLabelText: "Дата Рождения",
                              keyboardType: TextInputType.datetime,
                              firstDate: DateTime.now(),
                              onDateSaved: (dateTimeSaved) =>
                                  {selectDate(dateTimeSaved)},
                              lastDate: DateTime.now(),
                            )))
                  ],
                )));
  }
}
