import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userapp/src/utils/firebase_utils.dart';
import 'package:userapp/src/utils/size_config.dart';
import 'package:userapp/src/views/auth/otp_screen.dart';

//

class PhoneAuthPage extends StatefulWidget {
  @override
  _LoginPhonePageState createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<PhoneAuthPage> {
  // Globals _myGlobals = Globals();
  String verificationId = "";

  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    padding:
                        const EdgeInsets.only(left: 30, right: 20, bottom: 0),
                    child: Text(
                      'Welcome!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 38,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding:
                        const EdgeInsets.only(left: 30, right: 20, bottom: 10),
                    child: Text(
                      'Sign in with your Phone No.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: height * 0.07,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: height * 0.7,
                                  width: width * 0.12,
                                  //   margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        bottomLeft: Radius.circular(6),
                                      )),
                                  child: Center(
                                      child: Text(
                                    "+91",
                                    style: TextStyle(fontSize: 16),
                                  ))),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                height: height * 0.07,
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              Container(
                                height: height * 0.07,
                                width: width * 0.7,
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    letterSpacing: 1.5,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF2F2F2),

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        borderSide: BorderSide(
                                            width: 0,
                                            color:
                                                Colors.grey.withOpacity(0.3))),

                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.grey.withOpacity(0))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        borderSide: BorderSide(
                                            width: 0, color: Colors.blue)),

                                    isDense: true,
                                    // contentPadding: EdgeInsets.all(10),
                                    hintText: "Mobile Number",
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFB3B1B1),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone Number is required';
                                    }
                                    if (value.length != 10) {
                                      return 'Please enter a correct phone number';
                                    }
                                    return null;
                                  },
                                  controller: phoneController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 80),
                      child: MaterialButton(
                          height: 40,
                          minWidth: SizeConfig.screenWidth! * 0.6,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(8.0)),
                          onPressed: () async {
                            if (phoneController.text.length == 10) {
                              Loader.show(context,
                                  progressIndicator:
                                      CircularProgressIndicator());
                              try {
                                await auth.verifyPhoneNumber(
                                    phoneNumber: "+91${phoneController.text}",
                                    codeAutoRetrievalTimeout: (String verId) {
                                      this.verificationId = verId;
                                    },
                                    codeSent: (String? verificationId,
                                        [int? forceResendingToken]) {
                                      Loader.hide();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  OTPPage(
                                                    verificationId:
                                                        verificationId,
                                                    contactNumber:
                                                        "+91${phoneController.text}",
                                                  )));
                                    },
                                    timeout: const Duration(seconds: 20),
                                    verificationCompleted:
                                        (AuthCredential phoneAuthCredential) {
                                      Loader.hide();
                                      print(phoneAuthCredential);
                                    },
                                    verificationFailed: (exceptio) {
                                      Loader.hide();
                                      Fluttertoast.showToast(
                                          msg: "${exceptio.message}");
                                      print('${exceptio.message}');
                                    });
                              } catch (err) {
                                if (err == 'ERROR_INVALID_VERIFICATION_CODE') {
                                  Loader.hide();
                                  Fluttertoast.showToast(msg: "${err}");
                                } else {
                                  Loader.hide();
                                  Fluttertoast.showToast(msg: "${err}");
                                }
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Enter a valid number");
                            }
                          },
                          child: Text('login'.toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
