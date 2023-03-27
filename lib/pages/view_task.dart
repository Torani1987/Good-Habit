import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTask extends StatefulWidget {
  ViewTask({Key? key, required this.task, required this.id}) : super(key: key);
  final Map<String, dynamic> task;
  final String id;
  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  @override
  void initState() {
    super.initState();
    String title = widget.task['taskTitle'] == null
        ? 'there is no data'
        : widget.task['taskTitle'];
    taskTitle = TextEditingController(text: title);
    description = TextEditingController(text: widget.task['description']);
    taskType = widget.task['taskType'];
    category = widget.task['category'];
  }

  @override
  TextEditingController taskTitle = TextEditingController();
  TextEditingController description = TextEditingController();
  String taskType = '';
  String category = '';
  bool edit = false;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        edit = !edit;
                      });
                    },
                    icon: Icon(
                      Icons.mode_edit_outline_outlined,
                      color: edit ? Colors.amberAccent : Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? 'Change' : 'View',
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
                      "Your Task",
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
                    edit ? Button() : Container(),
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
        FirebaseFirestore.instance
            .collection('TaskList')
            .doc(widget.id)
            .update({
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
            'Edit Task',
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
        enabled: edit,
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
      onTap: edit
          ? () {
              setState(() {
                taskType = label;
              });
            }
          : null,
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
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
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
        enabled: edit,
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
