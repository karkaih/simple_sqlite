import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_by_me/Helpers/db_helper.dart';
import 'package:sqlite_by_me/Models/student.dart';
import 'package:sqlite_by_me/Screens/students_detail.dart';

class StudentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentsState();
  }
}

class StudentsState extends State<StudentList> {
  DB_helper helper = new DB_helper();
  Students st = new Students.test();
  Future<List<Students>> lst;
  TextEditingController recherche = new TextEditingController();
  String test;
  String txt = "No One with this Name";
  int count = 0;

  List<Students> studentList;

  @override
  Widget build(BuildContext context) {
    if (studentList == null) {
      studentList = new List<Students>();
      updateListView();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Students",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: recherche,
              onChanged: (value) {
                updateListView(value);
              },
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: Theme.of(context).textTheme.headline5,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          Expanded(
              child: count != 0
                  ? getStudentList()
                  : Center(
                      child: Text(
                      txt,
                      style: TextStyle(color: Colors.black26, fontSize: 25),
                    ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToStudent(context, "Add Student", Students("", "", "", 0));
          debugPrint("Clicked");
        },
        tooltip: "ADD Student",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getStudentList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, index) {
          return Card(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            shadowColor: Colors.grey,
            color: index % 2 == 0 ? Colors.blue : Colors.white,
            elevation: 12,
            child: ListTile(
              title: Text(studentList[index].Name),
              subtitle:
                  Text(studentList[index].Desc + " " + studentList[index].Dt),
              leading: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: Icon(
                    getIcon(studentList[index].Stat),
                    color: Colors.red,
                    size: 25,
                  )),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, studentList[index]);
                  debugPrint(" hello you clicked 1 " +
                      studentList[index].id.toString());
                },
              ),
              onTap: () {
                navigateToStudent(context, "Edit Student", studentList[index]);
                // var x = studentList[index].Stat ;
                // debugPrint("$x");
              },
            ),
          );
        });
  }

// Navigate to other page passing name
  void navigateToStudent(
      BuildContext context, String appTitle, Students st) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StudentDetail(appTitle, st);
    }));
    updateListView();
  }

  // Delete student
  void _delete(BuildContext context, Students st) async {
    int result = await helper.delete(st.id);
    if (result != 0) {
      _showSenckBarr(
          context, " Student has been deleted   " + st.id.toString());
      // Update ListView
      updateListView();
    }
  }

//ShowsnackBar = Toast f android

  void _showSenckBarr(BuildContext context, String msg) {
    final snackbar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  //
  updateListView([String name]) {
    if (name != null) {
      setState(() {
        lst = helper.getStudent(name);
        lst.then((thelist) => setState(() {
              this.studentList = thelist;
              this.count = thelist.length;
            }));
      });
    } else {
      setState(() {
        lst = helper.getStudents();
        lst.then((thelist) => setState(() {
              this.studentList = thelist;
              this.count = thelist.length;
            }));
      });
    }
  }

  //getIcon

  dynamic getIcon(int c) {
    switch (c) {
      case 0:
        return Icons.check;
        break;
      case 1:
        return Icons.close;
        break;
    }
  }
}
