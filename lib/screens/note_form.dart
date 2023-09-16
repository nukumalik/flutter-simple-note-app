import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:simplenotes/model/note.dart';
import 'package:uuid/uuid.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({super.key, required this.onSubmit, this.note});

  final Note? note;
  final void Function(Note note) onSubmit;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  quil.QuillController _contentController = quil.QuillController.basic();
  String _formTitle = 'Create Note';
  String _submitButton = 'Save';

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _formTitle = 'Edit Note';
      _submitButton = 'Update';

      var myJSON = jsonDecode(widget.note!.content);
      _contentController = quil.QuillController(
        document: quil.Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      var content = jsonEncode(_contentController.document.toDelta().toJson());

      if (widget.note != null) {
        widget.onSubmit(
          Note(
            id: widget.note!.id,
            title: title,
            content: content,
            createdAt: widget.note!.createdAt,
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        widget.onSubmit(
          Note(
            id: const Uuid().v4(),
            title: title,
            content: content,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }

      // Clear the form fields
      _titleController.clear();
      _contentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(
          Colors.teal.shade50.value,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title cannot be empty'
                      : null,
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      color: Colors.grey.shade300,
                      child: quil.QuillToolbar.basic(
                        controller: _contentController,
                        multiRowsDisplay: false,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 300),
                      child: quil.QuillEditor.basic(
                        controller: _contentController,
                        readOnly: false, // true for view only mode
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: handleSubmit,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.teal.shade400),
                    ),
                    child: Text(
                      _submitButton,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
