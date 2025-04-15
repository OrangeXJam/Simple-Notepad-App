//The note model
//The Class


class NoteModel
{
  int? id;
  String? title;
  String? content;
//The Constructor
  NoteModel(
      {
        this.id,
        this.title,
        this.content,
      });

  // Converts items from the note model to map in order to store in the database
  Map<String, dynamic> toMap()
  {
    return
      {
        'id': id,
        'title': title,
        'content': content,
      };
  }

  // Converts items from map to the note model in order to display
  factory NoteModel.fromMap(Map<String, dynamic> map)
  {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}

