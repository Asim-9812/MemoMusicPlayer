



import 'package:flutter/material.dart';

class MusicDashBoard extends StatefulWidget {
  const MusicDashBoard({super.key});

  @override
  State<MusicDashBoard> createState() => _MusicDashBoardState();
}

class _MusicDashBoardState extends State<MusicDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('Home',style: TextStyle(color: Colors.black),),
      ),
    );
  }
}
