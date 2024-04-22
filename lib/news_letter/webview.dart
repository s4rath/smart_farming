import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  final String story_url;
  const NewsWebView({super.key,required this.story_url});
  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  late WebViewController controller;
  // final controller= WebViewController()
  // ..setJavaScriptMode(JavaScriptMode.disabled)..loadRequest(Uri.parse(widget.story_url) );
  @override
  void initState() {
    super.initState();
    loadWebView();
  }

  void loadWebView() {
    controller = WebViewController();
    controller
       ..setJavaScriptMode(JavaScriptMode.disabled)..loadRequest(Uri.parse(widget.story_url) );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:WebViewWidget(controller: controller,)
    );
  }
}