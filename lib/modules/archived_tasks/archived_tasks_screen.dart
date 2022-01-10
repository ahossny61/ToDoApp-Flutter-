import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class ArchiveTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {},
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return TaskBuilder(tasks: cubit.archivedTasks);
        });
  }

}