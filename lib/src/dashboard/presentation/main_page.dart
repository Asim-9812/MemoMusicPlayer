


import 'package:flutter/material.dart';
import 'package:musicplayer/src/dashboard/presentation/dashboard.dart';
import 'package:musicplayer/src/playlist/presentation/playlist.dart';
import 'package:musicplayer/src/upload_music/presentation/upload.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{


  int _selectedIndex=0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, //to make floating action button notch transparent

      //to avoid the floating action button overlapping behavior,
      // when a soft keyboard is displayed
      // resizeToAvoidBottomInset: false,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        elevation: 0,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: ''
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: ''
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: ''
          ),

        ],


      ),
      body: PageView(
        controller: _pageController,
        children: const [
         MusicDashBoard(),
          UploadMusic(),
          PlayList()
        ],
      ),
    );
  }

  void _onItemTapped(int index) {



    setState(() {
      _selectedIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });

  }

}
