// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:admin_app/screens/settings.dart';
import 'package:flutter/material.dart';

import 'package:admin_app/layout/adaptive.dart';


const int tabCount = 1;
const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return
      Row(
        children: [
          if(MediaQuery.of(context).size.width > 700.0)
          Text("HOME"),
          Text("test")
        ],
      );
    //   Container(
    //   child:
    // );
  }
}
