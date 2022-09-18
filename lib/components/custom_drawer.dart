
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_maker/services/authencation_service.dart';

import '../constant.dart';
import '../screens/login_signup_screen.dart';
import '../screens/meme_upload_screen.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn=Authentication.user!=null;
    return  Drawer(
      //backgroundColor: kPrimaryColor,
      elevation: 10,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children:  [
            const CircleAvatar(
              maxRadius: 80,
              backgroundColor: kPrimaryColor,
              backgroundImage: AssetImage("assets/images/default_img.png"),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Flexible(
                  child: Text("Mobin@smkwinner",style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                    fontFamily: GoogleFonts.dancingScript().fontFamily,
                  ),),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
              height: 50,
            ),
            if(!isLoggedIn)
              drawerRowWidget(title: "Login", icon: Icons.login, onTap: (){
                if(!isLoggedIn){
                  Fluttertoast.showToast(msg: "Login required");
                }
              }),
            drawerRowWidget(title: "Edit Profile", icon: Icons.person, onTap: (){
              if(!isLoggedIn){
                Fluttertoast.showToast(msg: "Login required");
              }
            }),
            drawerRowWidget(title: "upload templates", icon: Icons.upload, onTap: (){
              if(!isLoggedIn){
                Fluttertoast.showToast(msg: "Login required");
              }
              else{
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>const MemeUploadScreen()));
              }
            }),
            if(isLoggedIn)
              drawerRowWidget(title: "Logout", icon: Icons.logout, onTap: () async {

                await Authentication.logOut();
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>const LoginSignupScreen()));
              }),






          ],
        ),
      ),


    );
  }
  Widget drawerRowWidget({required String title, required IconData icon, required GestureTapCallback onTap}){
    return Row(
      children:  [
        Flexible(child: ListTile(
          leading: Icon(icon,color: Colors.black,size: 30,),
          onTap: onTap,
          horizontalTitleGap: 5,
          title: Text(title,style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20
          ),),
        ))
      ],
    );
  }
}