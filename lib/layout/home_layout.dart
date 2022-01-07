
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget{
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child:Icon(
          Icons.add,
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
}