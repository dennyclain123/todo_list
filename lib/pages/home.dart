import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/constants.dart';
import 'package:todo_list_app/database/database.dart';
import 'package:todo_list_app/ob/noteOb.dart';
import 'package:todo_list_app/pages/add_note.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Note>> _noteList;
  final DateFormat _dateFormat = DateFormat("MMM, dd, yyyy");
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateNoteList();
  }
  _updateNoteList(){
    _noteList = databaseHelper.getNoteList();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddNote(
              updateNoteList: _updateNoteList,
            )
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: fg_color,
      ),
      body: FutureBuilder(
        future: _noteList,
        builder: (context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator()
            );
          }
          final int completeNoteCount = snapshot.data!.where((Note note)=>note.status == 1).toList().length;
          return ListView.builder(
            itemCount: int.parse(snapshot.data.length.toString())+1,
            itemBuilder: (context,index){
              if(index == 0){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My Notes",style: TextStyle(
                          color: fg_color,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 10,),
                      Text("${snapshot.data.length} notes"
                        ,style: TextStyle(
                          color: fg_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),)
                    ],
                  ),
                );
              }
              return buildNote(snapshot.data![index - 1]);
            },
          );
        },
      )
    );
  }
  Widget buildNote(Note note){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddNote(
                    updateNoteList: _updateNoteList,
                    note: note
                  )
              ));
            },
            child: ListTile(
              title: Text(note.title!,style: TextStyle(
                fontSize: 18,
                decoration: note.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
              ),),
              subtitle: Text("${_dateFormat.format(note.date!)} - ${note.priority}",style: TextStyle(
                  decoration: note.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
              ),),
              trailing: InkWell(
                onTap: (){
                  databaseHelper.updateNote(note);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddNote(
                      updateNoteList: _updateNoteList,
                    )
                  ));
                },
                  child: Icon(Icons.chevron_right,color: Theme.of(context).primaryColor,)),
            //   trailing: Checkbox(
            //     onChanged: (value){
            //       note.status = value! ? 1 : 0;
            //       databaseHelper.updateNote(note);
            //       _updateNoteList();
            //       Navigator.pushReplacement(context, MaterialPageRoute(
            //         builder: (context) => Home()
            //       ));
            //     },
            //     value: note.status == 1 ? true : false,
            //     activeColor: fg_color,
            // ),
            ),
          ),
          Divider(thickness: 1.5,color: fg_color,)
        ],
      ),
    );
  }
}
