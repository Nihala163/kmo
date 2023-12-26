import 'package:educational_app/phoneOtp.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KMO EDUCATION',style: TextStyle(fontWeight: FontWeight.bold),)),
      body: ListView(children: [
        Image(image: AssetImage('assets/educationLogo1.jpg')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return PhoneNumberotp();
            }));
          }, child: Text('Login Demo'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 11, 35, 77),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){}, child: Text('Login Paid'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 85, 141, 238),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))

            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){}, child: Text('Help Line'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 235, 181, 3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
          ),
        ),
      ]),
    );
  }
}