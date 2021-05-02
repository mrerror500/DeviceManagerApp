import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_manager/HomePage.dart';

import 'DatabaseSetUp/Database.dart';
import 'Model/User.dart';
import 'UserMenu.dart';

class RoomPage extends StatefulWidget{
  final User user;
  final String roomName;
  const RoomPage(this.user, this.roomName);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage>{
  DBProvider _dbProvider;

  @override
  void initState(){
    super.initState();
    setState(() {
      _dbProvider = DBProvider.dbProviderInstance;
    });
  }
  List<String> deviceName = [];
  List<int> tapped = [];
  int _currentIndex = 0;

  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(widget.roomName),
          /*Row(
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              Icon(Icons.person, size: 30),
              Text('\t${widget.user.name}')],
          )*/
      ),
      body: _viewRoom(),
      bottomNavigationBar: _navBar(),
    );
  }

  _viewRoom()=>
      Center(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: deviceName.length,
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Dismissible(
                  movementDuration: Duration(milliseconds: 50),
                  resizeDuration: Duration(milliseconds: 50),
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_){
                    setState(() {
                      deviceName.removeAt(index);
                      if(tapped.contains(index)){
                        tapped.remove(index);
                      }
                    });
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      //borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    //margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white
                        ),
                    ),
                 ),
                  child: Container(
                    color: tapped.contains(index) ? Colors.green : Colors.white,
                    child: GestureDetector(
                      child: new Card(
                        color: tapped.contains(index) ? Colors.green : Colors.white,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        //elevation: 5,
                        child: new Container(
                          height: 60,
                          alignment: Alignment.center,
                          margin: new EdgeInsets.all(10),
                          child: Text(
                            deviceName[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          if(tapped.contains(index)){
                            tapped.remove(index);
                          }else{
                            tapped.add(index);
                          }
                        });
                      },
                    )
                  ),
                ),
              ),
            );
          },
        )
      );

  _navBar()=>
      BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items:[
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.home_outlined,
                    size: 30
                ),
                label: 'Home',
                backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.add_box_outlined,
                    size: 30
                ),
                label: 'Add Device',
                backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.info_outline,
                    size: 30
                ),
                label: 'Help',
                backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ),
                label:'Exit',
                backgroundColor: Colors.grey
            ),
          ],
          onTap: (val){
            setState(() {
              _currentIndex = val;
              if(_currentIndex == 0){
                Navigator.pop(context);
                setState(() {});
              }
              if(_currentIndex == 1) {
                getDevice(context, "Add device").then((name) {
                  if (name != null && name != "") {
                    deviceName.add(name);
                    print(deviceName.length);
                    setState(() {});
                  }
                });
              }
              if(_currentIndex == 3){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context)=>MyHomePage()),(Route<dynamic> route)=>false);
                setState(() {});
              }
            });

          }
      );

  Future<String> getDevice(BuildContext context, String message) async{
    String txt = "";
    bool ok = false;
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)
          ),
          backgroundColor: Colors.black,
          contentPadding: const EdgeInsets.all(10.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: myController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(
                                color: Colors.white
                            )
                        ),
                        labelText: message,
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "e.g. Kitchen"
                    ),
                  )
              )
            ],
          ),
          actions: <Widget>[
            //ignore: deprecated_member_use
            new RaisedButton(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
                onPressed: (){
                  myController.clear();
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: const Text("Cancel")),
            //ignore: deprecated_member_use
            new RaisedButton(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
                onPressed: (){
                  ok = true;
                  txt = myController.text;
                  myController.clear();
                  Navigator.of(context, rootNavigator: true).pop(context);
                },
                child: const Text("Ok"))
          ],
        )
    );
    if (!ok) return "";
    return txt;
  }
}