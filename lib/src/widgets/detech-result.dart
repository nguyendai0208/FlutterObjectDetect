
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class DetectCategories extends StatelessWidget {
  final List<MapEntry<dynamic, int>> categories;

  const DetectCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                '#',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Category',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Count',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
        rows: categories.mapIndexed((index, e) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text('$index')),
              DataCell(Text('${e.key ?? ''}')),
              DataCell(Text('${e.value}')),
            ],
          );
        }).toList());
  }
}
