import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/components/components.dart';
import 'package:todoapp/components/constants.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context,index)=>BuildTaskItem(index), separatorBuilder:(context,index)=>Container(width: double.infinity,height: 1.0,color: Colors.grey[300],), itemCount:tasks.length );
  }

}