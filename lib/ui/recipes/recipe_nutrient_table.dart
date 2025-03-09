import 'package:flutter/material.dart';

class RecipeNutrientTable extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final bool isEditable;

  const RecipeNutrientTable({
    super.key,
    required this.controllers,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow('Portion', '100g', isHeader: true),
          _buildTableRow('Calories', controllers['calories']!, isNumeric: true),
          _buildTableRow('Protein', controllers['protein']!, isNumeric: true),
          _buildTableRow('Fat', controllers['fat']!, isNumeric: true),
          _buildTableRow('Carbohydrates', controllers['carbohydrates']!,
              isNumeric: true),
          _buildTableRow('Fiber', controllers['fiber']!, isNumeric: true),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, dynamic value,
      {bool isHeader = false, bool isNumeric = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isEditable
              ? TextFormField(
                  controller: value,
                  keyboardType:
                      isNumeric ? TextInputType.number : TextInputType.text,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontSize: 18),
                )
              : Text(
                  value is TextEditingController ? value.text : value,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
        ),
      ],
    );
  }
}
