import 'package:flutter/material.dart';

class MenuItem{
  String title;
  String description;
  IconData icon;
  String path;

  MenuItem({
    required this.title, 
    required this.description, 
    required this.icon, 
    required this.path
  });
}