import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber/brand_colors.dart';
import 'package:uber/screens/main_page.dart';
import 'package:uber/screens/registration_page.dart';
import 'package:uber/widgets/progressDialog.dart';
import 'package:uber/widgets/taxi_button.dart';

class LoginPage extends StatefulWidget {

  static const String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void showScaffoldMessenger (String title){
    final snackbar = SnackBar(
        content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void loginUser() async{

    // show plz wait dialog

    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog('logging you in'),
    );
    try {
      UserCredential userCredential = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      ).catchError((ex){
        // check error and display message
        Navigator.pop(context);
        PlatformException thisEx = ex;
        showScaffoldMessenger(thisEx.message);

      }));

      if(userCredential != null){
        // varify login
        DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${userCredential.user.uid}');

        userRef.once().then((DataSnapshot snapshot) => {
          if(snapshot.value != null){
            Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false)
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
                Text('Sign In as Rider',
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
                        buttonText: 'Login',
                        buttonColor: BrandColors.colorGreen,
                        onPressed: () async {

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showScaffoldMessenger('no internet connectivity');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showScaffoldMessenger('plz provide a valid emal address');
                            return;
                          }
                          if(passwordController.text.length < 8){
                            showScaffoldMessenger('password must be at least 8 characters');
                            return;
                          }

                          loginUser();
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                  },
                  child: Text('Don\'t have an account, sign up here',
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

