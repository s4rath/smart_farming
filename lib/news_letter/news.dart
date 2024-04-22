import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favManager.dart';
import 'news_details_provider.dart';
import 'news_model.dart';
import 'webview.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({
    super.key,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
    bool is_Favorite = false;
  FavoritesManager favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final newsDetailProvider =
          Provider.of<NewsDetailProvider>(context, listen: false);
      Article article = Article(
          sourceId: newsDetailProvider.sourceId,
          sourceName: newsDetailProvider.sourceName,
          author: newsDetailProvider.author,
          title: newsDetailProvider.title,
          description: newsDetailProvider.description,
          url: newsDetailProvider.story_url,
          urlToImage: newsDetailProvider.img,
          publishedAt: newsDetailProvider.publishedAt,
          content: newsDetailProvider.content);
      bool favoriteStatus = await favoritesManager.isFavorite(article);
      setState(() {
        is_Favorite = favoriteStatus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsDetailProvider =
        Provider.of<NewsDetailProvider>(context, listen: false);

    void shareArticle(
        String articleTitle, String articleUrl, String articleDescription) {
      Share.share('$articleTitle - $articleDescription\n$articleUrl');
    }

    void addToFavorites(Article article) async {
      await favoritesManager.addFavorite(article);
    }

    void removeFromFavorites(Article article) async {
      await favoritesManager.removeFavorite(article);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220.0),
        child: AppBar(
            title: const Text("News Details",
                style: TextStyle(color: Colors.white)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: IconButton(
                  disabledColor: Colors.amber,
                  focusColor: Colors.red,
                  icon: Icon(
                      is_Favorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red),
                  onPressed: () async {
                    if (!is_Favorite) {
                      addToFavorites(Article(
                          sourceId: newsDetailProvider.sourceId,
                          sourceName: newsDetailProvider.sourceName,
                          author: newsDetailProvider.author,
                          title: newsDetailProvider.title,
                          description: newsDetailProvider.description,
                          url: newsDetailProvider.story_url,
                          urlToImage: newsDetailProvider.img,
                          publishedAt: newsDetailProvider.publishedAt,
                          content: newsDetailProvider.content));
                      setState(() {
                        is_Favorite = true;
                      });
                    } else {
                      removeFromFavorites(Article(
                          sourceId: newsDetailProvider.sourceId,
                          sourceName: newsDetailProvider.sourceName,
                          author: newsDetailProvider.author,
                          title: newsDetailProvider.title,
                          description: newsDetailProvider.description,
                          url: newsDetailProvider.story_url,
                          urlToImage: newsDetailProvider.img,
                          publishedAt: newsDetailProvider.publishedAt,
                          content: newsDetailProvider.content));
                      setState(() {
                        is_Favorite = false;
                      });
                    }
                  },
                  color: Colors.white,
                ),
              )
            ],
            flexibleSpace: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                newsDetailProvider.img,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/notfound.jpg',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                  );
                },
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 40,
                ),
                Container(
                  height: 54,
                  width: 51,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: const DecorationImage(
                          image: AssetImage("assets/Unknown_person.jpg"),
                          fit: BoxFit.cover),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        maxLines: 1,
                        text: TextSpan(
                          text: newsDetailProvider.sourceName.trim(),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: .4),
                        )),
                    RichText(
                        maxLines: 1,
                        text: TextSpan(
                          text: newsDetailProvider.author.length > 44
                              ? newsDetailProvider.author
                                  .substring(0, 44)
                                  .trim()
                              : newsDetailProvider.author.trim()
                          // newsDetailProvider.author.trim()
                          ,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ))
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                newsDetailProvider.title.trim(),
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                newsDetailProvider.content.contains('[')
                    ? newsDetailProvider.content
                        .substring(0, newsDetailProvider.content.indexOf('['))
                    : newsDetailProvider.content,
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.transparent,
            height: 80,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0), backgroundColor: const Color(0xff5669FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsWebView(
                                  story_url: newsDetailProvider.story_url,
                                )));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Read More'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            color: Colors.transparent,
            height: 80,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                height: 80,
                width: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0), backgroundColor: const Color(0xff5669FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      shareArticle(
                        newsDetailProvider.title,
                        newsDetailProvider.story_url,
                        newsDetailProvider.description,
                      );
                    },
                    child: Icon(
                      Icons.share,
                      size: 40,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
