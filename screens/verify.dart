import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:dio/dio.dart';
import 'package:casafoods_app/services/secure_storage.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choose_plan.dart';
import 'onboarding.dart';
class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  Dio dio = Dio();
  dynamic data={};
   String otp="";


  Future getUser(String token)async{
    try{
      var response = await dio.post('https://api.casaworld.in/api/user/phone',
        data: {
          "data":{
            'phoneNumber':data['phone'],
            "email":""
          }
        },options: Options(headers: {
          "Authorization":'Bearer ${token}'
          })
      );

      return response.data;
    }catch(e){
      return null;
    }
  }

  void resendOtp()async{
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("OTP sent!"),duration: Duration(
        seconds: 2
    ),));
    var response = await dio.post('https://api.casaworld.in/api/auth/sms/callback',
      data: {
        'phoneNumber':data['phone']
      },
    );
  }

  Future verifyOtp()async{
    Secure_Storage storage = Secure_Storage();
    String token="";
   try{
     var response = await dio.post('https://api.casaworld.in/api/auth/sms/verify',
       data: {
         'phoneNumber':data['phone'],
         'otp':otp
       },
     );
     if(response.statusCode==200) {
        print("Verified");
        storage.deleteAll();
        Secure_Storage().addNewItem(response.data['jwt'],"token");

        setState(() {
          token=response.data['jwt'];
        });
      }
    }catch(e){
     ScaffoldMessenger.of(context)
         .showSnackBar(SnackBar(content: Text("Invalid OTP or error occured!"),duration: Duration(
         seconds: 2
     ),));
   }
   return token;
  }

  void verify()async{
    FocusManager.instance.primaryFocus?.unfocus();
    String token = await verifyOtp();
    print(token);
    if(token==""){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP or error occured!"),duration: Duration(
          seconds: 2
      ),));
    }
    else{
      dynamic user = await getUser(token);
      if(user['name']==null){
        Navigator.pushNamed(context, '/profile',arguments: {"id":user['id'],"token":token,"type":2});
      }else{
        print("ph");
        print(user['phoneNumber']);
        Provider.of<Users>(context, listen: false).setData(user['name'], user['email'], null, token,user['phoneNumber']);
        Secure_Storage().addNewItem(user['name'],"name");
        Secure_Storage().addNewItem(user['email'],"email");
        Secure_Storage().addNewItem(user['phoneNumber'],"phone");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool CheckValue = prefs.containsKey('intValue');
        bool checkBoard = prefs.containsKey('boarded');
        print(CheckValue);
        print(checkBoard);
        (CheckValue==true)?Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) =>  Home()), (route) => false):
        (checkBoard==true)?Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) =>  Choose_Plan()), (route) => false):
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) =>  Onboarding()), (route) => false);
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) =>  Home()), (route) => false);
      }
    }
  }

  OtpFieldController otpController = OtpFieldController();
  @override
  Widget build(BuildContext context) {
    data= ModalRoute.of(context)!.settings.arguments;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 5.h, 0, 0),
                  child: GestureDetector(child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios,size: 20.sp,),
                    ],
                  ),onTap: (){Navigator.pop(context);},),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 6.h, 7.w, 0),
                  child: Column(children: [
                    Text("Verify your phone number",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25.sp),)
                  ],),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 0),
                  child: Column(children: [
                    Text("Check your SMS messages. We have sent you the PIN at ${data['phone']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12.5.sp),)
                  ],),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 3.h, 7.w, 0),
                  child: OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: 86.w,
                    fieldWidth: 6.w,
                    style: TextStyle(
                        fontSize: 14.sp
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceEvenly,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      print(pin);
                    },
                    onChanged: (pin){
                      setState(() {
                        otp=pin;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 4.h, 7.w, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Text("Didn't receive SMS? Resend Code",style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.w800),),
                        onTap: (){
                          resendOtp();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(child: Padding(
              padding: EdgeInsets.fromLTRB(15.w, 6.h, 15.w, 0),
              child: InkWell(
                child: Container(
                  child: Center(child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                    child: Text("Verify", style: TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w500),),
                  )
                    ,),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.sp)
                  ),
                ),
                onTap: ()async{
                 verify();
                },
              ),
            ),
              bottom: 1.h,width: 100.w,
            )
          ],
        )
      ),
    );
  }
}
