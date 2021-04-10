import 'package:Apparel_App/services/sidebaricons_icons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xff646464)),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Theme(
        //* Side drawer ---------------------------------------------------------------------------------------------
        data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.grey[300].withOpacity(0.9)),
        child: Container(
          width: 250,
          child: Drawer(
            child: Column(
              // Important: Remove any padding from the ListView.
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: double.infinity,
                  child: DrawerHeader(
                    child: Text(
                      //* Drawer header
                      'Gadget Doctor',
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 30),
                  leading: Icon(
                    Sidebaricons.bag,
                    size: 22,
                    color: Colors.black,
                  ),
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 30),
                  leading: Icon(
                    Icons.format_list_bulleted_rounded,
                    color: Colors.black,
                  ),
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      'Wish List',
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 32),
                  leading: Icon(
                    Sidebaricons.settings,
                    size: 22,
                    color: Colors.black,
                  ),
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  onTap: () {},
                ),
                Expanded(
                  //* Sign Out button
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 5),
                      title: Transform.translate(
                        offset: Offset(-15, 0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xffF3F3F3),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  //* Side menu icon ---------------------------------------------------------------------------
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    child: Icon(
                      Icons.menu_rounded,
                      size: 32,
                      color: Color(0xff646464),
                    ),
                    onTap: () => scaffoldKey.currentState.openDrawer(),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  //* Search bar --------------------------------------------------------------------------------
                  flex: 10,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 40,
                    // color: Colors.red,
                    child: TextField(
                      cursorColor: Color(0xff646464),
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 18,
                          color: Color(0xff646464),
                          fontWeight: FontWeight.w500),
                      decoration: new InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        suffixIcon: Icon(
                          Icons.search,
                          size: 28,
                          color: Color(0xff646464),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.red,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
