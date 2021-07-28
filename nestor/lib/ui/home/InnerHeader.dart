import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nestore/model/result.dart';
import 'package:nestore/network/orders.dart';
import 'package:nestore/resources/app_color.dart';
import 'package:nestore/ui/cart/cart.dart';
import 'package:nestore/ui/chemist/chemistList.dart';
import 'package:nestore/ui/home/home.dart';
import 'package:nestore/ui/hotel/search.dart';

class InnerHeader extends StatefulWidget {
  InnerHeader({Key key}) : super(key: key);
  @override
  _CommonHeaderState createState() => _CommonHeaderState();
}

class _CommonHeaderState extends State<InnerHeader> {
  int count = 0;
  Timer timer;
  final authService = AuthService();
  List cart = [];

  @override
  void initState() {
    super.initState();
    getCart();
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getCart());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getCart() async {
    Result response = await authService.fetchCart();
    if (response is SuccessState) {
      if (response.value['status'] == true) {
        for (var i = 0; i < response.value['data'].length; i++) {
          print(response.value['data'][i]['data']);
          if (response.value['data'][i]['type'] == 'Products') {
            setState(() {
              cart = response.value['data'][i]['data'];
            });
          }
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: AppColors.primaryColor,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back,
                                    color: Colors.white))),
                        Expanded(
                            flex: 4,
                            child: Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CommonHome(),
                                        ),
                                      );
                                    },
                                    child: Image.asset('graphics/logo2.png',
                                        height: 40)))),
                        Expanded(
                          child: Align(
                            child: Padding(
                                padding: EdgeInsets.only(),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProductSearch(),
                                      ),
                                    );
                                  },
                                  child:
                                      Icon(Icons.search, color: Colors.white),
                                )),
                          ),
                        ),
                        Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChemistListPage(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.add,
                                            color: Colors.white),

                                      ],
                                    )
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
