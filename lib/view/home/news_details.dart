import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hacker_news/core/model/story.dart';
import 'package:provider/provider.dart';
import '../../core/custom_widgets/custom_text.dart';
import '../../core/model/comment.dart';
import '../../core/provider/news_provider.dart';

class NewsDetails extends StatefulWidget {
  final Story story;

  const NewsDetails({Key? key, required this.story}) : super(key: key);

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  bool loading = false;
  List<Comment> comments = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getComments();
    });
    super.initState();
  }

  void getComments() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    setState(() => loading = true);
    await newsProvider.getComments(kids: widget.story.kids).then((value) {
      setState(() {
        comments = newsProvider.comments;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    comments = newsProvider.comments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const CustomText(
          text: "News Details",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: widget.story.title,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "- by ",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  CustomText(
                    text: widget.story.by,
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: widget.story.score.toString(),
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                          fontSize: 16,
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
                          size: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: widget.story.kids.length.toString(),
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () => bookmarkNews(newsId: widget.story.id),
                    //     child: Container(
                    //       alignment: Alignment.centerRight,
                    //       child: const Icon(
                    //         Icons.bookmark_outline,
                    //         color: Colors.black,
                    //         size: 24,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomText(
                text: "Comments",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.all(100),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return commentItem(comment: comments[index], index: index);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  bookmarkNews({required int newsId}) {}

  Widget commentItem({required Comment comment, required int index}) {
    return comment.text != ''
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "@${comment.by}",
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
              Html(
                data: comment.text,
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade200,
                height: 1,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        : const SizedBox();
  }
}
