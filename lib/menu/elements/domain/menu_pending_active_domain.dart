import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_divider.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class MenuPendingActiveDomain extends StatefulWidget {
  final dynamic domain;
  final Future<void> Function() deleteDomain;
  final Future<void> Function() checkDomain;
  const MenuPendingActiveDomain(
      {super.key,
      required this.domain,
      required this.deleteDomain,
      required this.checkDomain});

  @override
  State<MenuPendingActiveDomain> createState() =>
      _MenuPendingActiveDomainState();
}

class _MenuPendingActiveDomainState extends State<MenuPendingActiveDomain> {
  void delete() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(AppLocalizations.of(context)!.menu_delete_domain,
                  style: TextStyle(color: Colors.black)),
              content: Text(
                  AppLocalizations.of(context)!.menu_delete_domain_message,
                  style: TextStyle(color: Colors.black)),
              actions: [
                CustomMenuButton(
                    child: AppLocalizations.of(context)!.menu_delete,
                    onPressed: () async {
                      await widget.deleteDomain();
                      Navigator.of(context).pop();
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      children: [
        CustomTitleSection(
          margin: 100,
          title: AppLocalizations.of(context)!.menu_your_domain,
          toolTip: AppLocalizations.of(context)!.menu_check_domain_status,
        ),
        const CustomDivider(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: context.screenWidth * (context.isWide ? .4 : .8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Stack(children: [
            Positioned(
                top: 0,
                right: 5,
                child: Text(
                  '${AppLocalizations.of(context)!.menu_applied_on}: ${widget.domain['created_at'].toString().split('T').first}',
                  style: TextStyle(color: Colors.black),
                )),
            Center(
                child: Column(
              spacing: 10,
              children: [
                const SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: context.screenWidth * .5,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.menu_your_domain}: ${widget.domain['name']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          child: Icon(Icons.copy, color: Colors.white),
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: widget.domain['name']));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .menu_url_copied)));
                          },
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Column(
                    spacing: 10,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.menu_nameservers_title,
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: context.screenWidth * .5,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              Text(
                                'ns1: ${widget.domain['dns']['ns1']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              InkWell(
                                child: Icon(Icons.copy, color: Colors.white),
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: widget.domain['dns']['ns1']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .menu_ns1_copied)));
                                },
                              )
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: context.screenWidth * .5,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              Text(
                                'ns2: ${widget.domain['dns']['ns2']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              InkWell(
                                child: Icon(Icons.copy, color: Colors.white),
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: widget.domain['dns']['ns2']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .menu_ns2_copied)));
                                },
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                CustomMenuButton(
                    child: AppLocalizations.of(context)!.menu_check_domain,
                    onPressed: widget.checkDomain),
                Text(
                    "${AppLocalizations.of(context)!.status}: ${widget.domain['status']}",
                    style: TextStyle(
                      color: widget.domain['status'] == 'pending'
                          ? Colors.amber
                          : Colors.greenAccent,
                    )),
                IconButton(
                    onPressed: delete,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            ))
          ]),
        )
      ],
    );
  }
}
