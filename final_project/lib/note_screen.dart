import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:final_project/database_helper.dart';
import 'note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>
{
  //Controls the Form state to check for validation
  final _formKey = GlobalKey<FormState>();
  //Saves the inputted text from the user to save in the database
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  //Loads up previous saved data
  void initState()
  {
    super.initState();
    if (widget.note != null)
    {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  // Handles adding and editing notes
  Future<void> saveNote() async
  {
    //Checks if the form is built or not, if not it will not do the code
    if (_formKey.currentState?.validate() ?? false)
    {
      log("Form is valid. Saving note...");
      final newNote = NoteModel(
        id: widget.note?.id,
        title: titleController.text,
        content: contentController.text,
      );

      if (widget.note == null)
      {
        // Insert new note if there's no existing note
        await DatabaseHelper.instance.insertNote(newNote);
      }
      else
      {
        // Update existing note if it's being edited
        await DatabaseHelper.instance.updateNote(newNote);
      }
      // Go back to the previous screen after saving
      Navigator.pop(context);
    }
    else
      {
        log("Form is invalid.");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.note == null ? "New Note" : "Editing Note",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.teal,
          ),
        ),
        leading: IconButton(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
        ),
        actions: [
          TextButton(onPressed:()
          {
            Navigator.pop(context);
          },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.teal),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //Manages the validation  of this form
          key: _formKey,
          child: ListView(
            children: [
              // Title TextField
              TextFormField(
                //Connects to the TextEditingController in order to take the input
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: const TextStyle(color: Colors.blueGrey),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  //Padding for the text itself in the text field
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                ),
                validator: (value)
                {
                  if (value == null || value.isEmpty)
                  {
                    return "Title can't be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Content TextField
              TextFormField(
                controller: contentController,
                maxLines: 21,
                decoration: InputDecoration(
                  hintText: 'Details',
                  hintStyle: const TextStyle(color: Colors.blueGrey),
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
                //Makes Sure you inputted text
                validator: (value)
                {
                  if (value == null || value.isEmpty)
                  {
                    return "Details can't be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                //the function above to save the note in the database
                onPressed: saveNote,
                height: 50,
                minWidth: 500,
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
