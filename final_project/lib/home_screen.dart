import 'package:flutter/material.dart';
import 'package:final_project/note_screen.dart';
import 'package:final_project/database_helper.dart';
import 'note_model.dart';


class NoteHomeScreen extends StatefulWidget {
  const NoteHomeScreen({super.key});

  get note => null;

  @override
  State<NoteHomeScreen> createState() => _NoteHomeScreenState();
}
class _NoteHomeScreenState extends State<NoteHomeScreen>
{

  //Var to be used to show the time in text
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 12, minute: 30);

  //Method to add the choose time function
  void timePicker()
  {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        ).then((value)
    {
      setState(()
      {
        _timeOfDay = value!;
      });
    });
  }

  //A list to store the notes that are similar to your search
  List<NoteModel> myNotes = [];
  List<NoteModel> allNotes = [];

  @override
  //Performs the function at the start of the screen to get all the notes
  void initState()
  {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async
  {
    //Gets all the notes from the database (await to make sure that all the notes are displayed due to delay)
    final notes = await DatabaseHelper.instance.getAllNotes();
    //Refreshes the page to display the new notes
    setState(()
    {
      myNotes = notes;
      allNotes = notes;
    });
  }

  Future<void> deleteNote(int id) async
  {
    //Deletes the notes
    await DatabaseHelper.instance.deleteNote(id);
    //Gets the notes again without the deleted notes, basically acting like a refresh button
    fetchNotes();
  }
  //Function made to filter the notes based on your search
  void filterNotes(String query/* <-- This is the words that you put in the bar*/)
  {
    //This makes it if there is nothing in the search bar it will display all notes
    if (query.isEmpty)
    {
      setState(()
      {
        myNotes = allNotes;
      });
    }
    else
    {
      setState(()
      {
        //Filters through all the notes similar to your search and puts them in myNotes
        myNotes = allNotes.where((note)
        {
          //Makes the search words converted to lowercase in order to work
          return note.title!.toLowerCase().contains(query.toLowerCase());
          //Changes the result of be displayed as a list since the home screen is wrapped in list
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Notes",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.teal),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  //Goes to Add/Edit Screen
                  builder: (context) => const AddNoteScreen(),
                ),
                //Gets the notes data after you open the screen
              ).then((_) => fetchNotes());
            },
            //The Add Note Button
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //The Search Bar Field
            TextFormField(
              onChanged: (value)
              {
                //Filter Your notes based on the title
                filterNotes(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Title',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              //Displays the notes and adds the option to apply separators
              child: ListView.separated(
                //Displays the notes
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: ()
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          //Gets the note data for editing
                          builder: (context) => AddNoteScreen(note: myNotes[index]),
                        ),
                        //Updates the edited notes in the home screen
                      ).then((_) => fetchNotes());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Adds the flex property
                          Expanded(
                            //give a certain percentage of the screen of the said item
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(_timeOfDay.format(context).toString(),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                InkWell(
                                  onTap: ()
                                  {
                                    timePicker();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.teal,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.watch_later_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    // Display note title
                                    myNotes[index].title!,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  // Display note itself
                                  myNotes[index].content!,
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                  textAlign: TextAlign.start,
                                  maxLines: null,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 0),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    //Shows confirm screen if you want to delete
                                    showDialog(
                                      context: context,
                                      //Show the Screen itself
                                      builder: (context) => AlertDialog(
                                        title: const Center(child: Text('Warning')),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Are you sure you want to delete this note?'),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10.0),
                                                  child: MaterialButton(
                                                    minWidth: 130,
                                                    onPressed: ()
                                                    {
                                                      Navigator.pop(context);
                                                    },
                                                    height: 50,
                                                    color: Colors.teal,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25.0),
                                                    ),
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  minWidth: 130,
                                                  onPressed: ()
                                                  {
                                                    // Deletes the Notes
                                                    deleteNote(myNotes[index].id!);
                                                    Navigator.pop(context);
                                                  },
                                                  height: 50,
                                                  color: Colors.teal,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                  ),
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Adds a sized box between each notes displayed
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                //The number of notes allowed to be shown on the screen (in this case it,s all the notes)
                itemCount: myNotes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
