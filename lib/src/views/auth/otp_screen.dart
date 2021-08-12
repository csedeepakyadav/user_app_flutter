import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'dart:async';
import 'package:userapp/src/utils/firebase_utils.dart';
import 'package:userapp/src/utils/size_config.dart';

class OTPPage extends StatefulWidget {
  final String? verificationId;
  final String? contactNumber;

  OTPPage({@required this.contactNumber, @required this.verificationId});
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  var _smsCodeController;
  //final String? verificationId = "";

  String newVerificationId = "";

  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();
  bool onPressedValue = true;
  int timeCounter = 20;
  Timer? _timer;

  @override
  void initState() {
    setState(() {
      newVerificationId = widget.verificationId!;
    });
    super.initState();
    _startResendOTPTimer();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Verify Phone",
            style: TextStyle(color: Colors.black),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          width: width,
          height: height,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                height: height * 0.25,
                child: Image.asset("assets/images/otp_header.jpg"),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "Code is Sent to ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: "${widget.contactNumber}",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          color: Colors.blue,
                          fontWeight: FontWeight.w400)),
                ]),
              )),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: darkRoundedPinPut(),
              ),
              timeCounter != 0
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.2,
                                )
                              ],
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "$timeCounter Sec",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t Receive Code ?',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  InkWell(
                    child: Text(
                      'Resend Otp',
                      style: TextStyle(
                          //  decoration: TextDecoration.underline,
                          color: timeCounter == 0 ? Colors.blue : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: timeCounter == 0
                        ? () async {
                            setState(() {
                              Loader.show(this.context,
                                  progressIndicator:
                                      CircularProgressIndicator());
                            });
                            try {
                              await auth.verifyPhoneNumber(
                                  phoneNumber: widget.contactNumber!,
                                  codeAutoRetrievalTimeout: (String verId) {
                                    this.newVerificationId = verId;
                                  },
                                  codeSent: (String? vId,
                                      [int? forceResendingToken]) {
                                    setState(() {
                                      _startResendOTPTimer();
                                    });
                                    Loader.hide();
                                    newVerificationId = vId!;
                                    print("ID : ");
                                    // set pin
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
                          }
                        : null,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: MaterialButton(
                      elevation: 0,
                      height: 46,
                      minWidth: SizeConfig.screenWidth! * 0.6,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(20.0)),
                      onPressed: () async {
                        setState(() {
                          Loader.show(this.context,
                              progressIndicator: CircularProgressIndicator());
                        });

                        try {
                          final AuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: newVerificationId,
                            smsCode: _smsCodeController,
                          );
                          await auth.signInWithCredential(credential);
                          final currentUser = auth.currentUser;
                          assert(currentUser!.uid == currentUser.uid);
                          Fluttertoast.showToast(msg: "Login Successfully..!");
                          print(currentUser!.uid);
                          Loader.hide();
                          /*    Navigator.pop(context, true);
                          Navigator.pop(context, true); */

                          /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SplashScreen())); */

                        } catch (err) {
                          /* if (err == 'ERROR_INVALID_VERIFICATION_CODE') {
                            Loader.hide();
                            Fluttertoast.showToast(msg: "${err.message}");
                          } else {
                            Loader.hide();
                            Fluttertoast.showToast(msg: "${err.message}");
                          } */
                          Loader.hide();
                          print("${err}");
                          Fluttertoast.showToast(msg: "${err}");
                        }
                      },
                      child: Text('Submit'.toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 5.0,
          spreadRadius: 1.2,
        )
      ],
      border: Border.all(width: 2, color: Colors.white),
      borderRadius: BorderRadius.circular(12.0),
    );
    return PinPut(
      autofocus: true,

      // withCursor: true,
      eachFieldWidth: 40.0,
      eachFieldHeight: 40.0,
      fieldsCount: 6,
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.always,
      onSubmit: (String pin) {
        setState(() {
          _smsCodeController = pin;
          print('PIN : $pin');
        });
      },
      onChanged: (String pin) {
        setState(() {
          _smsCodeController = pin;
          if (pin.length.toInt() == 6) {
            verifyOTP();
          }
          print('PIN : $pin');
        });
      },
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
      textStyle: const TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    );
  }

  void _startResendOTPTimer() {
    timeCounter = 20;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          if (timeCounter > 0) {
            timeCounter--;
          } else {
            _timer!.cancel();
          }
        });
      }
    });
  }

  verifyOTP() async {
    setState(() {
      Loader.show(this.context, progressIndicator: CircularProgressIndicator());
    });

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: newVerificationId,
        smsCode: _smsCodeController,
      );
      await auth.signInWithCredential(credential);
      final currentUser = auth.currentUser;
      assert(currentUser!.uid == currentUser.uid);
      Fluttertoast.showToast(msg: "Login Successfully..!");
      Fluttertoast.showToast(msg: currentUser!.uid);
      Loader.hide();
      /*    Navigator.pop(context, true);
                            Navigator.pop(context, true); */

      /*  Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SplashScreen())); */
    } catch (err) {
      Loader.hide();
      print("${err}");
      Fluttertoast.showToast(msg: "${err}");
    }
  }
}
