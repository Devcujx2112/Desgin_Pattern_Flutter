import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationMenu extends StatefulWidget {
  final Widget child;

  const NavigationMenu({super.key, required this.child});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<RouteItem> _items = [
    RouteItem(icon: Icons.home, route: '/HomePage'),
    RouteItem(icon: Icons.delete, route: '/AreaMonitor'),
    RouteItem(icon: Icons.favorite_outlined, route: '/Warning'),
    RouteItem(icon: Icons.shopping_cart, route: '/Statistical'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _items.indexWhere((item) => location.contains(item.route));
    if (currentIndex != -1 && currentIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white,
        buttonBackgroundColor: const Color(0xFF4CAF50),
        height: 60,
        index: _selectedIndex,
        items: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Icon(
            item.icon,
            size: 25,
            color: _selectedIndex == index ? Colors.white : const Color(0xFF4CAF50),
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            context.go(_items[index].route);
          });
        },
      ),
    );
  }
}

class RouteItem {
  final IconData icon;
  final String route;

  RouteItem({required this.icon, required this.route});
}
