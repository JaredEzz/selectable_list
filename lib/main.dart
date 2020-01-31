import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SelectableDate {
  DateTime dateTime;
  bool isSelected;
  bool isArchived;
  bool isDeleted;

  SelectableDate(DateTime dateTime) {
    this.dateTime = dateTime;
    this.isSelected = false;
    this.isArchived = false;
    this.isDeleted = false;
  }

  toggleSelect() {
    isSelected = !isSelected;
  }

  toggleArchive() {
    isArchived = !isArchived;
  }

  toggleDelete() {
    isDeleted = !isDeleted;
  }

  toString() {
    return dateTime.toString();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _addDate() {
    setState(() {
      dates.add(SelectableDate(DateTime.now()));
    });
  }

  List<SelectableDate> dates = [
    SelectableDate(DateTime.parse("19920109")),
    SelectableDate(DateTime.parse("20150110")),
    SelectableDate(DateTime.parse("20180110")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                'The length of your list is:',
              ),
            ),
            Text(
              '${dates.length}',
              style: Theme.of(context).textTheme.display1,
            ),
            Column(
              children: map<Widget>(dates, (index, SelectableDate date) {
                return (date.isArchived || date.isDeleted) ? Container() : Card(
                  color: date.isSelected
                      ? Color.lerp(
                          Colors.white38,
                          index % 2 == 0
                              ? Colors.blueAccent
                              : Colors.greenAccent,
                          0.8)
                      : Color.lerp(
                          Colors.black38,
                          index % 2 == 0
                              ? Colors.blueAccent
                              : Colors.greenAccent,
                          0.5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Slidable(
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(date.isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                              onPressed: (){
                                setState(() {
                                  date.toggleSelect();
                                });
                              },
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Card #${index + 1}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("${date.toString()}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))
                              ],
                            ),
                          ),
                          actionPane: SlidableDrawerActionPane(),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Archive',
                            color: Colors.orange,
                            icon: Icons.archive,
                            onTap: (){
                              setState(() {
                                date.toggleArchive();
                              });
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Archived"),
                                  action: SnackBarAction(
                                    label: "Undo",
                                    onPressed: (){
                                      setState(() {
                                        date.toggleArchive();
                                      });
                                      _scaffoldKey.currentState.hideCurrentSnackBar();
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Archive Undone"),
                                        action: SnackBarAction(label: "Okay", onPressed: (){
                                          _scaffoldKey.currentState.hideCurrentSnackBar();
                                        }),
                                      ));
                                    },
                                  ),
                                )
                              );
                            },

                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            foregroundColor: Colors.black,
                            onTap: (){
                              setState(() {
                                date.toggleDelete();
                              });
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Deleted"),
                                    action: SnackBarAction(
                                      label: "Undo",
                                      onPressed: (){
                                        setState(() {
                                          date.toggleDelete();
                                        });
                                        _scaffoldKey.currentState.hideCurrentSnackBar();
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Text("Deleting Undone"),
                                          action: SnackBarAction(label: "Okay", onPressed: (){
                                            _scaffoldKey.currentState.hideCurrentSnackBar();
                                          }),
                                        ));
                                      },
                                    ),
                                  )
                              );
                            },

                          )
                        ],


                      )),

                );
              }),
            ),
            RaisedButton(
              child: Text("Clear"),
              onPressed: () {
                setState(() {
                  dates.clear();
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDate,
        tooltip: 'Add Date',
        child: Icon(Icons.calendar_today),
      ),
    );
  }
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}
