import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_note/data/db_note.dart';
import 'package:my_note/data/note_model.dart';

class DetailNote extends StatefulWidget {
  static const routeName = '/DetailNote';
  int Id;

  DetailNote({
    super.key,
    required this.Id,
  });

  @override
  State<DetailNote> createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  final Judultext = TextEditingController();
  final Isitext = TextEditingController();
  DateTime now = DateTime.now();
  late Future<Note?> _noteFuture;

  @override
  void initState() {
    super.initState();
    _noteFuture = DatabaseHelperBar.instance.detailNote(widget.Id);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              FutureBuilder<Note?>(
                future: _noteFuture,
                builder: (BuildContext context, AsyncSnapshot<Note?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('Note not found');
                  } else {
                    Note note = snapshot.data!;
                    return ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: note.Judul ?? '',
                        ),
                        controller: Judultext,
                      ),
                      subtitle: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: note.Isi ?? '',
                        ),
                        controller: Isitext,
                      ),
                    );
                  }
                },
              ),
              FloatingActionButton(
                backgroundColor: Colors.orange[900],
                child: const Icon(Icons.plus_one),
                onPressed: () async {
                  await _doCheck();
                  _refreshData();
                },
              ),
            ],
          )),
        ),
      ),
    );
  }

  Future _doCheck() async {
    if (Judultext.text.isEmpty || Isitext.text.isEmpty) {
      await DatabaseHelperBar.instance.detailNote(widget.Id);
      return;
    }
    Note updatedNote = Note(
      id: widget.Id,
      Judul: Judultext.text,
      Isi: Isitext.text,
      Date: DateFormat('dd-MM-yyyy').format(now),
    );
    await DatabaseHelperBar.instance.update(updatedNote);
  }

  Future<void> _refreshData() async {
    setState(() {
      _noteFuture = DatabaseHelperBar.instance.detailNote(widget.Id);
    });
  }
}


// Column(
//                       children: <Widget>[
//                         TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: note.Judul ?? '',
//                       ),
//                       controller: Judultext,
//                     ),
//                     TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: note.Isi ?? '',
//                       ),
//                       controller: Judultext,
//                     ),
//                       ],
//                     );