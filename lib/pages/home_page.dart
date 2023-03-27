import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist_firebase/customWidget/todo_card.dart';
import 'package:todolist_firebase/pages/add_todo.dart';
import 'package:todolist_firebase/pages/sign_up_page.dart';
import 'package:todolist_firebase/pages/view_task.dart';
import 'package:todolist_firebase/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String formatDate = new DateFormat("EEEEE dd  MMMM").format(DateTime.now());
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('TaskList').snapshots();
  IconData? iconData;
  Color? iconColor;
  List<checkBox> checkbox = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF1F2630),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0XFF1F2630),
        title: Text(
          'Today Schedule',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(),
          SizedBox(
            width: 25,
          )
        ],
        bottom: PreferredSize(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  formatDate,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(25)),
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Lottie.asset("assets/lotties/nodata.json"),
                    Text(
                      "There is No Task ",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  switch (document['category']) {
                    case 'Work':
                      iconData = Icons.work_outline;
                      iconColor = Colors.greenAccent;
                      break;
                    case 'Food':
                      iconData = Icons.fastfood_outlined;
                      iconColor = Colors.redAccent;
                      break;
                    case 'Study':
                      iconData = Icons.book_outlined;
                      iconColor = Color(0xff0E8388);
                      break;
                    case 'Workout':
                      iconData = Icons.fitness_center_outlined;
                      iconColor = Color(0xffF7C04A);
                      break;
                    case 'Design':
                      iconData = Icons.design_services_outlined;
                      iconColor = Color(0xffEA8FEA);
                      break;
                    case 'Writing':
                      iconData = Icons.draw_outlined;
                      iconColor = Color(0xffF7A4A4);
                      break;
                    case 'Saving':
                      iconData = Icons.payments_outlined;
                      iconColor = Color(0xffC58940);
                      break;
                    case 'Groceries':
                      iconData = Icons.shopping_cart_outlined;
                      iconColor = Color(0XFF4D455D);
                      break;
                    default:
                      iconData = Icons.error;
                      iconColor = Color(0xffaeeee);
                  }
                  checkbox.add(checkBox(
                      id: snapshot.data!.docs[index].id, checkValue: false));
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ViewTask(
                                    task: document,
                                    id: snapshot.data!.docs[index].id,
                                  )));
                    },
                    child: Slidable(
                      endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                            backgroundColor: Colors.redAccent,
                            icon: Icons.delete,
                            label: 'delete',
                            onPressed: ((context) {
                              authService
                                  .deletedDoc(snapshot.data!.docs[index].id);
                            }))
                      ]),
                      child: TodoCard(
                        Check: checkbox[index].checkValue,
                        title: document["taskTitle"],
                        time: '11 PM',
                        iconColor: Colors.white,
                        iconData: iconData!,
                        bgIconColor: iconColor!,
                        index: index,
                        onChange: onChange,
                      ),
                    ),
                  );
                });
          }),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.amberAccent,
          backgroundColor: Color(0XFF1F2630),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 32,
                )),
            BottomNavigationBarItem(
                label: "",
                icon: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [Colors.amberAccent, Colors.blueAccent]),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => addTodo()));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                )),
            BottomNavigationBarItem(
                label: "Log Out",
                icon: InkWell(
                  onTap: () async {
                    await authService.logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => SignUpPage()),
                        (route) => false);
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 32,
                  ),
                )),
          ]),
    );
  }

  void onChange(int index) {
    setState(() {
      checkbox[index].checkValue = !checkbox[index].checkValue;
    });
  }

  Future<DocumentSnapshot> fetchCurrentUserTask(String uuid) async {
    return FirebaseFirestore.instance.collection('TaskList').doc(uuid).get();
  }
}

class checkBox {
  String? id;
  bool checkValue = false;
  checkBox({required this.id, required this.checkValue});
}

//  IconButton(
//               onPressed: () async {
//                 await authService.logout();
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (builder) => SignUpPage()),
//                     (route) => false);
//               },
//               icon: Icon(Icons.logout))