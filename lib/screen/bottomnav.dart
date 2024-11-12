import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/daily_check_screen.dart';
import 'package:flutter_application_1/screen/daily_month_screen.dart';
import 'package:flutter_application_1/screen/home.dart';
import 'package:flutter_application_1/screen/inventory_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State <BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State <BottomNav> {
  int currentTabIndex = 0;

  late List <Widget> pages;
  late Widget currentPage;
  late Home home; 
  late InventoryScreen inventoryScreen;
  late DailyCheckScreen dailyCheckScreen;
  late DailyMonthScreen dailyMonthScreen;

@override
  void initState() {
    home = Home();
    inventoryScreen = InventoryScreen();
    dailyCheckScreen = DailyCheckScreen();
    dailyMonthScreen = DailyMonthScreen();
    pages = [home, inventoryScreen, dailyCheckScreen, dailyMonthScreen];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
            
          });
        },
        items: 
      [
        Icon(
          Icons.home_outlined, color: Colors.white,
          ),
        Icon(
          Icons.inventory_2_outlined, color: Colors.white,
          ),  
          Icon(
          Icons.checklist_outlined, color: Colors.white,
          ), 
          Icon(
          Icons.calendar_today_outlined, color: Colors.white,
          ),   
      ],
      ),
      body: pages[currentTabIndex],
    );
  }
}