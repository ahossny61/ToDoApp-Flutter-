
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/components/components.dart';
import 'package:todoapp/components/constants.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import'package:intl/intl.dart';

class HomeLayout extends StatefulWidget{
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var titleController=TextEditingController();
  var dateController=TextEditingController();
  var timeController=TextEditingController();
  var statusController=TextEditingController();
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
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
      body: tasks.length==0?Center(child: CircularProgressIndicator()):screens[currentIndex],
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          if(isShow) {

            if(formKey.currentState!.validate()){

              InsertToDatabase(title:titleController.text,date: dateController.text,time: timeController.text).then((value){
                getDataFromDatabase(database!).then((value){
                  Navigator.pop(context);
                  setState(() {
                    tasks=value;
                    isShow=false;
                    floatIcon=Icons.edit;
                    titleController.text="";
                    dateController.text="";
                    timeController.text="";
                  });

              });
          });}}
          else{
            setState(() {
              floatIcon=Icons.add;
            });
          scaffoldKey.currentState!.showBottomSheet((context)=>
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
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
                      ),
                      SizedBox(height: 15,),
                      defaultFormField(
                        label: 'Task Date'
                        , controller: dateController
                        , type: TextInputType.datetime,
                        onValidateFunc: (value){
                          if(value!.isEmpty) {
                            return 'Date must not be empty';
                          }
                          return null;
                        },
                        prefixIcon: Icons.calendar_today,
                        onTabFunc: (){
                         showDatePicker(context: context, initialDate:DateTime.now() , firstDate:DateTime.now() , lastDate:DateTime.parse('2022-05-05')).then((value) {
                           dateController.text=DateFormat.yMMMd().format(value!);
                         });
                        }
                      ),
                      SizedBox(height: 15.0,),
                      defaultFormField(
                          label: 'Task Time'
                          , controller: timeController
                          , type: TextInputType.datetime,
                          onValidateFunc: (value){
                            if(value!.isEmpty) {
                              return 'Time must not be empty';
                            }
                            return null;
                          },
                          prefixIcon: Icons.watch_later_outlined,
                          onTabFunc: (){
                            showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                              timeController.text=value!.format(context);
                            });
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),
            elevation: 20.0,

          ).closed.then((value){
            isShow=false;
            //Navigator.pop(context);
            setState(() {
              floatIcon=Icons.edit;

            });
          });
            isShow=true;
        }

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
      onOpen: (database){
          getDataFromDatabase(database).then((value){
            setState(() {
              tasks=value;
            });

            //print(tasks);
          });
      }
    );
  }
  Future InsertToDatabase({
  required String title,
    required String date,
    required String time,
})async
  {
    return await database!.transaction((txn){
      txn.rawInsert('insert into tasks (title,date,time,status) values ("${title}", "${date}","${time}","new")').then((value){ print ('Inserted Successfuly');}).catchError((onError){print(onError.toString());});
      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(Database database)async{
   return await database.rawQuery('select * from tasks');
  }
}