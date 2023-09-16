import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

class NoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.json');
  }

  Future<File> writeNotes(List<Note> notes) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(notes));
  }

  Future<List<Note>> readNotes() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<Note> notes = [];
      List json = jsonDecode(contents);
      for (var note in json) {
        notes.add(Note(
          id: note['id'],
          title: note['title'],
          content: note['content'],
          createdAt: note['createdAt'],
          updatedAt: note['updatedAt'],
        ));
      }
      return notes;
    } catch (e) {
      return [];
    }
  }
}
