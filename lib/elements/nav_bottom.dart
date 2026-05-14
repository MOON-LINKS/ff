import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class NavBottom extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBottom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.home_nav),
        BottomNavigationBarItem(
            icon: Icon(Icons.sensors_sharp),
            label: AppLocalizations.of(context)!.services_nav),
        BottomNavigationBarItem(
            icon: Icon(Icons.adjust_rounded),
            label: AppLocalizations.of(context)!.my_services_nav),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile_nav),
      ],
    );
  }
}
