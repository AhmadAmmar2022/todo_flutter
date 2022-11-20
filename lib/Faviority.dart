import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flu_sqflite/notes.dart';
import 'package:flu_sqflite/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'edit.dart';

class Faviority extends StatefulWidget {
  final responsee;
  const Faviority({Key? key, this.responsee}) : super(key: key);

  @override
  State<Faviority> createState() => _FaviorityState();
}

class _FaviorityState extends State<Faviority> {
  SqlDb My_dataa = SqlDb();
  List done_list = [];

  Future readDataa() async {
    List<Map> res =
        await My_dataa.readData("SELECT * FROM  'notes' where Faviority=1");

    done_list.addAll(res.reversed);
    // isloading = false;
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
          itemCount: done_list.length,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.all(2),
                    //  padding: EdgeInsets.symmetric(vertical: 15),
                    height: 90,
                    //color: Color.fromARGB(255, 255, 253, 253),
                    decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   begin: Alignment.centerLeft,
                        //   end: Alignment.centerRight,
                        //   colors: [
                        //     Color.fromARGB(255, 117, 73, 248),
                        //     Color.fromARGB(255, 136, 117, 247),
                        //     Color.fromARGB(255, 163, 141, 252),
                        //     Color.fromARGB(255, 188, 159, 252),
                        //     Color.fromARGB(255, 192, 165, 248),
                        //     Color.fromARGB(255, 198, 178, 248),
                        //     Color.fromARGB(255, 221, 221, 250),
                        //   ],
                        // ),
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
                      key: Key(done_list[index]["title"]),
                      onDismissed: (direction) async {
                        int respo = await My_dataa.deleteData(
                            "delete from notes where id =${done_list[index]['id']}");

                        if (respo > 0) {
                          done_list.removeWhere((element) =>
                              element['id'] == done_list[index]['id']);
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
                              done_list[index]["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.favorite_border,
                                      color: Color.fromARGB(255, 245, 7, 7)),
                                  onPressed: () async {
                                    int respo = await My_dataa.updateData(
                                        "UPDATE notes set Faviority=1 where id =${done_list[index]['id']}");
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.done,
                                        color: Color.fromARGB(255, 10, 10, 10)),
                                    onPressed: () async {
                                      int respo = await My_dataa.updateData(
                                          "UPDATE notes set done=1 where id =${done_list[index]['id']}");
                                      if (respo > 0) {
                                        done_list.removeWhere((element) =>
                                            element['id'] ==
                                            done_list[index]['id']);
                                      }
                                      AwesomeDialog(
                                        context: context,
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
                                                note: done_list[index]['note'],
                                                title: done_list[index]
                                                    ['title'],
                                                datee: done_list[index]
                                                    ['Datee'],
                                                id: done_list[index]['id']))));
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
                                                  "${done_list[index]['title']}",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 105, 10, 3)),
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
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  254,
                                                                  254)
                                                              .withOpacity(1),
                                                          spreadRadius: 12,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              1), // changes position of shadow
                                                        ),
                                                      ],
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
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      15,
                                                                      11,
                                                                      11))),
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
                                        "${done_list[index]['note']}",
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
  //     backgroundColor: Colors.red,
  //     duration: Duration(
  //       milliseconds: 500,
  //     ),
  //     content: Text("deleted"),
  //   ));
  // }
}
