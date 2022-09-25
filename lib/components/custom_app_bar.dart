import 'package:flutter/material.dart';

AppBar customAppBar(title,{bool actions=true}){
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 20,
      ),
    ),
    actions: [
      if(actions)
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        )
    ],
    scrolledUnderElevation: 0,
  );
}