import 'package:flutter/material.dart';

class NewsDetailProvider extends ChangeNotifier {
  String sourceId = "";
  String sourceName = "";
  String title = '';
  String description = '';
  String story_url="";
  String img = '';
  String author = '';
  String content = '';
  DateTime publishedAt=DateTime(2000);

  void setDetails({
    required String sourceId,
    required String sourceName,
    required String img,
    required String description,
    required String author,
    required String title,
    required String story_url,
    required String content,
    required DateTime publishedAt,

  }) {
    this.sourceId = sourceId;
    this.sourceName = sourceName;
    this.img = img;
    this.description = description;
    this.author = author;
    this.title = title;
    this.story_url=story_url;
    this.content=content;
    this.publishedAt=publishedAt;
    notifyListeners();
  }
}