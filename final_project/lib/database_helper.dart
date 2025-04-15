import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'note_model.dart';
//Manages Database operations
class DatabaseHelper
{
  //Creates a shared instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  //Stores that instance in Database
  static Database? _database;
  //Private Constructor to be used only in database helper (Encapsulation)
  DatabaseHelper._init();

  Future<Database> get database async
  {
    if (_database != null) return _database!;
    //Creates a new database connection if the line above fails
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async
  {
    //Get the path where the database is stored
    final dbPath = await getDatabasesPath();
    //Creates a full path to the database
    final path = join(dbPath, filePath);
    //Opens the created path
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async
  {
    //Creates the table to store data
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
  }

  // Method to add a new note
  Future<int> insertNote(NoteModel note) async
  {
    //Establishes a connection to the database
    final db = await instance.database;
    //Inserts data into the tables
    return await db.insert('notes', note.toMap());
  }

  // Method to retrieve all the notes
  Future<List<NoteModel>> getAllNotes() async
  {
    //Establishes a connection to the database
    final db = await instance.database;
    //Stores the notes in a var called result
    final result = await db.query('notes');
    //Converts the results from maps to the model created
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  //Method to edit a note
  Future<int> updateNote(NoteModel note) async
  {
    //Establishes a connection to the database
    final db = await instance.database;
    return await db.update(
      //Name of the table
      'notes',
      //Converts from the model we created to map to be stored in the table
      note.toMap(),
      //Defines the place to store the data based on the id number
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  //Method to a delete note
  Future<int> deleteNote(int id) async
  {
    //Establishes a connection to the database
    final db = await instance.database;
    //Deletes the chosen place
    return await db.delete(
      //Converts from the model we created to map to be stored in the table
    'notes',
      //Defines the place to store the data based on the id number
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
