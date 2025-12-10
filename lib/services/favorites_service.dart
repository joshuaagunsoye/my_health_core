import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteItem {
  final String id;
  final String title;
  final String route;
  final DateTime savedAt;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.route,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'route': route,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      title: json['title'],
      route: json['route'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }
}

class FavoritesService {
  static const String _key = 'saved_favorites';

  // Save a favorite item
  static Future<bool> saveFavorite(FavoriteItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();
      
      // Check if already exists
      if (favorites.any((fav) => fav.id == item.id)) {
        return false; // Already saved
      }
      
      favorites.add(item);
      
      final jsonList = favorites.map((fav) => fav.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
      return true;
    } catch (e) {
      print('Error saving favorite: $e');
      return false;
    }
  }

  // Remove a favorite item
  static Future<bool> removeFavorite(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();
      
      favorites.removeWhere((fav) => fav.id == id);
      
      final jsonList = favorites.map((fav) => fav.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
      return true;
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }

  // Get all favorites
  static Future<List<FavoriteItem>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => FavoriteItem.fromJson(json)).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  // Check if an item is favorited
  static Future<bool> isFavorited(String id) async {
    final favorites = await getFavorites();
    return favorites.any((fav) => fav.id == id);
  }

  // Toggle favorite (add if not exists, remove if exists)
  static Future<bool> toggleFavorite(FavoriteItem item) async {
    final isFav = await isFavorited(item.id);
    if (isFav) {
      return await removeFavorite(item.id);
    } else {
      return await saveFavorite(item);
    }
  }
}
