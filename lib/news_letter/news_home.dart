import 'package:flutter/material.dart';

import 'fav_screen.dart';
import 'topnews.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}
class _NewsHomePageState extends State<NewsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Updates", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255,213,159,100),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.brown.shade900.withOpacity(0.8),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/OIG4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(0.3), // Black overlay
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.brown.shade900.withOpacity(0.7), // Black overlay
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 280.0,
                  height: 240.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // White overlay with reduced opacity
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: ((ctx) {
                            return TopNewsScreen();
                          })));
                        },
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'News Corner',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Hero(
                              tag: "imgiTag",
                              child: Container(
                                height: 175,

                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/news2-modified.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 280.0,
                  height: 240.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // White overlay with reduced opacity
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: ((ctx) {
                            return FavoritesScreen();
                          })));
                        },
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Bookmarks',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Hero(
                              tag: "imgTag",
                              child: Container(
                                height: 177,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/bookmarks.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
