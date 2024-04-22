import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'favManager.dart';
import 'news.dart';
import 'news_details_provider.dart';
import 'news_model.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with WidgetsBindingObserver{
  List<Article> favoriteArticles = []; // To store favorite articles

  @override
  void initState() {
    super.initState();
    loadFavorites();
    WidgetsBinding.instance.addObserver(this);
  }

   @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      loadFavorites();
    }
  }


  Future<void> loadFavorites() async {
    List<String> favoritesJson = await FavoritesManager().getFavorites();
    List<Article> favorites = [];
    for (String jsonStr in favoritesJson) {
     
      final Map<String, dynamic> articleJson = json.decode(jsonStr);
      final Article article = Article.fromFavJson(articleJson);
      favorites.add(article);
    }
    setState(() {
      favoriteArticles = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body:favoriteArticles.isEmpty
        ? Center(
            child: Text('No favorite articles available.'),
          )
        : ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (context, index) {
          final Article article = favoriteArticles[index];
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
                  final result=Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NewsScreen();
                      },
                    ),
                  );
                  if (result!=null){
                    setState(() {
                      
                    loadFavorites();
                    });
                  }
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
