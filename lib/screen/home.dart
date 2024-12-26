/*BTL Mobile Banking */
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:flutter_application_1/widget/widget_support.dart';
import 'package:lottie/lottie.dart';
import 'inventory_screen.dart';
import 'daily_check_screen.dart';
import 'profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool inventory = false, dailyCheck = false, profile = false;
  Color inventoryColor = Colors.white, dailyCheckColor = Colors.white, profileColor = Colors.white;
  bool showAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ảnh nền
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/xf_bangTin2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Nội dung chính
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  // Inventory Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InventoryScreen()),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_rounded, size: 20.0, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('Inventory', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Daily Check Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DailyCheckScreen()),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, size: 20.0, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('Daily Check', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Profile Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 20.0, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('Profile', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Text(
                    'Connect with Xofá Coffee',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Thay thế phần ElevatedButton
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          const facebookUrl = 'https://www.facebook.com/xofacafe?__tn__=%3C';
                          if (await canLaunchUrl(Uri.parse(facebookUrl))) {
                            await launchUrl(Uri.parse(facebookUrl));
                          } else {
                            throw 'Could not launch $facebookUrl';
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.facebook, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text('Facebook'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          textStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () async {
                          const instagramUrl = 'https://www.instagram.com/xofacoffee/';
                          if (await canLaunchUrl(Uri.parse(instagramUrl))) {
                            await launchUrl(Uri.parse(instagramUrl));
                          } else {
                            throw 'Could not launch $instagramUrl';
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text('Instagram'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          textStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // if (showAnimation)
          //   Center(
          //     child: Container(
          //       color: Colors.black.withOpacity(0.5),
          //       child: CircularProgressIndicator(), // Hoặc thay bằng Lottie nếu muốn
          //     ),
          //   ),
          ],
        ),
      ),
    );
  }
}