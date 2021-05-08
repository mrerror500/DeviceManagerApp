import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:smart_manager/Login.dart';

import 'DatabaseSetUp/Database.dart';
import 'HomePage.dart';
import 'Model/User.dart';
import 'RoomPage.dart';

class UserMenu extends StatefulWidget {
  final User user;
  const UserMenu(this.user);

  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  DBProvider _dbProvider;


  @override
  void initState() {
    super.initState();
    setState(() {
      _dbProvider = DBProvider.dbProviderInstance;
    });
  }
  List<String>roomName = [];
  int _currentIndex=0;

  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 30,
                color: Colors.white
              ),
              onPressed: (){
                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()),(Route<dynamic> route)=>false);
              },
            )
          ],
          title: Row(
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              Icon(Icons.person, size: 30),
              Text('\t${widget.user.name}')],
          )
      ),
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: roomName.length,
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 15,
            //   mainAxisSpacing: 4,
            //   childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4)
            // ),
            itemBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                  child:ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Dismissible(
                      resizeDuration: Duration(milliseconds: 50),
                      movementDuration: Duration(milliseconds: 50),
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_){
                        setState(() {
                          roomName.removeAt(index);
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

                      child: OpenContainer(
                        openBuilder: (context, _)=> RoomPage(widget.user, roomName[index]),
                        closedBuilder:(context, VoidCallback openContainer) =>
                          GestureDetector(
                            child: new Card(
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              //elevation: 5,
                              child: new Container(
                                height: 50,
                                alignment: Alignment.center,
                                margin: new EdgeInsets.all(10),
                                child: new Text(
                                  roomName[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                    ),
                                ),
                              ),
                            ),
                            onTap: (){
                              openContainer();
                            },
                          )
                      ),
                    )
                  )
              );
            },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
                label: 'Add Room',
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
            setState((){
              _currentIndex = val;
              if(_currentIndex == 1){
                getText(context, "Add room").then((name){
                  if(name!= null && name != ""&& name != " "){
                    roomName.add(name);
                    print(roomName.length);
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
      ),
    );
  }
  Future<String> getText(BuildContext context, String message) async{
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
            new RaisedButton(
              color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
                onPressed: (){
                  txt = myController.text;
                  myController.clear();
                  ok = true;
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