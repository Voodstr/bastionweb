import 'package:bastionweb/datamodel.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../datalogic.dart';
import 'fields/keycardwidget.dart';
import 'fields/persinfowidget.dart';

class RequestWidget extends StatefulWidget {
  const RequestWidget({super.key, required this.dataLogic});

  final DataLogic dataLogic;

  @override
  State<StatefulWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController serialNumberController = TextEditingController();
  DateTime birthDate = DateTime.now();
  int? cardType = 99;

  DateTime bd = DateTime.now();
  DateTime ed = DateTime.now();
  DateTime bt = DateTime.now();
  DateTime et = DateTime.now();

  void selectBirthDate(DateTime dateTime) {
    birthDate = dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                child: PersonalInfoWidget(
                  surnameController: surnameController,
                  nameController: nameController,
                  middleNameController: middleNameController,
                  selectDate: selectBirthDate,
                  serialNumberController: serialNumberController,
                )),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: KeycardWidget(
                title: "Данные пропуска",
                selectDateRange: (DateTimeRange dateTimeRange) {
                  bd = dateTimeRange.start;
                  ed = dateTimeRange.end;
                },
                selectTimeRange: (TimeRange timeRange){
                  bt = DateTime(2027,1,1,timeRange.startTime.hour,timeRange.startTime.minute);
                  et = DateTime(2027,1,1,timeRange.endTime.hour,timeRange.endTime.minute);
                },
                dateFormat: "d MMM yyyy",
                selectCardType: (int? cType) {
                  cardType = cType;
                },
              ),
            ),
            FilledButton(
                onPressed: () => {
                      widget.dataLogic.putRequest(RequestModel(
                          nameController.text,
                          surnameController.text,
                          middleNameController.text,
                          birthDate,
                          serialNumberController.text.substring(0,4),
                          serialNumberController.text.substring(4),
                          cardType.toString(),
                          bd,
                          ed,
                          bt,
                          et))
                    },
                child: Text("Отправить заявку"))
          ],
        ));
  }
}
