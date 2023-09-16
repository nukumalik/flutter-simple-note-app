import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simplenotes/model/note.dart';
import 'package:simplenotes/screens/note_form.dart';
import 'package:simplenotes/screens/note_detail.dart';
import 'package:simplenotes/widgets/note_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key, required this.noteStorage});

  final NoteStorage noteStorage;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    widget.noteStorage.readNotes().then((value) {
      setState(() {
        _notes = value;
      });
    });
  }

  Future<File> _handleDeleteNote(String id) {
    setState(() {
      _notes = _notes.where((note) => note.id != id).toList();
    });
    Navigator.popUntil(context, (route) => route.isFirst);

    return widget.noteStorage.writeNotes(_notes);
  }

  Future<File> _handleSubmitNote(Note note) {
    var exists = _notes.any((element) => element.id == note.id);
    if (exists) {
      setState(() {
        _notes =
            _notes.map((value) => value.id == note.id ? note : value).toList();
      });
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NoteDetail(
          note: note,
          onDelete: _handleDeleteNote,
          onUpdate: _handleSubmitNote,
        );
      }));
    } else {
      setState(() {
        _notes.add(note);
      });
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    return widget.noteStorage.writeNotes(_notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(
          Colors.teal.shade50.value,
        ),
      ),
      body: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NoteDetail(
                  note: _notes[index],
                  onDelete: _handleDeleteNote,
                  onUpdate: _handleSubmitNote,
                );
              })),
              child: NoteItem(note: _notes[index]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteForm(
                  onSubmit: _handleSubmitNote,
                ),
              ));
        },
        backgroundColor: Color(Colors.teal.shade50.value),
        child: const Icon(Icons.add),
      ),
    );
  }
}
