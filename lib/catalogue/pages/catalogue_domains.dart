import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/api/catalogue_api.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class CatalogueDomains extends ConsumerStatefulWidget {
  const CatalogueDomains({super.key});

  @override
  ConsumerState<CatalogueDomains> createState() => _CatalogueDomainsState();
}

class _CatalogueDomainsState extends ConsumerState<CatalogueDomains> {
  final catalogueAPI = CatalogueApi();
  Future<dynamic> getcatalogueInfo() async {
    showLoader(context, AppLocalizations.of(context)!.menu_getting_domain_info);

    try {
      final response = await catalogueAPI.getDomain();
      ref.read(catalogueProvider.notifier).updateDomain({
        'name': response['info']['domain'],
        'status': response['info']['status'],
        'created_at': response['info']['created_at'],
        'dns': {
          'ns1': response['info']['ns1'],
          'ns2': response['info']['ns2'],
        }
      });
    } catch (e) {
      ref.read(catalogueProvider.notifier).updateDomain({
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
      await catalogueAPI.addDomain(domain);
      await getcatalogueInfo();
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
    final response = await catalogueAPI.checkDomain(domainName);
    await getcatalogueInfo();

    hideLoader(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['message'])));
  }

  Future<void> deleteDomain(String domainName) async {
    showLoader(context, AppLocalizations.of(context)!.menu_deleting_domain);
    final response = await catalogueAPI.removeDomain(domainName);
    await getcatalogueInfo();

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
      getcatalogueInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    final domain = catalogueState['payload']['domain'];
    return Scaffold(appBar: CustomAppBar(haveIcon: true), body: Center());
  }
}
