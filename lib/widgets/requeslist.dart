import 'package:bastionweb/datalogic.dart';
import 'package:bastionweb/datamodel.dart';
import 'package:flutter/material.dart';

class RequestListWidget extends StatefulWidget {
  const RequestListWidget({super.key, required this.dataLogic});

  final DataLogic dataLogic;

  @override
  State<StatefulWidget> createState() => _RequestListWidgetState();
}

class _RequestListWidgetState extends State<RequestListWidget> {
  String responseText = "GEt request list";
  List<RequestModel> requestList = [];

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  @override
  initState() {
    super.initState();
    updateRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return _isError
        ? Center(
            child: Card(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    _errorMsg,
                    textScaleFactor: 2.0,
                  ),
                  ElevatedButton(
                      onPressed: () => updateRequestList(),
                      child: const Text("Повторить"))
                ])))
        : _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  children: [
                    DataTable(
                        columns: [
                          DataColumn(label: Text("Фамилия")),
                          DataColumn(label: Text("Имя")),
                          DataColumn(label: Text("Отчество"))
                        ],
                        rows: requestList
                            .map((e) => DataRow(cells: [
                                  DataCell(Text(e.f),
                                      onTap: () => {selectRequest(e, context)}),
                                  DataCell(Text(e.i),
                                      onTap: () => {selectRequest(e, context)}),
                                  DataCell(Text(e.o),
                                      onTap: () => {selectRequest(e, context)})
                                ]))
                            .toList()),
                    ElevatedButton(
                        onPressed: () => updateRequestList(),
                        child: Text("Запрос"))
                  ],
                ),
              );
  }

  Future<void> selectRequest(RequestModel requestModel, BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Заявка от ${requestModel.f}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: requestModel.param().entries.map((e) => Text("${e.key}: ${e.value}")).toList(),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Подтвердить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Отклонить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateRequestList() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      requestList = await widget.dataLogic.getRequestList();
      _isError = false;
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isError = true;
      });
      return Future.error(e);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
