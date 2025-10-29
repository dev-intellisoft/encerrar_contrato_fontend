import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;
  const FilePickerField({super.key, required this.controller, this.decoration});

  @override
  State<FilePickerField> createState() => _FilePickerFieldState();
}

class _FilePickerFieldState extends State<FilePickerField> {
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      setState(() {
        widget.controller.text = file.name; // Mostra o nome no campo
      });

      // Aqui você pode usar file.path para enviar o arquivo
      print('Arquivo selecionado: ${file.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // evita digitação manual
      decoration: widget.decoration,
      onTap: _pickFile, // também abre o seletor ao clicar no campo
    );
  }
}

