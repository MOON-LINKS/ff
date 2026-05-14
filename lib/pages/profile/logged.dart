import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/main.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';
import '../../style/style.dart';
import '../../elements/input.dart';
import '../../elements/button.dart';

class Logged extends ConsumerStatefulWidget {
  const Logged({super.key});
  @override
  ConsumerState<Logged> createState() => _LoggedState();
}

class _LoggedState extends ConsumerState<Logged> {
  final authService = AuthService();
  late TextEditingController nameController;
  late TextEditingController credController;
  int session = 0;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    credController = TextEditingController();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final storedToken = await readToken();
      final response = await authService.getUserInfo(storedToken!);

      final user = response["user"];
      setState(() {
        session = response['user']['sessions'].length;
      });
      nameController.text = user["name"];
      credController.text = user["cred"];
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    credController.dispose();
    super.dispose();
  }

  void logout() async {
    final token = await readToken();
    if (token != null && token.isNotEmpty) {
      await authService.logout(token);
    }
    await deleteToken();
    ref.read(subServicesProvider.notifier).removeAll();
    await ref.read(menuProvider.notifier).resetAll();
    ref.read(cartProvider.notifier).removeAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Main()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.profile,
              style: appTextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.information_about_you,
              style: appTextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 168, 168, 168),
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomInput(
                label: AppLocalizations.of(context)!.name,
                readOnly: true,
                type: InputType.text,
                controller: nameController),
            CustomInput(
                label: AppLocalizations.of(context)!.email,
                readOnly: true,
                type: InputType.email,
                controller: credController),
            /* CustomInput( label: "Password", readOnly: true, type: InputType.password, controller: ), */
            CustomButton(
                function: logout, name: AppLocalizations.of(context)!.logout),
          ],
        ),
      ),
      /* AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: 0,
          left: 0,
          right: 0,
          height: _isExpanded ? screenHeight * .4 : 60,
          child: GestureDetector(
              onTap: () => setState(() {
                    _isExpanded = !_isExpanded;
                  }),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 30,
                      children: [
                        const Text(
                          "Sessions",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Row(children: [
                          Text(
                            session.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                           const SizedBox(width: 10),
                          Transform.rotate(
                            angle: _isExpanded ? 3.14 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white,
                              size: 30,
                            ),
                          ), 
                        ]),
                      ],
                    ),*/
      /*   if (_isExpanded)
                      Expanded(
                        child: ListView(
                          children: List.generate(
                              10,
                              (index) => ListTile(
                                    title: Text(
                                      "Session ${index + 1}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )),
                        ),
                      ), 
                  ],
                ),
              )))*/
    ]);
  }
}
