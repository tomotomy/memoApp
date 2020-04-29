import 'package:flutter/material.dart';

Color changeToColor(String color) {
  switch (color) {
    case "red" :
      return Colors.redAccent;
      break;
    case "blue" :
      return Colors.blueAccent;
      break;
  }
}