import 'package:flutter/material.dart';
import 'package:my_skenu/Core/Util/MyColors.dart';
import 'package:my_skenu/Core/Util/UserModel.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:my_skenu/Screens/HomeScreen.dart';
import 'package:my_skenu/Screens/UserProfileScreen.dart';
import 'package:provider/provider.dart';

class SelectTabScreen extends StatefulWidget {
  const SelectTabScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const SelectTabScreen(),
      );

  @override
  State<SelectTabScreen> createState() => _SelectTabScreenState();
}

class _SelectTabScreenState extends State<SelectTabScreen> {
  int currentIndex = 0;
  late PageController pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onNavigationTapped(int index){
    pageController.jumpToPage(index);
  }

  onPageChanged(int index){
    setState(() {
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    UserModel _model = Provider.of<UserProvider>(context).getModel;
    return Scaffold(

      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          HomeScreen(),
          Text('Liked'),
          Text('Share'),
          Text('Comment'),
          UserProfileScreen(isMe: true, model: _model),
        ],
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        onTap: (val) => onNavigationTapped(val),
        currentIndex: currentIndex,
        selectedItemColor: MyColors.yellow,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            activeIcon: Icon(Icons.home_outlined),
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Liked',
            icon: Icon(
              Icons.favorite_border_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Share',
            icon: Icon(
              Icons.share,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Comment',
            icon: Icon(
              Icons.comment,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
    );
  }
}
