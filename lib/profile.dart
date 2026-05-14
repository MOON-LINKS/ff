import 'package:flutter/material.dart';
import 'package:moonlinks/elements/gradient.dart';
import 'package:moonlinks/elements/language_selector.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'pages/profile/logged.dart';
import './pages/auth/login_signup.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? token;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storedToken = await readToken();
    setState(() {
      token = storedToken;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RadialBackground(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 100),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 15,
                          children: [
                            (token != null && token!.isNotEmpty
                                ? Logged()
                                : NotLogged()),
                            LanguageSelector()
                          ],
                        ),
                      )))),
    );
  }
}
