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
        // backgroundColor: Colors.white,
        // bottomOpacity: 0,
        // elevation: 0,
        title: const Text("News Letter", style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 213,158,104),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      body: Stack(children: [
         Positioned.fill(
          child: Image.asset(
            'assets/images/nell.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.1),
        ),
        Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200.0,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Container(
                            width: 150.0,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              elevation: 4.0,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: ((ctx) {
                                    return TopNewsScreen();
                                  })));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Hero(
                                    tag: "imgiTag",
                                    child: Container(
                                      // height: 54,
                                      // width: 51,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/iot.png"),
                                              fit: BoxFit.cover),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                ),
                Container(
                  height: 200.0,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Container(
                            width: 150.0,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              elevation: 4.0,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: ((ctx) {
                                    return FavoritesScreen();
                                  })));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Hero(
                                    tag: "imgTag",
                                    child: Container(
                                      // height: 54,
                                      // width: 51,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/bookmark.jpeg"),
                                              fit: BoxFit.cover),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
