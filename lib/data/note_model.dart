// ignore_for_file: non_constant_identifier_names

class Note {
  final int? id;
  final String Judul;
  final String Isi;
  final String Date;

  Note({ this.id,required  this.Judul,required  this.Isi, required this.Date});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json['id'],
        Judul: json['Judul'],
        Isi: json['Isi'],
        Date: json['Date']
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Judul': Judul,
      'Isi': Isi,
      'Date': Date
    };
  }
}