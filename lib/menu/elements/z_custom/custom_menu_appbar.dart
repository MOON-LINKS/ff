import 'package:flutter/material.dart';

class CustomMenuAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool haveIcon;
  const CustomMenuAppbar({super.key, required this.haveIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha((0.3 * 255).round()),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: haveIcon,
        title: Image.asset("assets/images/logo.png", height: 40),
        /* actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: Colors.white,
            ),
            onSelected: (value) {
              switch (value) {
                case 'themes':
                  // Navigate to themes page
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('john.doe@example.com',
                        style: TextStyle(fontSize: 12)),
                    Text('Plan: Premium',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              // Clickable actions
              PopupMenuItem<String>(
                value: 'themes',
                child: Icon(Icons.settings_display_rounded),
              )
            ],
          )
        ], */
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
