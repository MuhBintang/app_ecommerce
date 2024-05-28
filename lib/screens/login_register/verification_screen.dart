import 'package:app_ecommerce/screens/login_register/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_auth/email_auth.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController1 = TextEditingController();
  final TextEditingController _codeController2 = TextEditingController();
  final TextEditingController _codeController3 = TextEditingController();
  final TextEditingController _codeController4 = TextEditingController();
  // final TextEditingController emailcontroller = TextEditingController();
  // final TextEditingController otpcontroller = TextEditingController();
  String? email;
  EmailAuth emailAuth = EmailAuth(sessionName: "Ecommerce Session");

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    getSession().then((_) {
      if (email != null) {
        sendOTP();
      }
    });
  }

  Future<void> sendOTP() async {
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email is null, cannot send OTP")),
      );
      return;
    }
    try {
      bool result = await emailAuth.sendOtp(recipientMail: email!);
      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending OTP: $e")),
      );
    }
  }

  // void sendOTP() async {
  //   emailAuth.sessionName = "Test Session";
  //   var res = await emailAuth.sendOtp(recipientMail: email!); 
  //   if (res){
  //     print("OTP Send"); 
  //   } else {
  //     print("Problem OTP");
  //   }
  // }

  // void verifyOTP() async {
  //   var res = emailAuth.validateOtp(recipientMail: email!.toString() , userOtp: _codeController1.text + _codeController2.text + _codeController3.text + _codeController4.text);
  //   if (res){
  //     print("OTP Verified"); 
  //   } else {
  //     print("Invalid OTP");
  //   }
  // }

  bool verifyOTP() {
    String otp = _codeController1.text + _codeController2.text + _codeController3.text + _codeController4.text;
    return emailAuth.validateOtp(recipientMail: email!, userOtp: otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFEB3C3C),
                child: Icon(Icons.email, color: Colors.white, size: 40),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Verification Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'We have sent the code verification to',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Center(
              child: Text(
                "$email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeInput(_codeController1),
                _buildCodeInput(_codeController2),
                _buildCodeInput(_codeController3),
                _buildCodeInput(_codeController4),
              ],
            ),
            // TextField(
            //   controller: emailcontroller,
            //   keyboardType: TextInputType.emailAddress,
            //   decoration: InputDecoration(
            //     hintText: "Enter Email", 
            //     labelText: "Email", 
            //     suffixIcon: TextButton(
            //       child: Text("Send OTP"),
            //       onPressed: () => sendOTP(),
            //     )
            //   ),
            // ),
            // SizedBox(height: 30),
            // TextField(
            //   controller: otpcontroller,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     hintText: "Enter OTP", 
            //     labelText: "OTP", 
            //   ),
            // ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // if (verifyOTP()) {
                //   _showSuccessDialog();
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text("Invalid OTP")),
                //   );
                // }
                Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Color(0xFFEB3C3C),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                // onPressed: () => sendOTP(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Resend OTP?",
                  style: TextStyle(color: Color(0xFFEB3C3C)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(TextEditingController controller) {
    return Container(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("images/checkverif.png", scale: 5,),
              SizedBox(height: 80,),
              Text(
                'Verification Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your email has been verified successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  primary: Color(0xFFEB3C3C),
                ),
                child: Text(
                  'Go to HomePage',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        );
      },
    );
  }
}
