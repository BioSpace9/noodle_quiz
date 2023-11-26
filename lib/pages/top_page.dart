import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:noodle_quiz/AppOpenAdManager.dart';
import 'package:noodle_quiz/methods.dart';
import 'package:noodle_quiz/model/quiz.dart';
import 'package:noodle_quiz/pages/quiz_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  late BannerAd _anchoredBanner;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createAnchoreBanner(context);
    });
  }

  static final AdRequest request = AdRequest();

  Future<void> _createAnchoreBanner(BuildContext context) async {

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
            Orientation.portrait, MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
        ? 'ca-app-pub-2284509452520955/6585602993'
        : 'ca-app-pub-2284509452520955/8112902118',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          _anchoredBanner.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed'),
      ),
    );
    await banner.load();
    setState(() {
      _anchoredBanner = banner;
    });
  }

  @override
  void dispose() {
    _anchoredBanner.dispose();
    super.dispose();
  }

  final quizCollection = FirebaseFirestore.instance.collection('quiz');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.ramen_dining),
                SizedBox(width: 8),
                Text(
                  '麺顔クエスト',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.local_dining)
              ],
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.new_releases), text: '最新投稿'),
                Tab(icon: Icon(Icons.category), text: 'ジャンル別'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildLatestPostsTab(),
              buildCategoryPostsTab(),
            ],
          ),
        ),
    );
  }

  Widget buildLatestPostsTab() {
    return Container(
        color: Colors.yellow.shade100,
        child: StreamBuilder<QuerySnapshot>(
            stream: quizCollection
                .where('name', isNotEqualTo: null)
                .orderBy('createdDate', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //ロード中の状態を確認
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('Stream is waiting for data...');
                return const Center(child: CircularProgressIndicator());
              }

              // エラーが発生している場合はその情報をログに出力
              if (snapshot.hasError) {
                print('Stream encountered an error: ${snapshot.error}');
                return const Center(child: Text('Something went wrong!'));
              }

              // データが存在しない場合
              if (!snapshot.hasData) {
                print('Stream has no data.');
                return const Center(child: Text('No data found.'));
              }

              // データが取得できたら、ListViewを構築
              if (snapshot.hasData) {
                print('Stream has data: ${snapshot.data}');
                // 以下、データ表示のコード...
              }

              return Column(
                children: [
                  Container (height: 100, child: AdWidget(ad: _anchoredBanner)),
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                        final Quiz fetchQuiz = Quiz(
                          name: data['name'],
                          region: data['region'],
                          type: data['type'],
                          opt1: data['opt1'],
                          opt2: data['opt2'],
                          opt3: data['opt3'],
                          comment: data['comment'],
                          image: data['image'],
                          createdDate: data['createdDate'],
                        );

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.ramen_dining),
                            title: Text(
                              fetchQuiz.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            tileColor: Colors.white,
                            onTap: () {
                              fetchQuiz.answer = null;
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => QuizPage(fetchQuiz)));
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
        ),
      );
  }

  Widget buildCategoryPostsTab() {
    return Container(
      color: Colors.yellow.shade100,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
                  children: [
                    viewCategoryList(context,"醤油ラーメン"),
                    viewCategoryList(context,"味噌ラーメン"),
                    viewCategoryList(context,"塩ラーメン"),
                    viewCategoryList(context,"豚骨ラーメン"),
                    viewCategoryList(context,"MIX"),
                    viewCategoryList(context,"清湯つけ麺"),
                    viewCategoryList(context,"濃厚つけ麺"),
                    viewCategoryList(context,"汁なし"),
                    viewCategoryList(context,"煮干しラーメン"),
                    viewCategoryList(context,"鶏白湯"),
                    viewCategoryList(context,"家系"),
                    viewCategoryList(context,"G系ラーメン"),
                    viewCategoryList(context,"担々麺"),
                  ],
                ),
        ),
      ),
    );
  }

}



