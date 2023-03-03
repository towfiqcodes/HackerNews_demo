import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hacker_news/core/model/comment.dart';
import 'package:hacker_news/core/model/story.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  final List<int> topStoryIds = [];
  final List<Story> topStories = [];
  final List<Story> bookMarkedStories = [];
  final List<Comment> comments = [];

  Future<void> getTopStories() async {
    topStoryIds.clear();
    topStories.clear();
    try {
      http.Response response = await http.get(
        Uri.parse("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"),
      );
      if (response.statusCode == 200) {
        var payloads = jsonDecode(response.body);
        for (var payload in payloads) {
          topStoryIds.add(payload);
        }
        topStoryIds.forEach((element) async {
          try {
            http.Response response2 = await http.get(
                Uri.parse("https://hacker-news.firebaseio.com/v0/item/$element.json?print=pretty"));
            var payloads2 = jsonDecode(response2.body);
            Story story = Story.fromJson(payloads2);
            topStories.add(story);
            notifyListeners();
          } on TimeoutException catch (error) {
            topStories.add(Story());
          } on SocketException catch (error) {
            topStories.add(Story());
            debugPrint("Socket exception - $error");
          }
          notifyListeners();
        });
      }
      notifyListeners();
    } on TimeoutException catch (error) {
      debugPrint("timeout - $error");
    } on SocketException catch (error) {
      debugPrint("Socket exception - $error");
    } catch (e) {
      debugPrint("error - ${e.toString()}");
    }
  }

  Future<void> getComments({required List<int> kids}) async {
    comments.clear();
    kids.forEach((element) async {
      try {
        http.Response response = await http.get(
            Uri.parse("https://hacker-news.firebaseio.com/v0/item/$element.json?print=pretty"));
        var payloads = jsonDecode(response.body);
        Comment comment = Comment.fromJson(payloads);
        comments.add(comment);
        notifyListeners();
      } on TimeoutException catch (error) {
        comments.add(Comment());
        debugPrint("timeout - $error");
      } on SocketException catch (error) {
        comments.add(Comment());
        debugPrint("Socket exception - $error");
      } catch (e) {
        debugPrint("error - ${e.toString()}");
      }
    });
    notifyListeners();
  }

  Future<void> getBookmarkedNews(List<String> newsList) async {
    bookMarkedStories.clear();
    newsList.forEach((element) async {
      try {
        http.Response response2 = await http
            .get(Uri.parse("https://hacker-news.firebaseio.com/v0/item/$element.json?print=pretty"));
        var payloads2 = jsonDecode(response2.body);
        Story story = Story.fromJson(payloads2);
        bookMarkedStories.add(story);
        notifyListeners();
      } on TimeoutException catch (error) {
        bookMarkedStories.add(Story());
      } on SocketException catch (error) {
        bookMarkedStories.add(Story());
        debugPrint("Socket exception - $error");
      } catch (error) {
        debugPrint("Error - $error");
      }
    });

  }
}
