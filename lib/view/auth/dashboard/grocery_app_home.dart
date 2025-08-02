import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/profile_screen.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signin_page.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view/bot_view.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_view_model.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view/order_screen.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/home_screen.dart';

class GroceryAppHome extends StatefulWidget {
  const GroceryAppHome({super.key});

  @override
  State<GroceryAppHome> createState() => _GroceryAppHomeState();
}

class _GroceryAppHomeState extends State<GroceryAppHome> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(openDrawer: _openDrawer),
      const OrderScreen(),
      const Center(
        child: Text(
          'No order history yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
      (route) => false,
    );
  }

  // ADDED: Method to open the bot screen
  void _openBotView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (context) => serviceLocator<ChatBloc>(),
              child: const BotView(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Hamro Grocery',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      // ADDED: FloatingActionButton for the bot
      floatingActionButton: FloatingActionButton(
        onPressed: _openBotView,
        backgroundColor: Colors.green,
        child: const Icon(Icons.support_agent, color: Colors.white),
        tooltip: 'Ask TrailMate',
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          elevation: 0,
        ),
      ),
    );
  }
}
