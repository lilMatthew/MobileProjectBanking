import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:flutter_application_1/widget/widget_support.dart';
import 'inventory_screen.dart';
import 'daily_check_screen.dart';
import 'profile_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool inventory = false, dailyCheck = false, profile = false;
  Color inventoryColor = Colors.white, dailyCheckColor = Colors.white, profileColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Xofa Inventory', style: AppWidget.boldTextFieildStyle(),),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,);
                    },
                    child: Icon(Icons.logout_outlined, color: Colors.white,)
                    ),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Text('Whats you want to do?', style: AppWidget.HeadlineTextFieildStyle(),),
            Text('(Close, Order,...)', style: AppWidget.LightTextFieildStyle(),),
            SizedBox(height: 60.0),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InventoryScreen()),
                    );
                    setState(() {
                      inventory = true;
                      dailyCheck = false;
                      profile = false;
                      // inventoryColor = Colors.brown.shade300;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: inventoryColor,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_rounded, size: 20.0, color: Colors.black,),
                        SizedBox(width: 8.0),
                        Text('Inventory', style: AppWidget.boldTextFieildStyle(),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DailyCheckScreen()),
                    );
                    setState(() {
                      inventory = false;
                      dailyCheck = true;
                      profile = false;
                      // dailyCheckColor = Colors.brown.shade300;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: dailyCheckColor,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checklist_rounded, size: 20.0, color: Colors.black,),
                        SizedBox(width: 8.0),
                        Text('Daily Check', style: AppWidget.boldTextFieildStyle(),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                    setState(() {
                      inventory = false;
                      dailyCheck = false;
                      profile = true;
                      // dailyMonthColor = Colors.brown.shade300;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: profileColor,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 20.0, color: Colors.black,),
                        SizedBox(width: 8.0),
                        Text('Account', style: AppWidget.boldTextFieildStyle(),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}