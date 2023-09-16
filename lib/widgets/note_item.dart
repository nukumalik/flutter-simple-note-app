import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simplenotes/model/note.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;

class NoteItem extends StatefulWidget {
  const NoteItem({super.key, required this.note});

  final Note note;

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  quil.QuillController _contentController = quil.QuillController.basic();

  @override
  void initState() {
    super.initState();
    getContent();
  }

  void getContent() {
    var myJSON = jsonDecode(widget.note.content);
    _contentController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.note.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        _contentController.document.toPlainText(),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
