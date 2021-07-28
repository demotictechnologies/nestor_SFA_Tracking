import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:nestore/model/result.dart';
import 'package:nestore/network/orders.dart';
import 'package:nestore/resources/app_style.dart';
import 'package:nestore/ui/common/Loader.dart';
import 'package:nestore/ui/common/borderButton.dart';
import 'package:nestore/ui/common/search_field.dart';
import 'package:nestore/ui/home/InnerHeader.dart';

class ChemistListPage extends StatefulWidget {
  ChemistListPage({Key key}) : super(key: key);

  @override
  _ChemistListPageState createState() => _ChemistListPageState();
}

class _ChemistListPageState extends State<ChemistListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final authService = AuthService();
  List orders = [];
  List searchedOrder = [];
  bool loading = false;
  TextEditingController otpCtrl = TextEditingController(text: '');
  String nameValue = '';
  getOrderSearched(name) async {
    setState(() {
      loading = true;
    });
    Result response  = await authService.searchOrder(name);
    if(response is SuccessState) {
      if(response.value['status'] == true) {
        if(response.value['data'].length > 0) {
          setState(() {
            searchedOrder = response.value['data'];
            loading = false;
          });
        }
      }
    }
  }
  void initState() {
    super.initState();
    getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
        Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: InnerHeader(),
      ),
      body: loading ? Align(
        alignment: Alignment.center,
        child: Loader(),
      ) :  SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
                left: 0, right: 0, top:0, bottom:0),
            child: Column(
              children: [
                AllRestaurants(),
                AllRestaurants()
              ],
            )
        ),
      ),
    );
  }

  getOrderHistory() async {
    Result response  = await authService.getOrderHistory();
    if(response is SuccessState) {
      if(response.value['status'] == true) {
        setState(() {
          orders = response.value['data'];
          loading = false;
        });
      }
    }
  }
}

class AllRestaurants extends StatefulWidget {
  List data;
  AllRestaurants({Key key, this.data}) : super(key: key);

  @override
  _AllRestaurantsState createState() => _AllRestaurantsState();
}

class _AllRestaurantsState extends State<AllRestaurants> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom:10, top:10, left:10, right:10),
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                for (int i=0; i<5; i++) OrderCard()
              ],
            )
        )
    );
  }
}


class OrderCard extends StatefulWidget {
  var data;
  OrderCard({Key key, this.data}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[100], width:1)
        ),
        child: Padding(
            padding: EdgeInsets.only(top:25, bottom:10, left:0, right: 0),
            child: Row(
              children: [
                Expanded(
                    flex:2,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top:10, bottom:5, left:10, right: 5),
                            child: Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text('21 items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppStyles.SMALL_TEXTSIZE)),
                                      ),
                                    ),
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text('Rs. 1212', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppStyles.SMALL_TEXTSIZE))
                                        )
                                    )
                                  ],
                                )
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(top:2, bottom:5, left:10, right: 5),
                            child: Container(
                                width: double.infinity,
                                child: Wrap(
                                  children: [
                                    Text('Processing', style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppStyles.SMALL_TEXTSIZE)),
                                  ],
                                )
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(top:2, bottom:5, left:10, right: 5),
                            child: Container(
                                width: double.infinity,
                                child: Wrap(
                                  children: [
                                    Text('Order id: 12', style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppStyles.SMALL_TEXTSIZE)),
                                  ],
                                )
                            )
                        ),
                        Container(
                          width:double.infinity,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 0, left: 10, right: 10),
                              child: BorderButton(Title: 'View Details', onClick: (){

                              },)
                          ),
                        ),
                      ],
                    )
                )
              ],
            )
        )
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 2 ?
    setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }
}


class IconStepperDemo extends StatefulWidget {
  var data;
  IconStepperDemo({Key key, this.data}) : super(key: key);
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<IconStepperDemo> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 5; // Initial step set to 5.

  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          NumberStepper(
            alignment: Alignment.center,
            nextButtonIcon: Icon(Icons.add, color: Colors.white),
            previousButtonIcon: Icon(Icons.add, color: Colors.white),
            lineLength:MediaQuery.of(context).size.width *0.04,
            numbers: [
              1,
              2,3,4
            ],
            numberStyle: TextStyle(fontSize: AppStyles.SMALL_TEXTSIZE),
            // activeStep property set to activeStep variable defined above.
            activeStep: 0,
          ),
          header(this.widget.data['OrderStatus_Code']),


        ],
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header(status) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: AppStyles.SMALL_TEXTSIZE,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 0:
        return 'Placed';

      case 1:
        return 'Packed';

      case 2:
        return 'On The Way';

      case 3:
        return 'Delivered';

      default:
        return 'Placed';
    }
  }
}
