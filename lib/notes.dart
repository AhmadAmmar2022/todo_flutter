import 'dart:collection';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flu_sqflite/Setting.dart';
import 'package:flu_sqflite/edit.dart';
import 'package:flu_sqflite/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sqflite/sqflite.dart';
import 'Done.dart';
import 'Faviority.dart';
import 'provider/themProvider.dart';
import 'test.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  SqlDb My_dataa = SqlDb();
  List responsee = [];
  List<Map> fav_list = [];
  bool isloading = true;
  bool onpress = false;
  Color col = Colors.black;

  Future readDataa() async {
    List<Map> res =
        await My_dataa.readData("SELECT * FROM  'notes' where done=0");
    responsee.addAll(res.reversed);
    isloading = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    readDataa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.of(context).pushNamed("AddNotes");
          },
          child: Icon(
            Icons.edit,
            color: Theme.of(context).primaryColor,
          )),
      appBar: AppBar(
        elevation: 8,
      ),
      body: ListView.builder(
          itemCount: responsee.length,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.all(2),
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 3, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Dismissible(
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      key: Key(responsee[index]["title"]),
                      onDismissed: (direction) async {
                        int respo = await My_dataa.deleteData(
                            "delete from notes where id =${responsee[index]['id']}");

                        if (respo > 0) {
                          responsee.removeWhere((element) =>
                              element['id'] == responsee[index]['id']);
                        }
                        setState(() {});
                         Get.snackbar(
              "success",
               "The note has been successfully deleted ",
               icon: Icon(Icons.delete, color: Colors.white),
               snackPosition: SnackPosition.TOP,
               backgroundColor: Color.fromARGB(255, 253, 253, 253),
               borderRadius: 20,
               margin: EdgeInsets.all(15),
               colorText: Color.fromARGB(255, 254, 1, 1),
               duration: Duration(seconds: 4),
               isDismissible: true,
               dismissDirection: DismissDirection.horizontal,
               forwardAnimationCurve: Curves.easeOutBack,
         
               );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                            title: Text(
                              responsee[index]["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: (onpress == false)
                                      ? Icon(Icons.favorite_border,
                                          color: Color.fromARGB(255, 245, 7, 7))
                                      : Icon(Icons.favorite,
                                          color:
                                              Color.fromARGB(255, 245, 7, 7)),
                                  onPressed: () async {
                                    setState(() {
                                      onpress = !onpress;
                                    });

                                    int respo = await My_dataa.updateData(
                                        "UPDATE notes set Faviority=1 where id =${responsee[index]['id']}");
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.done,
                                        color: Color.fromARGB(255, 10, 10, 10)),
                                    onPressed: () async {
                                      int respo = await My_dataa.updateData(
                                          "UPDATE notes set done=1 where id =${responsee[index]['id']}");
                                      if (respo > 0) {
                                        responsee.removeWhere((element) =>
                                            element['id'] ==
                                            responsee[index]['id']);
                                      }
                                      AwesomeDialog(
                                        barrierColor: Colors.white,
                                        context: context,
                                        btnOkColor: Colors.green,
                                        dialogType: DialogType.SUCCES,
                                        body: Center(
                                          child: Text(
                                            'It was added successfully to Done task',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        title: '',
                                        desc: '',
                                        btnOkOnPress: () {},
                                      )..show();

                                      setState(() {});
                                    }),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) => Edit(
                                                note: responsee[index]['note'],
                                                title: responsee[index]
                                                    ['title'],
                                                datee: responsee[index]
                                                    ['Datee'],
                                                id: responsee[index]['id']))));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 97, 77, 207),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  onTap: () {
                    showSlidingBottomSheet(context,
                        builder: (context) => SlidingSheetDialog(
                            cornerRadius: 16,
                            avoidStatusBar: true,
                            snapSpec: SnapSpec(
                                initialSnap: 0.7, snappings: [0.4, 0.7, 1]),
                            builder: (context, state) => Material(
                                  child: ListView(
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.all(15),
                                    children: [
                                      Builder(builder: (context) {
                                        return Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "${responsee[index]['title']}",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.black,
                                              height: 20,
                                              thickness: 2,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                    ),
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        SheetController.of(
                                                                context)!
                                                            .expand();
                                                      },
                                                      child: Text("Read More",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    )),
                                                SizedBox(
                                                  width: 150,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Icons.close,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "${responsee[index]['note']}",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                )));
                  },
                ),
                SizedBox(
                  height: 1,
                )
              ],
            );
          })),
    );
  }

  // showSnackBar(context, index) {
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     backgroundColor: Colors.blue,
  //     duration: Duration(
  //       milliseconds: 700,
  //     ),
  //     content: Text(
  //       "deleted",
  //       style: TextStyle(color: Colors.white),
  //     ),
  //   ));
  // }
}
