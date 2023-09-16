import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplenotes/model/note.dart';
import 'package:simplenotes/screens/note_form.dart';
import 'package:simplenotes/widgets/delete_dialog.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;

enum NoteDetailAction { edit, delete }

class NoteDetail extends StatefulWidget {
  const NoteDetail(
      {super.key,
      required this.note,
      required this.onDelete,
      required this.onUpdate});

  final Note note;
  final void Function(String id) onDelete;
  final void Function(Note note) onUpdate;

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  quil.QuillController _contentController = quil.QuillController.basic();

  @override
  void initState() {
    super.initState();
    getContent();
  }

  void handleActionSelected(BuildContext context, NoteDetailAction action) {
    if (action == NoteDetailAction.edit) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteForm(
              onSubmit: widget.onUpdate,
              note: widget.note,
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return DeleteDialog(
                onDelete: () => widget.onDelete(widget.note.id));
          });
    }
  }

  void getContent() {
    var myJSON = jsonDecode(widget.note.content);
    _contentController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMMEEEEd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(
          Colors.teal.shade50.value,
        ),
        actions: [
          PopupMenuButton<NoteDetailAction>(
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (action) => handleActionSelected(context, action),
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<NoteDetailAction>>[
                const PopupMenuItem<NoteDetailAction>(
                  value: NoteDetailAction.edit,
                  child: Text('Edit'),
                ),
                const PopupMenuItem<NoteDetailAction>(
                  value: NoteDetailAction.delete,
                  child: Text('Delete'),
                ),
              ];
            },
          ),
        ],
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Text(
                widget.note.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatDate(widget.note.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            Text(_contentController.document.toPlainText()),
            // Text(
            //   widget.note.content,
            //   style: const TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
