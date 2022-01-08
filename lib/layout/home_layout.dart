
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/components/components.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget{
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var titleController=TextEditingController();
  var scaffoldKey=GlobalKey<ScaffoldState>();
  bool isShow=false;
  IconData floatIcon=Icons.edit;
  Database ?database;
  int currentIndex=0;
  List<Widget> screens=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List<String>titles=[
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  @override
  void initState() {

    super.initState();
    CreateDB();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(isShow) {
            Navigator.pop(context);
            setState(() {
              floatIcon=Icons.edit;
            });
          }
          else{
            setState(() {
              floatIcon=Icons.add;
            });
          scaffoldKey.currentState!.showBottomSheet((context)=>
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultFormField(
                        label: 'Task Title'
                        , controller: titleController
                        , type: TextInputType.text,
                        onValidateFunc: (value){
                          if(value!.isEmpty) {
                            return 'title must not be empty';
                          }
                          return null;
                        },
                        prefixIcon: Icons.title,
                    )
                  ],
                ),
              ),
            ),
          );

        }
          isShow=!isShow;
          },
        child:Icon(
          floatIcon,
        ) ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex=index;
          });

        },
        items: [
          BottomNavigationBarItem(
              icon:Icon(Icons.menu),
            label: 'Tasks'
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.check_circle_outline),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.archive_outlined),
            label: 'Archived',
          )
        ],
      ),
    );
  }

  void CreateDB()async{
    print('create db ');
    database=await openDatabase(
        'todo.db',
      version: 1,
      onCreate:(db, version) {
          print('Db Created');
          db.execute('create table tasks (id integer primary key ,title text, date text, time text, status text)').then((value){
            print('Table created');
          }).catchError((onError){
            print('Error ${onError.toString()}');
          });
      },
    );
  }
  void InsertToDatabase(){
    database!.transaction((txn){
      txn.rawInsert('insert into tasks (title,date,time,status) values ("first task", "2022","5 pm","not")').then((value){ print ('Inserted Successfuly');}).catchError((onError){print(onError.toString());});
      return null;
    });
  }
}