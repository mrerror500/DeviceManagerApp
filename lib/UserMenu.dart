import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DatabaseSetUp/Database.dart';
import 'HomePage.dart';
import 'Model/User.dart';

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
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()),(Route<dynamic> route)=>false);
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
        child: GridView.builder(
            itemCount: roomName.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 4,
              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4)
            ),
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    elevation: 5,
                    child: new Container(
                      alignment: Alignment.center,
                      margin: new EdgeInsets.all(10),
                      child: new Text(roomName[index]),
                    ),
                  ),
                onTap: (){

                },
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
            setState(() async {
              _currentIndex = val;
              if(_currentIndex == 1){
                String name;
                name = await getText(context, "New room");
                if(name!= null){
                  roomName.add(name);
                  print(roomName.length);
                }
              }
              if(_currentIndex == 3){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()),(Route<dynamic> route)=>false);
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
          contentPadding: const EdgeInsets.all(10.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    controller: myController,
                    autofocus: true,
                    onChanged: (value){
                      txt = value;
                    },
                    decoration: new InputDecoration(
                      labelText: message,
                      hintText: "e.g. Kitchen"
                    ),
                  )
              )
            ],
          ),
          actions: <Widget>[
            new ElevatedButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: const Text("Cancel")),
            new ElevatedButton(
                onPressed: (){
                  ok = true;
                  Navigator.of(context, rootNavigator: true).pop(context);
                },
                child: const Text("Ok"))
          ],
        )
    );
    if (!ok) return null;
    return txt;
  }
}