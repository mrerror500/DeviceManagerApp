import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DatabaseSetUp/Database.dart';
import 'Login.dart';
import 'SignUp.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numOfUsers = 0;
  DBProvider _dbProvider;


  void initState() {
    super.initState();
    setState(() {
      _dbProvider = DBProvider.dbProviderInstance;
      _countUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/app_icon.png"),
                fit:BoxFit.cover
              )
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SmartApp',
                        )
                      ],
                    ),
                  ),
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: ButtonTheme(
                              minWidth: 130.0,
                              height: 50.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                                ),
                                child: Text('Εγγραφή'),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (Route<dynamic> route) => false);
                                  },
                                color: Colors.white,
                                textColor: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: ButtonTheme(
                              minWidth: 130.0,
                              height: 50.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                                ),
                                child: Text('Σύνδεση'),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                                  },
                                  color: Colors.white,
                                  textColor: Colors.black,
                              ),
                            )
                          ),
                        ]
                      )
                    ],
                  ),
                ),
            )
        )
    );
  }

  _countUsers() async {
    int count = await _dbProvider.getCount();
    setState(() {
      numOfUsers = count;
    });
  }
}
