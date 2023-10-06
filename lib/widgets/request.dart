import 'package:bastionweb/datalogic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../datamodel.dart';

class RequestsWidget extends StatefulWidget {
  const RequestsWidget({super.key, required this.dataLogic});

  final DataLogic dataLogic;

  @override
  State<StatefulWidget> createState() => _RequestsStateWidget();
}

class _RequestsStateWidget extends State<RequestsWidget> {
  int _sortIndex = 0;
  bool _asc = false;

  final datalogic = DataLogic();

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  late List<Person> data;

  @override
  initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      data = await datalogic.getPersonList();
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

  void _sort(int ind, bool dir) {
    setState(() {
      _asc = dir;
      _sortIndex = ind;
      switch (_sortIndex) {
        case 0:
          {
            data.sort((a, b) => a.surname.compareTo(b.surname));
          }
        case 1:
          {
            data.sort((a, b) => a.name.compareTo(b.name));
          }
        case 2:
          {
            data.sort((a, b) => a.middlename.compareTo(b.middlename));
          }
        default:
          {
            data.sort((a, b) => a.surname.compareTo(b.surname));
          }
      }
      !_asc ? data = data.reversed.toList() : {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isError
        ? Center(
            child: Card(
                color: const Color.fromRGBO(255, 255, 255, 150.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    _errorMsg,
                    textScaleFactor: 2.0,
                  ),
                  ElevatedButton(
                      onPressed: () => getData(),
                      child: const Text("Повторить"))
                ])))
        : _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Flexible(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return DataTable(
                            sortAscending: _asc,
                            sortColumnIndex: _sortIndex,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 150.0),
                              border: Border.all(
                                color: Colors.black45,
                                width: 3,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            columns: [
                              DataColumn(
                                  label: const Text(
                                    'Фамилия',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onSort: (ind, dir) {
                                    _sort(ind, dir);
                                  }),
                              DataColumn(
                                  label: const Text(
                                    'Имя',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onSort: (ind, dir) {
                                    _sort(ind, dir);
                                  }),
                              DataColumn(
                                  label: const Text(
                                    'Отчество',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  onSort: (ind, dir) {
                                    _sort(ind, dir);
                                  }),
                            ],
                            rows: data
                                .map((e) => DataRow(
                                      cells: [
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(e.surname),
                                          ),
                                        ),
                                        DataCell(Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(e.name),
                                        )),
                                        DataCell(Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(e.middlename),
                                        )),
                                      ],
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  )),
                  const Flexible(
                      flex: 2,
                      child: Card(
                        color: Color.fromRGBO(255, 255, 255, 150.0),
                        child: Center(
                          child: Text(
                            "Подробнее о заявке",
                            textScaleFactor: 3.0,
                          ),
                        ),
                      ))
                ],
              );
  }
}
