import 'package:flutter/material.dart';

class DataTableFromJson extends DataTable {
  DataTableFromJson(
      {super.key, required super.columns, required super.rows, required this.data});

  final List<dynamic> data;
}