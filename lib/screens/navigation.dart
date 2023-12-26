import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripinsider/providers/user_provider.dart';
import 'package:tripinsider/utils/colorsScheme.dart';
import 'package:tripinsider/utils/home_page_items.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homePageItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: navBarColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add,
                color: _page == 1
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _page == 2
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page == 3
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
