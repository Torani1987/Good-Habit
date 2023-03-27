import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoCard extends StatelessWidget {
  const TodoCard(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.time,
      required this.Check,
      required this.bgIconColor,
      required this.onChange,
      required this.index})
      : super(key: key);
  final Color bgIconColor;
  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool Check;
  final Function onChange;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  activeColor: Color(0xff6cf8a9),
                  checkColor: Color(0xff0e3e26),
                  value: Check,
                  onChanged: (value) {
                    onChange(index);
                  }),
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color(0xff5e616a),
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                color: Color(0xff2a2e3d),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 33,
                    width: 36,
                    decoration: BoxDecoration(
                        color: iconColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      iconData,
                      color: bgIconColor,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          decoration: Check
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(time,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 15,
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
