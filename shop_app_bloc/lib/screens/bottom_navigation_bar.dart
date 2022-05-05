import 'package:flutter/material.dart';
import 'package:shop_app_bloc/screens/account.dart';
import 'package:shop_app_bloc/screens/cart.dart';
import 'package:shop_app_bloc/screens/home_page.dart';
import 'package:shop_app_bloc/screens/menu.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Account(),
    MyCart(),
    Menu()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(
              Icons.home_outlined,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.perm_identity_outlined,
            ),
            label: 'Account',
            activeIcon: Icon(
              Icons.perm_identity_outlined,
              color:  Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_outlined,

            ),
            label: 'Cart',
            activeIcon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,

            ),
            label: 'Cart',
            activeIcon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          _buildOffstageNavigator(3),
        ],
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomePage(),
          Account(),
          MyCart(),
          Menu()
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    final Map routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
