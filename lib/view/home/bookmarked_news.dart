import 'package:flutter/material.dart';
import 'package:hacker_news/view/home/news_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/custom_widgets/custom_text.dart';
import '../../core/model/story.dart';
import '../../core/provider/news_provider.dart';
import '../../core/utils/constants.dart';

class BookedMarkedNews extends StatefulWidget {
  const BookedMarkedNews({Key? key}) : super(key: key);

  @override
  State<BookedMarkedNews> createState() => _BookedMarkedNewsState();
}

class _BookedMarkedNewsState extends State<BookedMarkedNews> {
  bool loading = false;
  List<Story> bookMarkedStories = [];

  void getBookmarkedStories() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedList = prefs.getStringList(Constants.bookmarkedList) ?? [];
    setState(() => loading = true);
    await newsProvider.getBookmarkedNews(bookmarkedList).then((value) {
      setState(() {
        bookMarkedStories = newsProvider.bookMarkedStories;
        loading = false;
      });
    });
  }

  @override
  void initState() {
    getBookmarkedStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    bookMarkedStories = newsProvider.bookMarkedStories;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const CustomText(
          text: "Bookmarked News",
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 24,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
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
          itemCount: bookMarkedStories.length,
          itemBuilder: (context, index) {
            Story story = bookMarkedStories[index];
            return newsItem(story: story, index: index);
          },
        ),
      ),
    );
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
                        onTap: () => deleteBookmarkedNews(newsId: story.id, index: index),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
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

  void newsDetails({required Story story}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetails(story: story)));
  }

  deleteBookmarkedNews({required int newsId, required int index}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedList = prefs.getStringList(Constants.bookmarkedList) ?? [];
    bookmarkedList.removeWhere((element) => element == newsId.toString());
    prefs.setStringList(Constants.bookmarkedList, bookmarkedList);
    setState(() {
      bookMarkedStories.removeAt(index);
    });
  }
}
