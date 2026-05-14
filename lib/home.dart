import 'package:flutter/material.dart';
import 'package:moonlinks/elements/news_card.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/z_test.dart';
import 'style/style.dart';
import 'elements/gradient.dart';
import './api/news.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final newsAPI = NewsAPI();
  List<dynamic>? dataNews;
  @override
  void initState() {
    super.initState();
    getHomeNews();
  }

  void getHomeNews() async {
    try {
      final response = await newsAPI.getNews();
      setState(() {
        dataNews = response['results'];
      });
    } catch (e) {
      throw Exception('errror retrieving data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dataNews == null) {
      return Scaffold(
          body: RadialBackground(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
      ));
    }
    return Scaffold(
      body: RadialBackground(
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
            child: /* Center(
              child: ZTest(),
            ) */

                ListView(
              children: [
                SizedBox(height: 50),
                Text(
                  AppLocalizations.of(context)!.infinite_access,
                  textAlign: TextAlign.center,
                  style: appTextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.what_we_offer_and_whats_new,
                  textAlign: TextAlign.center,
                  style: appTextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 168, 168, 168),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ...dataNews!.map((data) => NewsCard(
                      title: data['title'] ?? 'No title',
                      date: data['date'] ?? '',
                      description: data['description'] ?? '',
                      image: data['image'] ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxjilx_JM8hDh5mZdD7jADnYrcitfBBICFGA&s',
                    )),
              ],
            )),
      ),
    );
  }
}
