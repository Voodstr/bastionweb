import 'package:bastionweb/widgets/fields/titledcard.dart';
import 'package:flutter/material.dart';
import 'fields/dateintervalwidget.dart';
import 'fields/fiowidget.dart';

class RequestWidget extends StatefulWidget {
  const RequestWidget({super.key});

  @override
  State<StatefulWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime bd = DateTime.now();
  DateTime ed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Card(
            color: Theme.of(context).cardColor.withOpacity(0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Text(
                      "Новая заявка",
                      style: Theme.of(context).textTheme.headlineLarge,
                    )),
                Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: FioWidget(
                        surnameController: surnameController,
                        nameController: nameController,
                        middleNameController: middleNameController)),
                Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: DateIntervalWidget(
                      title: "Период действия:",
                      selectDateRange: (DateTimeRange dateTimeRange) {
                        bd = dateTimeRange.start;
                        ed = dateTimeRange.end;
                      },
                      dateFormat: "d MMM yyyy",
                    )),
              ],
            )));
  }
}
