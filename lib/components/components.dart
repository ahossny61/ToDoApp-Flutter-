

import 'package:flutter/material.dart';

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
  bool isSecure=false,
  required String label,
  required TextEditingController controller,
  required TextInputType type,
  void Function(String value)? onSubmitFunc,
  void Function(String value)? onChangedFunc,
  required  String?Function(String ?value) onValidateFunc,
  required IconData prefixIcon,
  IconData? suffixIcon,
  void Function()? suffixPressedFunc,
  void Function()? onTabFunc,

}) =>
    TextFormField(
      obscureText:isSecure ,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        //border: InputBorder.none
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon!=null?IconButton(
            onPressed: suffixPressedFunc,
            icon: Icon(suffixIcon)
        ):null,
      ),
      onFieldSubmitted: onSubmitFunc,
      onChanged: onChangedFunc,
      style: TextStyle(fontSize: 20.0, color: Colors.blue),
      validator: onValidateFunc,
      onTap:onTabFunc ,
    );
Widget BuildTaskItem(int index)
=> Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(tasks[index]['time'].toString()),
        ),
        SizedBox(width: 15.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tasks[index]['title'].toString(),
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              tasks[index]['date'].toString(),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300
              ),
            ),
          ],
        )
      ],
    ),
  );
