import 'package:flutter/material.dart';

BoxShadow boxshadow(double off1,double off2,br,sr,Color color){
  return   BoxShadow(
      color: color,
      offset: Offset(off1,off2),
      blurRadius: br,
      spreadRadius: sr
  );
}

Text text(String title,fontsize,Color color){
  return Text(title,
  style: TextStyle(
      fontSize: fontsize,
    color: color,
    fontWeight: FontWeight.w700
  ),);
}