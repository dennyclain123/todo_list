import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/database/database.dart';
import 'package:todo_list_app/ob/noteOb.dart';
import 'package:todo_list_app/pages/home.dart';

import '../constants.dart';
class AddNote extends StatefulWidget {
  final Note? note;
  final Function? updateNoteList;
  AddNote({this.note,this.updateNoteList});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String title = '';
  String titleText = "Add Note";
  String btnText = "Add Note";
  var _formkey = GlobalKey<FormState>();
  String priority = "Low";
  var dateTec = TextEditingController();
  DateTime _date = DateTime.now();
  final DateFormat dateFormat = DateFormat("MMM, dd, yyyy");
  final List<String> priorities = ["Low","Medium","High"];


  @override
  void initState() {
    super.initState();
    if(widget.note != null){
      title = widget.note!.title!;
      _date = widget.note!.date!;
      priority = widget.note!.priority!;
      setState(() {
        btnText = "Update Note";
        titleText = "Update Note";
      });
    }else{
      setState(() {
        btnText = "Add Note";
        title = "Add Note";
      });
    }
    dateTec.text = dateFormat.format(_date);
  }


  @override
  void dispose() {
    dateTec.dispose();
    super.dispose();
  }

  handleDate()async{
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(dateTime != null && dateTime != _date){
      setState(() {
        _date = dateTime;
      });
      dateTec.text = dateFormat.format(dateTime);
    }
  }
  submit(){
    if(_formkey.currentState!.validate()){
      _formkey.currentState!.save();
      // print("$title,$_date,$priority");
      Note note = Note(title: title,date: _date,priority: priority);
      if(widget.note == null){
        note.status = 0 ;
        DatabaseHelper.instance.insertNote(note);
        Navigator.pop(context);
      }else{
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);
        Navigator.pop(context);
      }
      widget.updateNoteList!();

    }
  }
  delete(){
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pop(context);
    widget.updateNoteList!();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: Icon(Icons.arrow_back,size: 30,color: Theme.of(context).primaryColor,)),
                ),
                Text(titleText,style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: fg_color
                ),),
                SizedBox(height: 40,),
                TextFormField(
                  onSaved: (input){
                    title = input!;
                  },
                  initialValue: title,
                  validator: (input){
                    if(input!.isEmpty){
                      return "Required Field";
                    }
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: title,
                      filled: false,
                      fillColor: Colors.orange
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (input){
                    if(input!.isEmpty){
                      return "Required Field";
                    }
                  },
                  controller: dateTec,
                  onTap: handleDate,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: 'Date',
                      filled: false,
                      fillColor: Colors.orange
                  ),
                ),
                SizedBox(height: 20,),
                DropdownButtonFormField(
                  validator: (input) => priority == null ? "Please select priority level" : null,
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 22,
                  iconEnabledColor: fg_color,
                  items: priorities.map((String priority){
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 18
                        ),
                      )
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: "Priority",
                    hintStyle: TextStyle(
                        fontSize: 18
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide:  BorderSide(color: fg_color ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide:  BorderSide(color: fg_color ),
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      priority = val.toString();
                    });
                  },
                  value: priority,
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: FlatButton(
                    onPressed: (){
                      bool isValidate = _formkey.currentState!.validate();
                      if(!isValidate){
                        return;
                      }
                      submit();
                    },
                    color: fg_color,
                    textColor: Colors.white,
                    child: Text(btnText,style: TextStyle(
                      fontSize: 18
                    ),),
                  ),
                ),
                SizedBox(height: 10,),
                widget.note != null ? Container(
                  width: double.infinity,
                  height: 40,
                  child: FlatButton(
                    onPressed: (){
                      bool isValidate = _formkey.currentState!.validate();
                      if(!isValidate){
                        return;
                      }
                     delete();
                    },
                    color: fg_color,
                    textColor: Colors.white,
                    child: Text("Delete Note",style: TextStyle(
                        fontSize: 18
                    ),),
                  ),
                ) : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
