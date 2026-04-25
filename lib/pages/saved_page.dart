import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/services/favorites_service.dart';

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<FavoriteItem> _favorites = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<FavoriteItem> _filteredFavorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favorites = await FavoritesService.getFavorites();
    if (!mounted) return;
    setState(() {
      _favorites = favorites;
      _filteredFavorites = favorites;
      _isLoading = false;
    });
  }

  void _filterFavorites(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFavorites = _favorites;
      } else {
        _filteredFavorites = _favorites
            .where((fav) =>
                fav.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _removeFavorite(String id) async {
    await FavoritesService.removeFavorite(id);
    if (!mounted) return;
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: AppColors.myrtleGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/education.png',
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          'My Saved Content',
          style: TextStyle(
            color: AppColors.getTextColor(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceColor(context),
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: AppColors.getTextColor(context).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.getTextColor(context),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterFavorites,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: AppColors.getTextColor(context).withOpacity(0.5),
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.black, thickness: 2),
                  SizedBox(height: 16),
                  // Favorites list
                  Expanded(
                    child: _filteredFavorites.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 64,
                                  color: AppColors.getTextColor(context).withOpacity(0.3),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'No saved content yet'
                                      : 'No results found',
                                  style: TextStyle(
                                    color: AppColors.getTextColor(context).withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                if (_searchController.text.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Save pages by tapping the heart icon',
                                      style: TextStyle(
                                        color: AppColors.getTextColor(context).withOpacity(0.4),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredFavorites.length,
                            itemBuilder: (context, index) {
                              final favorite = _filteredFavorites[index];
                              return Card(
                                color: AppColors.getSurfaceColor(context),
                                margin: EdgeInsets.only(bottom: 12.0),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  title: Text(
                                    favorite.title,
                                    style: TextStyle(
                                      color: AppColors.getTextColor(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Saved ${_formatDate(favorite.savedAt)}',
                                      style: TextStyle(
                                        color: AppColors.getTextColor(context).withOpacity(0.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeFavorite(favorite.id),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, favorite.route);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'just now';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
