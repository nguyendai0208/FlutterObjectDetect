import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:flutter_application_1/src/models/detect-model.dart';

class DetectCategories extends StatelessWidget {
  final Map<String, DetectModel> categories;

  const DetectCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
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
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Color',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: categories.entries.mapIndexed((index, e) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('$index')),
                      DataCell(Text(e.value.category)),
                      DataCell(Text('${e.value.count}')),
                      DataCell(Container(
                        width: 10,
                        height: 10,
                        color: e.value.color,
                      ))
                    ],
                  );
                }).toList())));
  }
}
