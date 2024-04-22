import 'dart:convert';

import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'news_model.dart';

class FavoritesManager {
  static const String _keyFavorites = 'favorites';
  Future<List<String>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_keyFavorites) ?? [];
    return favoritesJson;
  }

  Future<void> addFavorite(Article article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    String articleJson = json.encode(article.toJson());
    if (!favorites.contains(articleJson)) {
      favorites.add(articleJson);
      await prefs.setStringList(_keyFavorites, favorites);
    }
  }

  Future<void> removeFavorite(Article article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    String articleJson = json.encode(article.toJson());
    favorites.remove(articleJson);
    await prefs.setStringList(_keyFavorites, favorites);
  }

  Future<bool> isFavorite(Article article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    String articleJson = json.encode(article.toJson());
    return favorites.contains(articleJson);
  }
}
