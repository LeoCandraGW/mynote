import 'package:flutter/material.dart';
import 'package:my_note/UI/detail_note.dart';
import 'package:my_note/UI/note_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
        routes: {
          '/': (context) => const NoteList(),
          NoteList.routeName: (context) => NoteList(),
          DetailNote.routeName: (context) => DetailNote(
            Id: ModalRoute.of(context)?.settings.arguments as int
          ),
        },
    );
  }
}