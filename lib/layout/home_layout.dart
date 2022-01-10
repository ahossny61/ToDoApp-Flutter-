import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var statusController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreateDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertToDBState){
            Navigator.pop(context);
            AppCubit.get(context).ChngeBottomSheetState(
                isOpen: false, iconData: Icons.edit);
            titleController.text = "";
            dateController.text = "";
            timeController.text = "";
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: state is AppGetDBStateLoadState
                ? Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.InsertToDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text);
                  }
                } else {
                  cubit.ChngeBottomSheetState(
                      isOpen: true, iconData: Icons.add);
                  scaffoldKey.currentState!
                      .showBottomSheet(

                        (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    label: 'Task Title',
                                    controller: titleController,
                                    type: TextInputType.text,
                                    onValidateFunc: (value) {
                                      if (value!.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.title,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                      label: 'Task Date',
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      onValidateFunc: (value) {
                                        if (value!.isEmpty) {
                                          return 'Date must not be empty';
                                        }
                                        return null;
                                      },
                                      prefixIcon: Icons.calendar_today,
                                      onTabFunc: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-05-05'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      }),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      label: 'Task Time',
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      onValidateFunc: (value) {
                                        if (value!.isEmpty) {
                                          return 'Time must not be empty';
                                        }
                                        return null;
                                      },
                                      prefixIcon: Icons.watch_later_outlined,
                                      onTabFunc: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.ChngeBottomSheetState(isOpen: false, iconData: Icons.edit);
                  });
                }
              },
              child: Icon(
                cubit.floatIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeCurrentIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
