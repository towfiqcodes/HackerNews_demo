import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hacker_news/core/custom_widgets/custom_text.dart';
import 'package:hacker_news/core/model/story.dart';
import 'package:hacker_news/core/provider/internet_connection/internet_connection_page.dart';
import 'package:hacker_news/core/provider/news_provider.dart';
import 'package:hacker_news/core/utils/constants.dart';
import 'package:hacker_news/view/home/bookmarked_news.dart';
import 'package:hacker_news/view/home/news_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/provider/internet_connection/connectivity_provider.dart';
import '../../core/utils/connectionStatusSingleton.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  List<Story> stories = [];
  List<String> bookmarkedList = [];
  late StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  void initState() {
    //Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTopStories();
      getBookmarkedNews();
    });

    super.initState();
  }

  void getTopStories() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    setState(() => loading = true);
    await newsProvider.getTopStories().then((value) {
      setState(() {
        stories = newsProvider.topStories;
        loading = false;
      });
    });
  }
  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    stories = newsProvider.topStories;

    return (!isOffline)? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const CustomText(
                text: "Top News",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookedMarkedNews()));
                  },
                  icon: const Icon(
                    Icons.bookmark_outline,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        Story story = stories[index];
                        return newsItem(story: story, index: index);
                      },
                    ),
            )): NoInternetConnect();
  }

  Widget newsItem({required Story story, required int index}) {
    return InkWell(
      onTap: () => newsDetails(story: story),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              height: 18,
              width: 18,
              alignment: Alignment.center,
              child: CustomText(
                text: (index + 1).toString(),
                color: Colors.white,
                fontSize: 8,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: story.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CustomText(
                                  text: "by ",
                                  color: Colors.grey,
                                ),
                                CustomText(
                                  text: story.by,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: story.score.toString(),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.messenger_outline,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: story.kids.length.toString(),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => bookmarkNews(newsId: story.id),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            !didBookmarked(newsId: story.id)
                                ? Icons.bookmark_outline
                                : Icons.bookmark,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void bookmarkNews({required int newsId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarkedList = prefs.getStringList(Constants.bookmarkedList) ?? [];
    if (bookmarkedList.contains(newsId.toString())) {
      bookmarkedList.removeWhere((element) => element == newsId.toString());
    } else {
      bookmarkedList.add(newsId.toString());
    }
    prefs.setStringList(Constants.bookmarkedList, bookmarkedList);
    setState(() {});
  }

  void newsDetails({required Story story}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NewsDetails(story: story)));
  }

  bool didBookmarked({required int newsId}) {
    if (bookmarkedList.contains(newsId.toString())) {
      return true;
    }
    return false;
  }

  void getBookmarkedNews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarkedList = prefs.getStringList(Constants.bookmarkedList) ?? [];
    setState(() {});
  }
}
