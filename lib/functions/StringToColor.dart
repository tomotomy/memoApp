import 'package:flutter/material.dart';

Color stringToColor(String stringifiedColor) {
  Color reconvertedColor;
  switch (stringifiedColor) {
    case 'red':
      reconvertedColor = Colors.redAccent;
      break;
    case 'pinkAccent':
      reconvertedColor = Colors.pinkAccent;
      break;
    case 'redAccent':
      reconvertedColor = Colors.redAccent;
      break;
    case 'yellow':
      reconvertedColor = Colors.yellow;
      break;
    case 'orangeAccent':
      reconvertedColor = Colors.orangeAccent;
      break;
    case 'lightBlueAccent':
      reconvertedColor = Colors.lightBlueAccent;
      break;
    case 'greenAccent':
      reconvertedColor = Colors.greenAccent;
      break;
    case 'tealAccent':
      reconvertedColor = Colors.tealAccent[400];
      break;
    case 'blueAccent':
      reconvertedColor = Colors.blueAccent;
      break;
    case 'purple':
      reconvertedColor = Colors.purple[300];
      break;
    case 'deepPurple':
      reconvertedColor = Colors.deepPurple[300];
      break;
    case 'indigoAccent':
      reconvertedColor = Colors.indigoAccent;
      break;
  }
  return reconvertedColor;
}

