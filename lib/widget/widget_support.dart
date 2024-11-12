import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextFieildStyle(){
    return TextStyle(
          color: Colors.black, 
          fontSize: 18.0, 
          fontWeight: FontWeight.bold, 
          fontFamily: 'Poppins');
  } 

  static TextStyle HeadlineTextFieildStyle(){
    return TextStyle(
          color: Colors.black, 
          fontSize: 24.0, 
          fontWeight: FontWeight.bold, 
          fontFamily: 'Poppins');
  }       
    static TextStyle LightTextFieildStyle(){
    return TextStyle(
          color: Colors.black38, 
          fontSize: 16.0, 
          fontWeight: FontWeight.w500, 
          fontFamily: 'Poppins');
  } 
    static TextStyle semiBoldTextFieildStyle(){
       return TextStyle(
          color: Colors.black, 
          fontSize: 12.0, 
          fontWeight: FontWeight.w500, 
          fontFamily: 'Poppins');
  }
}