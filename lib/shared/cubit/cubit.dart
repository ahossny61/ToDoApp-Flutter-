import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitStates());
  bool isShow = false;
  IconData floatIcon = Icons.edit;
  Database? database;
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List<String> titles = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  static AppCubit get(context) => BlocProvider.of(context);

  void ChangeCurrentIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomBarState());
  }

  void CreateDB() {
    openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print('Db Created');
      db
          .execute(
              'create table tasks (id integer primary key ,title text, date text, time text, status text)')
          .then((value) {
        print('Table created');
      }).catchError((onError) {
        print('Error ${onError.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDBState());
    });
  }

   InsertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
     await database!.transaction((txn) {

      txn
          .rawInsert(
              'insert into tasks (title,date,time,status) values ("${title}", "${date}","${time}","new")')
          .then((value) {
        print('Inserted Successfuly');
      }).catchError((onError) {
        print(onError.toString());
      });
      return null;
    }).then((value) {
      emit(AppInsertToDBState());
      getDataFromDatabase(database!);
  });
  }

  void getDataFromDatabase(Database database)  {
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    emit(AppGetDBStateLoadState());
    database.rawQuery('select * from tasks').then((value) {
      value.forEach((element) {
        if(element['status']=='new') {
          newTasks.add(element);
          print('New   ${element}');
        }
        else if (element['status']=='Done') {
          doneTasks.add(element);
          print('Done   ${element}');
        }
        else {
          archivedTasks.add(element);
          print('Archived   ${element}');
        }
      });
      emit(AppGetDBState());
    });
  }

  void UpdateDB({required String status,required int id})async{
         database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
           getDataFromDatabase(database!);
          emit(AppUpdateDBState());

          });

    }

  void ChngeBottomSheetState({
    required bool isOpen,
    required IconData iconData,
  }) {
    isShow = isOpen;
    floatIcon = iconData;
    emit(AppChangeBottomSheetState());
  }

  void DeleteFromDB(int id){
     database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
       emit(AppDeleteFromDBState());
       getDataFromDatabase(database!);
     });

  }
}
