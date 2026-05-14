import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import '../../style/style.dart';
import './login.dart';
import './signup.dart';

class NotLogged extends StatefulWidget {
  const NotLogged({super.key});
  @override
  State<NotLogged> createState() => _NotLoggedState();
}

enum Type { login, signup }

class _NotLoggedState extends State<NotLogged> {
  Type type = Type.login;
  void loginPressed() {
    setState(() {
      type = Type.login;
    });
  }

  void signupPressed() {
    setState(() {
      type = Type.signup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color.fromARGB(0, 0, 0, 0), Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          border: Border(
                            top: BorderSide(color: Colors.white, width: 2),
                            right: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: ElevatedButton(
                            onPressed: loginPressed,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)),
                            child: Text(
                              AppLocalizations.of(context)!.log_in,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500),
                            )))),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Color.fromARGB(0, 0, 0, 0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30)),
                          border: Border(
                            bottom: BorderSide(color: Colors.white, width: 2),
                            left: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: ElevatedButton(
                            onPressed: signupPressed,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)),
                            child: Text(
                              AppLocalizations.of(context)!.sign_up,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500),
                            )))),
              ],
            )),
        Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
            child: Column(
              children: [type == Type.login ? Login() : Signup()],
            ))
      ],
    ));
  }
}
