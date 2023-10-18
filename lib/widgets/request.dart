import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            fit: FlexFit.tight,flex: 1,
            child: Card(
                color: Theme.of(context).cardColor.withOpacity(0.5),
                child: const FittedBox(
                  child: Text("1"),
                ))),
        Flexible(
            fit: FlexFit.tight,flex: 2,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              child: const FittedBox(child: Text("2")),
            ))
      ],
    ));
  }
}
