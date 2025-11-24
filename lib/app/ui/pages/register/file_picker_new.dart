import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerFieldNew extends StatefulWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final Function(PlatformFile)? onFilePicked;

  const FilePickerFieldNew({
    Key? key,
    this.controller,
    this.decoration,
    this.onFilePicked,
  }) : super(key: key);

  @override
  State<FilePickerFieldNew> createState() => _FilePickerFieldNewState();
}

class _FilePickerFieldNewState extends State<FilePickerFieldNew> {
  PlatformFile? _file;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _file = result.files.single;
        widget.controller?.text = _file!.name;
      });
      if (widget.onFilePicked != null) {
        widget.onFilePicked!(_file!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration:
          widget.decoration ??
          const InputDecoration(
            labelText: 'Select a file',
            suffixIcon: Icon(Icons.attach_file),
          ),
      onTap: _pickFile,
    );
  }
}
