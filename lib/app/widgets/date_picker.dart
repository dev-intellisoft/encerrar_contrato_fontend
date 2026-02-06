import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      _controller.text =
          "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _pickDate,
      decoration: const InputDecoration(
        labelText: "Birth date",
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }
}
