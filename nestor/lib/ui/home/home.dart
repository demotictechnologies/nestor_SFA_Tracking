import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nestore/resources/app_color.dart';
import 'package:nestore/ui/chemist/orderHistory.dart';
import 'package:nestore/ui/chemist/trackOrder.dart';
import 'package:nestore/ui/home/CommonHeader.dart';
import 'package:nestore/ui/home/RoleHome.dart';
import 'package:nestore/ui/hotel/uploadPrescription.dart';
import 'package:nestore/ui/onboarding/kitchen_landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonHome extends StatefulWidget {
  CommonHome({Key key}) : super(key: key);

  @override
  _CommonHomeState createState() => _CommonHomeState();
}

class _CommonHomeState extends State<CommonHome> {
  int _currentIndex = 0;
  List<Widget> _children = [];
  String role = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    getTermsAndCondition();
  }

  getTermsAndCondition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userRole = prefs.getString('role');
    if(userRole == 'User') {
      setState(() {
        role = userRole;
        _children = [
          RoleHome(),
          OrderHistoryPage(),
          UploadPrescription(),
          TrackOrder()
        ];
      });
    } else {
      setState(() {
        role = userRole;
        _children = [
          RoleHome(),
          OrderHistoryPage(),
          TrackOrder()
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _backPressed(),
    child: Scaffold(
      key: _scaffoldKey,
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: CommonHeader(home: (){setState(() {
          _currentIndex = 0;
        });}, sidemenu: (){
          _scaffoldKey.currentState.openDrawer();
        })),
      drawer: SideDrawer(),
        body: _children[_currentIndex],
    )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _backPressed() async {
    if (_currentIndex == 0) {
      if(Platform.isIOS) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}


class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.15,
            child: Center(
              child: Align(
                  alignment: Alignment.center,
                  child:Image.asset('graphics/logo2.png', height: 60)
              )
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {Navigator.of(context).pop();Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => KitchenPage(),
              ),
            );},
          ),
        ],
      ),
    );
  }
}