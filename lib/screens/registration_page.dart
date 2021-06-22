import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber/brand_colors.dart';
import 'package:uber/screens/main_page.dart';
import 'package:uber/widgets/progressDialog.dart';
import 'package:uber/widgets/taxi_button.dart';

import 'login_page.dart';


class RegistrationPage extends StatefulWidget {

  static const String id = 'register_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void showScaffoldMessenger (String title){
    final snackbar = SnackBar(
        content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerUser() async{

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog('Registering you...'),
    );

    try {
      UserCredential userCredential = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      ).catchError((ex){
        // check error and display message
        Navigator.pop(context);
        PlatformException thisEx = ex;
        showScaffoldMessenger(thisEx.message);

      }));

      Navigator.pop(context);

      if(userCredential !=null){
        DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('users/${userCredential.user.uid}');
        Map userMap = {
          'fullname' : fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        };

        newUserRef.set(userMap);

        Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(
                  height:30,
                ),
                Text('Create a Rider\'s Account',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Brand-Bold',

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TaxiButton(
                        buttonText: 'Register',
                        buttonColor: BrandColors.colorGreen,
                        onPressed: () async{
                          // check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showScaffoldMessenger('no internet connectivity');
                            return;
                          }

                          if(fullNameController.text.length < 3){
                            showScaffoldMessenger('plz provide a valid fullname');
                            return;
                          }

                          if(phoneController.text.length < 10){
                            showScaffoldMessenger('plz provide a valid phone number');
                            return;
                          }
                          if(!emailController.text.contains('@')){
                            showScaffoldMessenger('plz provide a valid email address');
                            return;
                          }

                          if(passwordController.text.length < 8 ){
                            showScaffoldMessenger('password must be at least 8 characters');
                            return;
                          }

                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                  },
                  child: Text('Already have a RIDER account? sign in',
                    style: TextStyle(
                      fontFamily: 'Brand-Bold',
                      fontSize: 14,
                    ),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
