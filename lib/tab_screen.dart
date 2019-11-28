import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_farmer/goods.dart';
import 'package:my_farmer/goodsdetail.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:my_farmer/mainscreen.dart';
import 'package:my_farmer/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'SlideRightRoute.dart';
import 'enterexit.dart';

double perpage =1;

class TabScreen extends StatefulWidget{
  final User user;

  TabScreen({Key key, this.user});

  @override
  _TabScreenState createState()=> _TabScreenState();
}

class _TabScreenState extends State<TabScreen>{
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
List data;

@override
void initState(){
  super.initState();
  refreshKey= GlobalKey<RefreshIndicatorState>();
  _getCurrentLocation();
}

@override
Widget build(BuildContext context){

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor:Colors.green));
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      resizeToAvoidBottomPadding: false,

      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.green,
        onRefresh: () async {
          await refreshList();
        },
        child: ListView.builder(
          //Step 6: Count the data
          itemCount: data == null ? 1 : data.length +1,
          itemBuilder: (context, index){
            if (index == 0){
              return Container(
                child: Column(
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Image.asset(
                        "assets/images/background.jpg",
                        scale: 0.8,
                        fit:BoxFit.fitWidth,
                      ),
                      Column(children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                                  child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration:BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, 15.0),
                                          blurRadius: 15.0,
                                          ),
                                          BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, -10.0),
                                          blurRadius: 10.0,
                                          ),
                                      ]
                                    ),
                                    child: Text("MyFarmer",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                              ),
                        SizedBox(height: 10),
                        Container(
                          width: 300,
                          height: 140,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.person,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.user.name
                                            .toUpperCase() ??
                                            "Not Registered",
                                            style: TextStyle(
                                              fontWeight: 
                                              FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.location_on,
                                        ),
                                        SizedBox(width: 5,
                                        ),
                                        Flexible(
                                          child: Text(_currentAddress) ,
                                          ),
                                      ],
                                      ),
                                             Row(
                                              children: <Widget>[
                                                Icon(Icons.credit_card,
                                                  ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text("You have " +
                                                      widget.user.credit +
                                                      " Credit"),
                                                ),
                                              ],
                                            ),
                                  ],
                                  ),
                                  ),
                                  ),
                        ),
                      ],
                      ),
                    ]),
                    SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Colors.green,
                              child: Center(
                                child: Text("Goods Available Today",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                  ],
                ),
              );
            }
            if (index == data.length && perpage > 1){
              return Container(
                width: 250,
                color: Colors.white,
                child: MaterialButton(
                  child: Text(
                    "Load More",
                    style: TextStyle(color:Colors.black),
                  ),
                  onPressed:  () {},
                  ),
              );
            }
            index -= 1;
            return Padding(
            padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onGoodsDetail(
                            data[index]['goodsid'],
                            data[index]['goodsprice'],
                            data[index]['goodsdesc'],
                            data[index]['goodsowner'],
                            data[index]['goodsimage'],
                            data[index]['goodstime'],
                            data[index]['goodstitle'],
                            data[index]['goodslatitude'],
                            data[index]['goodslongitude'],
                            data[index]['goodsrating'],
                            widget.user.email,
                            widget.user.name,
                            widget.user.credit,
                          ),
                          onLongPress: _onGoodsDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                    "http://lastyeartit.com//myFarmer/images/${data[index]['goodsimage']}.jpg"
                                  )))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['goodstitle']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),

                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['goodsprice']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['goodstime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
          }),
      )));
}

 _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

   _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String urlLoadGoods = "http://lastyeartit.com//myFarmer/php/load_goods.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Goods");
    pr.show();
    http.post(urlLoadGoods, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["goods"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

void _onGoodsDetail(
      String goodsid,
      String goodsprice,
      String goodsdesc,
      String goodsowner,
      String goodsimage,
      String goodstime,
      String goodstitle,
      String goodslatitude,
      String goodslongitude,
      String goodsrating,
      String email,
      String name,
      String credit) {
    Goods goods = new Goods(
        goodsid: goodsid,
        goodstitle: goodstitle,
        goodsowner: goodsowner,
        goodsdes: goodsdesc,
        goodsprice: goodsprice,
        goodstime: goodstime,
        goodsimage: goodsimage,
        goodsworker: null,
        goodslat: goodslatitude,
        goodslon: goodslongitude,
        goodsrating:goodsrating );
   // print(data);
    
    Navigator.push(context, SlideRightRoute(page: GoodsDetail(goods: goods, user: widget.user)));
  }

  void _onGoodsDelete() {
    print("Delete");
  }
}