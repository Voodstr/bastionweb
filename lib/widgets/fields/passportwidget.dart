import 'package:bastionweb/widgets/fields/titledcard.dart';
import 'package:flutter/material.dart';

class PassportWidget extends StatelessWidget {
  const PassportWidget({
    super.key,
    required this.selectDate,
    required this.serialNumberController,
    required this.departmentNameController,
  });

  final TextEditingController serialNumberController;
  final void Function(DateTime dateTime) selectDate;
  final TextEditingController departmentNameController;

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.all(10),
    child: TitledCard(
        color: Theme.of(context).primaryColorDark,
        title: 'Паспортные данные',
        child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child:Column(
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
                                controller: serialNumberController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Серия и Номер"),
                              ))),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: InputDatePickerFormField(
                                firstDate: DateTime.now(),
                                onDateSaved: (dateTimeSaved) =>
                                {selectDate(dateTimeSaved)},
                                lastDate: DateTime.now(),
                              ))),
                    ])),
            Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    child: TextField(
                      controller: departmentNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Паспорт выдан"),
                    )))
          ],
        ))));
  }
}
