import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addTodo extends StatefulWidget {
  const addTodo({super.key});

  @override
  State<addTodo> createState() => _addTodoState();
}

class _addTodoState extends State<addTodo> {
  @override
  TextEditingController taskTitle = TextEditingController();
  TextEditingController description = TextEditingController();
  String taskType = '';
  String category = '';

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0XFF1F2630),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          letterSpacing: 1.5,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'New Task',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label('Task Title'),
                    SizedBox(
                      height: 10,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    label('Task Type'),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 2,
                      direction: Axis.horizontal,
                      children: [
                        taskTypeSelect('Important', 0xffff6d6e),
                        taskTypeSelect('Planned', 0xff2bc8d9),
                        taskTypeSelect("Reminder", 0xff609966),
                        taskTypeSelect('Project', 0xffF7C04A)
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label('Description'),
                    SizedBox(
                      height: 10,
                    ),
                    Description('Add Description Your Task'),
                    SizedBox(
                      height: 25,
                    ),
                    label('Category'),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                        spacing: 8,
                        runSpacing: 2,
                        direction: Axis.horizontal,
                        children: [
                          categorySelect('Food', 0xffEA5455),
                          categorySelect('Study', 0xff0E8388),
                          categorySelect("Work", 0xff609966),
                          categorySelect('Workout', 0xffF7C04A),
                          categorySelect('Design', 0xffEA8FEA),
                          categorySelect('Writing', 0xffF7A4A4),
                          categorySelect('Saving', 0xffC58940),
                          categorySelect('Groceries', 0xff4D455D)
                        ]),
                    SizedBox(
                      height: 25,
                    ),
                    Button(),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection('TaskList').add({
          'taskTitle': taskTitle.text,
          'taskType': taskType,
          'category': category,
          'description': description.text,
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.amberAccent[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Add Task',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }

  Widget Description(String label) {
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0XFF2A2E3D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: description,
        maxLines: null,
        style: TextStyle(color: Colors.white, fontSize: 17),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget taskTypeSelect(
    String label,
    int color,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          taskType = label;
        });
      },
      child: Chip(
        backgroundColor: taskType == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        label: Text(
          label,
          style: TextStyle(
              color: taskType == label ? Colors.black : Colors.white,
              fontSize: 17),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 3.8, horizontal: 17),
      ),
    );
  }

  Widget categorySelect(
    String label,
    int color,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        backgroundColor: category == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        label: Text(
          label,
          style: TextStyle(
              color: category == label ? Colors.black : Colors.white,
              fontSize: 17),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 3.8, horizontal: 17),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0XFF2A2E3D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: taskTitle,
        style: TextStyle(color: Colors.white, fontSize: 17),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Add Title Your Task",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.5),
    );
  }
}
