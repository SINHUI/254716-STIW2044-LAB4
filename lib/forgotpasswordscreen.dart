import 'package:flutter/material.dart';
import 'dart:async';
import 'package:my_farmer/loginscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:my_farmer/resetpasswordscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

String urlForgot = "http://lastyeartit.com//myFarmer/php/forgot_password.php";


class ForgotPasswordScreen extends StatefulWidget {
  final String email;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
  const ForgotPasswordScreen({Key key, this.email}) : super(key: key);
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
   @override
  void initState() {
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: ForgotWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class ForgotWidget extends StatefulWidget {
  @override
  _ForgotWidgetState createState() => _ForgotWidgetState();
}

class _ForgotWidgetState extends State<ForgotWidget> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

   final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Forgot Your Password?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),

         SizedBox(
            height: 30,
                ),

                  Text("Please enter your email address:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),

        SizedBox(
          height: 10,
        ),

        TextFormField(
          autovalidate: _validate,
            controller: _emcontroller,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
            SizedBox(
                  height: 50,
                ),

                  MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Send Verification Message'),
                  color: Color.fromRGBO(12, 130, 9, 1),
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onVerify,
                ),


      ],
    );
  }

   String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
      return null;
    }
  }

 void _onVerify() {
    _email = _emcontroller.text;
    if (_isEmailValid(_email)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Checking your email.");
      pr.show();
      
      http.post(urlForgot, body: {
        "email": _email,
      }).then((res){
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
             pr.dismiss();
            if (res.body == "The temporary password had been sent, please check your email.") { 
         print('hjh');
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context) => ResetPasswordScreen (email: _email))); 
          }else {
          pr.dismiss();
        }
      }).catchError((err){
          pr.dismiss();
          print(err);
    });
  } else{
    setState(() {
        _validate = true;
      });
    Toast.show("Check your email format and must enter your email", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}

   
  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  } 

}