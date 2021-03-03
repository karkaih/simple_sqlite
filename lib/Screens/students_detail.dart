import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sqlite_by_me/Helpers/db_helper.dart';
import 'package:sqlite_by_me/Models/student.dart';
import 'dart:async';

class StudentDetail extends StatefulWidget {
  String titre;
  Students student;

  StudentDetail(this.titre, this.student);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Students_detail(titre, this.student);
  }
}

class Students_detail extends State<StudentDetail> {
  String titre1;
  Students student1;

  static var _status = ["successed", "faild"];

  TextEditingController studentsName = new TextEditingController();
  TextEditingController studentsDetail = new TextEditingController();

  Students_detail(this.titre1, this.student1);

  Students st = new Students.test();

  DB_helper helper = DB_helper();
  String dropdownValue = "successed";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    studentsName.text = student1.Name;
    studentsDetail.text = student1.Desc;
    // st.Name = studentsName.text;
    // st.Desc = studentsName.text;
    return Scaffold(
      appBar: AppBar(
        title: Text(titre1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10),
            child: Center(
              child: DropdownButton(
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  items: _status.map((String e) {
                    return DropdownMenuItem<String>(value: e, child: Text(e));
                  }).toList(),
                  value: getPassing(student1.Stat),
                  onChanged: (newvalue) {
                    setState(() {
                      setPatssing(newvalue);
                    });
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                st.Name = value;
                student1.Name=value ;
              },
              controller: studentsName,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: Theme.of(context).textTheme.headline6,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: studentsDetail,
              onChanged: (value) {
                st.Desc = value;
                student1.Desc=value;
              },
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: Theme.of(context).textTheme.headline6,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      if (student1.id != null) {
                       int result = await helper.update(student1);
                       if(result == 0 ){
                         showAlertDialog("Sorry", "Student not updated");
                       }
                       else{
                         goBack();
                         showAlertDialog("Congratulation", "Student updated");
                       }

                      } else {
                        Save();
                      }
                    },
                    child: Text(
                      student1.id != null ? "Update" : "Saved",
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      debugPrint("Delete Clicked"+student1.id.toString());
                      goBack();
                      await helper.delete(student1.id);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Insert
  void setPatssing(String value) {
    // if ( value!= null) {
    //   if(value=="successed")
    //   {
    //     st.Stat = 0;
    //   }
    //   else{
    //     st.Stat = 1;
    //   }
    //
    // }
    // else{
    //   st.Stat = 0;
    // }
    switch (value) {
      case "successed":
        st.Stat = 0;
        student1.Stat = 0;
        break;
      case "faild":
        st.Stat = 1;
        student1.Stat = 1;
        break;
    }
  }

// Save( )

  void Save() async {
    st.Dt = DateFormat.yMMMd().format(DateTime.now());
    if (st.Name != null && st.Desc != null) {
      var result = helper.insertUser(st);
      if (result == 0) {
        showAlertDialog("Sorry", "Student Not Saved");
        debugPrint("Sorry");
      } else {
        goBack();
        showAlertDialog("Congratulation", "Student Save " + st.Stat.toString());
        // debugPrint("Congratulation");

      }
    } else {
      showAlertDialog1(context);
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  // Display
  String getPassing(int value) {
    String pass;
    switch (value) {
      case 0:
        pass = _status[0];
        st.Stat = 0;
        break;
      case 1:
        pass = _status[1];
        st.Stat = 1;
        break;
    }
    return pass;
  }

  //Goback
  void goBack() {
    Navigator.pop(context);
  }

  //

  showAlertDialog1(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sorry"),
      content: Text("You shld fill all the fields"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
