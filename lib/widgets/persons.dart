import 'package:bastionweb/datalogic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../datamodel.dart';

class PersonsWidget extends StatefulWidget {
  const PersonsWidget({super.key, required this.dataLogic});

  final DataLogic dataLogic;

  @override
  State<StatefulWidget> createState() => _PersonsStateWidget();
}

class _PersonsStateWidget extends State<PersonsWidget> {
  int _sortIndex = 0;
  bool _asc = false;
  int _selected = 0;

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  late List<PersonModel> persons;

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
      persons = await widget.dataLogic.getPersonList();
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
            persons.sort((a, b) => a.surname.compareTo(b.surname));
          }
        case 1:
          {
            persons.sort((a, b) => a.name.compareTo(b.name));
          }
        case 2:
          {
            persons.sort((a, b) => a.middlename.compareTo(b.middlename));
          }
        default:
          {
            persons.sort((a, b) => a.surname.compareTo(b.surname));
          }
      }
      !_asc ? persons = persons.reversed.toList() : {};
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
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return DataTable(
                              clipBehavior: Clip.hardEdge,
                              sortAscending: _asc,
                              sortColumnIndex: _sortIndex,
                              decoration: BoxDecoration(
                                color:
                                    const Color.fromRGBO(255, 255, 255, 150.0),
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 3,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              columns: [
                                DataColumn(
                                    label: const Text(
                                      'Фамилия',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onSort: (ind, dir) {
                                      _sort(ind, dir);
                                    }),
                                DataColumn(
                                    label: const Text(
                                      'Имя',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onSort: (ind, dir) {
                                      _sort(ind, dir);
                                    }),
                                DataColumn(
                                    label: const Text(
                                      'Отчество',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onSort: (ind, dir) {
                                      _sort(ind, dir);
                                    }),
                              ],
                              rows: persons
                                  .map((e) => DataRow(
                                        cells: [
                                          DataCell(Text(e.surname),
                                              onTap: () => {selectPerson(e)}),
                                          DataCell(Text(e.name),
                                              onTap: () => {selectPerson(e)}),
                                          DataCell(Text(e.middlename),
                                              onTap: () => {selectPerson(e)}),
                                        ],
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: Container(
                        color: const Color.fromRGBO(255, 255, 255, 150.0),
                        child: Center(
                          child: Column(children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Icon(Icons.photo,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                6),
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 3,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Flexible(
                                                child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      persons[_selected]
                                                          .surname,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))),
                                            Flexible(
                                                child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      persons[_selected].name,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))),
                                            Flexible(
                                                child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      persons[_selected]
                                                          .middlename,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )))
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            const Flexible(
                              fit: FlexFit.tight,
                              flex: 3,
                              child: Card(
                                color: Color.fromRGBO(255, 255, 255, 100.0),
                                child: FittedBox(),
                              ),
                            )
                          ]),
                        ),
                      ))
                ],
              );
  }

  /*
   [Text(persons[_selected].surname),Text(persons[_selected].name,),Text(persons[_selected].middlename)]
   */
  selectPerson(PersonModel e) {
    setState(() {
      _selected = persons.indexOf(e);
    });
  }
}
