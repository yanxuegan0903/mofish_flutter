// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mofish_flutter/page/fishpond/fishpond.dart';
import 'package:mofish_flutter/page/lastest/lastest.dart';
import 'package:mofish_flutter/page/search/search.dart';

class tabPage extends StatefulWidget {
  const tabPage({Key? key}) : super(key: key);

  @override
  _tabPageState createState() => _tabPageState();
}

class _tabPageState extends State<tabPage> {
  int _currentIndex = 0;
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          children: [
            fishpondPage(),
            lastestPage(),
            // searchPage(),
          ],
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.touch_app,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.touch_app,
                color: Colors.green,
              ),
              label: '鱼塘',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.trending_up,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.trending_up,
                color: Colors.green,
              ),
              label: '最新',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.search,
            //     color: Colors.grey,
            //   ),
            //   activeIcon: Icon(
            //     Icons.search,
            //     color: Colors.green,
            //   ),
            //   label: '搜索',
            // ),
          ],
        ),
      ),
    );
  }
}
