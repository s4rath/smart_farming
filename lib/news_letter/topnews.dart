import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'news.dart';
import 'news_details_provider.dart';
import 'news_model.dart';
import 'topnews_provider.dart';

class TopNewsScreen extends StatefulWidget {
  @override
  _TopNewsScreenState createState() => _TopNewsScreenState();
}

class _TopNewsScreenState extends State<TopNewsScreen> {
  final TopNewsProvider _topnewsProvider =TopNewsProvider();
  List<Article> favoriteArticles = []; // To store favorite articles

  @override
  void initState() {
    super.initState();
    loadArticle();
  }

  Future<void> loadArticle() async {
    final newsProvider = Provider.of<TopNewsProvider>(context, listen: false);
    await newsProvider.fetchNews();


    List<Article> article_list = newsProvider.newsList;
    print(article_list);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Agricultural News'),
      ),
      body: ListView.builder(
        
        itemCount: Provider.of<TopNewsProvider>(context).newsList.length,
        itemBuilder: (context, index) {
          // final Article article = favoriteArticles[index];
          final article = Provider.of<TopNewsProvider>(context).newsList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                 final newsDetailProvider =
                      Provider.of<NewsDetailProvider>(context, listen: false);
                      print(article.description);

                  newsDetailProvider.setDetails(
                      img: article.urlToImage,
                      description: article.description,
                      author: article.author,
                      title: article.title,
                      story_url: article.url,
                      sourceId: article.sourceId,
                      sourceName: article.sourceName,
                      publishedAt: article.publishedAt,
                      content: article.content);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NewsScreen();
                      },
                    ),
                  );
              },
              child: Container(
                 height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          article.urlToImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/notfound.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Flexible(
                          child: Container(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 20),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: article.title.trim(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                                // RichText(text: TextSpan(text: )),
                                ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 20),
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: article.description.length > 44
                                        ? article.description.substring(0, 44)
                                        : article.description,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                                // RichText(text: TextSpan(text: )),
                                ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: article.sourceId ?? "Unknown",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 0.8,
                                    softWrap: true,
                                    text: TextSpan(
                                      text:
                                          _truncateText(article.author, 20) ??
                                              '',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
              ),
            ),
          );
        },
      ),
    );
  }
}
String _truncateText(String? text, int maxLength) {
  if (text == null || text.length <= maxLength) {
    return text ?? '';
  } else {
    return text.substring(0, maxLength) + '...';
  }
}
