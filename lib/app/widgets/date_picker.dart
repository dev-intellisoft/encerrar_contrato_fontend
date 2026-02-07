import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  final String label;
  final void Function(DateTime)? onChanged;

  const DateInput({
    super.key,
    this.label = "Data",
    this.onChanged,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final TextEditingController _controller = TextEditingController();

  // ===== PALETA ENCERRAR =====
  static const primario = Color(0xFF5E17EB);
  static const claro = Color(0xFF36BAFE);
  static const bg = Color(0xFF070710);
  static const bg2 = Color(0xFF0B0B12);

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),

      // ⭐ THEME DARK DEL PICKER
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: primario,
              surface: bg2,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: bg2,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      _controller.text =
          "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";

      widget.onChanged?.call(date);
    }
  }

  InputDecoration _decoration() {
    return InputDecoration(
      labelText: widget.label,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(.75),
        fontWeight: FontWeight.w700,
      ),
      suffixIcon: const Icon(Icons.calendar_today, color: claro),
      filled: true,
      fillColor: Colors.white.withOpacity(.06),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(.12),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: primario.withOpacity(.75),
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      cursorColor: primario,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 13,
      ),
      onTap: _pickDate,
      decoration: _decoration(),
    );
  }
}
