import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneNumberotp extends StatefulWidget {
  const PhoneNumberotp({super.key});

  @override
  State<PhoneNumberotp> createState() => _PhoneNumberotpState();
}

class _PhoneNumberotpState extends State<PhoneNumberotp> {
  final TextEditingController phoneController=TextEditingController();
  var phonenumber = " ";
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> otpnumber() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phonenumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Show toast message for sending verification code
          Fluttertoast.showToast(
            msg: "Verification code sent!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Navigate to the OTP verification screen and pass verificationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otp (verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      // Show toast message for error during phone number verification
      Fluttertoast.showToast(
        msg: "Error sending verification code: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => phonenumber = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    otpnumber();
                  },
                  child: Text('Verify OTP'),
                  style: ElevatedButton.styleFrom(fixedSize: Size.fromWidth(200)),
                ),
              ),
            ]
        )
    );
  }

}


class Otp extends StatefulWidget {
  final String verificationId;

  const Otp({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  var otp = "";
  bool isLoading = false;

  Future<void> verifyOtp() async {
    try {
      setState(() {
        isLoading = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // OTP validated successfully, navigate to another page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>UrlLauncher(), // Replace AnotherPage with your destination page
        ),
      );
    } catch (e) {
      print("Error during OTP validation: $e");

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid OTP. Please try again."),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextFormField(
          //     keyboardType: TextInputType.number,
          //     decoration: InputDecoration(
          //       fillColor: Colors.white,
          //       filled: true,
          //       hintText: 'Enter OTP',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     onChanged: (value) => otp = value,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Pinput(
             keyboardType: TextInputType.number,
            length: 6,
            onChanged:(value) => otp = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isLoading ? null : verifyOtp,
              child: Text('Verify OTP'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(200),
                // Disable the button while loading
                primary: isLoading ? Colors.grey : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class UrlLauncher extends StatefulWidget {
  const UrlLauncher({Key? key}) : super(key: key);

  @override
  State<UrlLauncher> createState() => _UrlLauncherState();
}

class _UrlLauncherState extends State<UrlLauncher> {
  Future<void> launchUrl() async {
    const url = 'https://www.kozhikode.directory/kmo-iti/i/1000';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Another Page"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("You've successfully verified the OTP!"),
            TextButton(
              onPressed: () {
                launchUrl();
              },
              child: Text('Click the link below'),
            ),
          ],
        ),

      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UrlLauncher(),
  ));
}
