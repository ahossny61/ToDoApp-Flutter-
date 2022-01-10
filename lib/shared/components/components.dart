import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

import 'constants.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 45.0,
  Color color = Colors.blue,
  required void Function() function,
  required String text,
  double radius = 0.0,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
        ),
      ),
    );

Widget defaultFormField({
  bool isSecure = false,
  required String label,
  required TextEditingController controller,
  required TextInputType type,
  void Function(String value)? onSubmitFunc,
  void Function(String value)? onChangedFunc,
  required String?Function(String ?value) onValidateFunc,
  required IconData prefixIcon,
  IconData? suffixIcon,
  void Function()? suffixPressedFunc,
  void Function()? onTabFunc,

}) =>
    TextFormField(
      obscureText: isSecure,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        //border: InputBorder.none
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? IconButton(
            onPressed: suffixPressedFunc,
            icon: Icon(suffixIcon)
        ) : null,
      ),
      onFieldSubmitted: onSubmitFunc,
      onChanged: onChangedFunc,
      style: TextStyle(fontSize: 20.0, color: Colors.blue),
      validator: onValidateFunc,
      onTap: onTabFunc,
    );

Widget BuildTaskItem(Map map, context) =>
    Dismissible(
      key: Key(map['id'].toString()),
      child: Padding(

        padding: const EdgeInsets.all(15.0),

        child: Row(

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            CircleAvatar(

              radius: 40.0,

              child: Text(map['time'].toString()),

            ),

            SizedBox(width: 15.0,),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(

                    map['title'].toString(),

                    style: TextStyle(

                        fontSize: 18.0,

                        fontWeight: FontWeight.bold

                    ),

                  ),

                  Text(

                    map['date'].toString(),

                    style: TextStyle(

                        fontSize: 12.0,

                        fontWeight: FontWeight.w300

                    ),

                  ),

                ],

              ),

            ),

            SizedBox(width: 15.0,),

            IconButton(

              onPressed: () {
                AppCubit.get(context).UpdateDB(status: 'Done', id: map['id']);
              },

              icon: Icon(Icons.check_box),

              color: map['status'] != 'Done' ? Colors.black45 : Colors.blue,

            ),

            IconButton(

              onPressed: () {
                AppCubit.get(context).UpdateDB(
                    status: 'Archived', id: map['id']);
              },

              icon: Icon(Icons.archive),

              color: map['status'] != 'Archived' ? Colors.black45 : Colors.blue,

            ),

          ],

        ),

      ),
      onDismissed: (direction) {
        AppCubit.get(context).DeleteFromDB(map['id']);
      },
    );

Widget TaskBuilder
    ({
  required List<Map>tasks,
}) {
  if (tasks.length == 0) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu, size: 100.0, color: Colors.grey,),
          Text(
            'No Tasks Yet, Add some tasks',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
  else {
    return ListView.separated(itemBuilder: (context, index) =>
        BuildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) =>
            Container(
              width: double.infinity, height: 1.0, color: Colors.grey[300],),
        itemCount: tasks.length);
  }
}
