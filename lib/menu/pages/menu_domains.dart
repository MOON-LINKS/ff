import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/api/menu.dart';
import 'package:moonlinks/menu/elements/domain/menu_pending_active_domain.dart';
import 'package:moonlinks/menu/elements/domain/menu_no_domain.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class MenuDomains extends ConsumerStatefulWidget {
  const MenuDomains({super.key});

  @override
  ConsumerState<MenuDomains> createState() => _MenuDomainsState();
}

class _MenuDomainsState extends ConsumerState<MenuDomains> {
  final menuAPI = MenuService();
  Future<dynamic> getMenuInfo() async {
    showLoader(context, AppLocalizations.of(context)!.menu_getting_domain_info);

    try {
      final response = await menuAPI.getDomain();
      ref.read(menuProvider.notifier).updateDomain({
        'name': response['info']['domain'],
        'status': response['info']['status'],
        'created_at': response['info']['created_at'],
        'dns': {
          'ns1': response['info']['ns1'],
          'ns2': response['info']['ns2'],
        }
      });
    } catch (e) {
      ref.read(menuProvider.notifier).updateDomain({
        'name': '',
        'status': '',
        'created_at': '',
        'dns': {'ns1': '', 'ns2': ''}
      });
    }
    hideLoader(context);
  }

  Future<void> addDomain(dynamic domain) async {
    showLoader(context, AppLocalizations.of(context)!.menu_adding_domain);
    try {
      await menuAPI.addDomain(domain);
      await getMenuInfo();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(AppLocalizations.of(context)!.menu_failed_to_add_domain)));
    }
    hideLoader(context);
  }

  Future<void> checkDomain(String domainName) async {
    showLoader(
        context, AppLocalizations.of(context)!.menu_checking_domain_status);
    final response = await menuAPI.checkDomain(domainName);
    await getMenuInfo();

    hideLoader(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['message'])));
  }

  Future<void> deleteDomain(String domainName) async {
    showLoader(context, AppLocalizations.of(context)!.menu_deleting_domain);
    final response = await menuAPI.removeDomain(domainName);
    await getMenuInfo();

    hideLoader(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['message'])));
  }

  void showLoader(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
                child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.purple),
                    Text(
                      text,
                      style: TextStyle(color: Colors.purple),
                    )
                  ],
                ),
              ),
            )));
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMenuInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final domain = menuState['payload']['domain'];
    return Scaffold(
        appBar: CustomAppBar(haveIcon: true),
        body: Center(
          child: domain['status'] == 'error'
              ? Text(
                  AppLocalizations.of(context)!.menu_failed_to_load_domain,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              : domain['status'] == ''
                  ? MenuNoDomain(
                      addDomain: (domain) async {
                        addDomain(domain);
                      },
                    )
                  : MenuPendingActiveDomain(
                      domain: domain,
                      checkDomain: () async {
                        checkDomain(domain['name']);
                      },
                      deleteDomain: () async {
                        deleteDomain(domain['name']);
                      },
                    ),
        ));
  }
}
