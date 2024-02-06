import 'package:bastionweb/widgets/fields/titledcard.dart';
import 'package:flutter/material.dart';

class FioWidget extends StatelessWidget {
  const FioWidget({
    super.key,
    required this.surnameController,
    required this.nameController,
    required this.middleNameController,
  });

  final TextEditingController surnameController;
  final TextEditingController nameController;
  final TextEditingController middleNameController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: MediaQuery.of(context).size.width > 650
            ? TitledCard(
                color: Theme.of(context).primaryColorDark,
                title: 'Персональные данные',
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
                ))
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
                            )))
                  ],
                )));
  }
}
