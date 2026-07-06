import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/catalogue/utils/hive.dart';
import 'package:moonlinks/elements/cart/cart.dart';
import 'package:moonlinks/elements/cart/cart_container.dart';
import 'package:moonlinks/elements/nav_bottom.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/utils/hive.dart';
import 'package:moonlinks/my_services.dart';
import 'package:moonlinks/utils/cart_hive.dart';
import 'package:moonlinks/utils/locale_hive.dart';
import 'package:moonlinks/utils/locale_provider.dart';
import 'package:moonlinks/utils/sockets.dart';
import 'package:moonlinks/utils/subscribed_services_hive.dart';
import 'home.dart';
import 'profile.dart';
import 'services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initCartHive();
  await initMenuHive();
  await initCatalogueHive();
  await initsubServicesHive();
  await initLocaleHive();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'MOON LINKS',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const Main(),
    );
  }
}

class Main extends ConsumerStatefulWidget {
  final int? initialIndex;
  const Main({super.key, this.initialIndex});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  late int _currentIndex;

  bool get _showMyServices => kIsWeb || !Platform.isIOS;

  Future<void> loadSubscribedServices() async {
    final token = await readToken();
    if (token == null) return;
    try {
      final userAuth = AuthService();

      final userInfo = await userAuth.getUserInfo(token);
      initSocket(userInfo['user']['id'].toString(), ref, token);

      updateSubServices(ref, token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        // token is genuinely invalid/expired, safe to log out
        await deleteToken();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.offline)),
        );
      }
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 1;
    // if MyServices isn't in the list on this platform, don't let index point past valid range
    if (!_showMyServices && _currentIndex >= _visiblePages.length) {
      _currentIndex = 1;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSubscribedServices();
    });
  }

  List<Widget> get _visiblePages {
    return [
      const Home(),
      const Services(),
      if (_showMyServices) const MyServices(),
      const Profile(),
    ];
  }

  void _navClicked(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool cartOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
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
            title: Image.asset("assets/images/logo.png", height: 40),
          ),
        ),
      ),
      body: Stack(
        children: [
          _visiblePages[_currentIndex],
          !cartOpened
              ? Cart(openCart: () {
                  setState(() {
                    cartOpened = true;
                  });
                })
              : CartContainer(
                  closeCart: () => setState(() {
                    cartOpened = false;
                  }),
                )
        ],
      ),
      bottomNavigationBar: NavBottom(
        currentIndex: _currentIndex,
        onTap: _navClicked,
      ),
    );
  }
}
