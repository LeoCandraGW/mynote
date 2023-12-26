import 'package:flutter/material.dart';
import 'package:my_note/UI/detail_note.dart';
import 'package:my_note/data/db_note.dart';
import 'package:my_note/data/note_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  static const routeName = '/NoteList';
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Future<List<Note>> _notesFuture;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _notesFuture = DatabaseHelperBar.instance.getNote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDEFBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.plusSquare,
                      size: 38,
                      color: Color(0xffDEFBFF),
                    ),
                    Text(
                      'My Note',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: InkWell(
                          onTap: () async {
                            await DatabaseHelperBar.instance.add(
                              Note(
                                Judul: "Judul",
                                Isi: "Isi",
                                Date: DateFormat('dd-MM-yyyy').format(now),
                              ),
                            );
                            _refreshData();
                          },
                          child: Icon(
                            FontAwesomeIcons.plusSquare,
                            size: 38,
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Color(0xffCF4AAA),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<Note>>(
                  future: DatabaseHelperBar.instance.getNote(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Note>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading...'));
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('No Barcode In List'))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Set the number of columns
                              crossAxisSpacing:
                                  8.0, // Set spacing between columns
                              mainAxisSpacing: 8.0, // Set spacing between rows
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Note note = snapshot.data![index];
                              return Center(
                                child: InkWell(
                                  onTap: (() {
                                    Navigator.pushNamed(
                                      context,
                                      DetailNote.routeName,
                                      arguments: note.id,
                                    );
                                  }),
                                  onDoubleTap: () {
                                    DatabaseHelperBar.instance.remove(note.id!);
                                    _refreshData();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffCDCF4A),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              note.Judul,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                note.Isi,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            Text(
                                              note.Date,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
