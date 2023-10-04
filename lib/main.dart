import 'dart:js';

import 'package:bastionweb/datalogic.dart';
import 'package:flutter/material.dart';

import 'datamodel.dart';

void main() {
  runApp(const BastionWeb());
}

class BastionWeb extends StatelessWidget {
  const BastionWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bastion Web Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainWidget(title: 'Bastion Web'),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.title});

  final String title;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _sortIndex = 0;
  bool _asc = false;

  final datalogic = DataLogic();

  bool _isLoading = false;

  void _update() {
    getData();
  }

  late List<Person> data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    data = await datalogic.getPersonList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DataTable(
                      sortAscending: _asc,
                      sortColumnIndex: _sortIndex,
                      decoration: BoxDecoration(
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
                            ),
                            onSort: (ind, dir) {
                              _sort(ind, dir);
                            }),
                        DataColumn(
                            label: const Text(
                              'Имя',
                              textAlign: TextAlign.center,
                            ),
                            onSort: (ind, dir) {
                              _sort(ind, dir);
                            }),
                        DataColumn(
                            label: const Text(
                              'Отчество',
                              textAlign: TextAlign.center,
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
                                      padding: const EdgeInsets.all(10),
                                      child: Text(e.surname),
                                    ),
                                  ),
                                  DataCell(Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(e.name),
                                  )),
                                  DataCell(Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(e.middlename),
                                  )),
                                ],
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
            floatingActionButton: IconButton(
                onPressed: () => _update(), icon: const Icon(Icons.update)),
          );
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
}
