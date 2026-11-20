import 'package:hive/hive.dart';
import '../models/post_model.dart';

/// Data layer for favorites. Screens never touch Hive directly.
/// Key = post.id, so lookups/deletes are O(1) and a post can't be saved twice.
class FavoritesService {
  static const String boxName = 'favoritesBox';

  // The box is already opened in main.dart, so this is synchronous.
  Box<Post> get _box => Hive.box<Post>(boxName);

  /// Exposed so screens can use ValueListenableBuilder without importing Hive logic.
  Box<Post> get box => _box;

  bool isFavorite(int id) => _box.containsKey(id);

  /// Adds the post if it is not a favorite, removes it otherwise.
  /// Returns the new state (true = now a favorite).
  Future<bool> toggleFavorite(Post post) async {
    if (_box.containsKey(post.id)) {
      await _box.delete(post.id);
      return false;
    }
    // A HiveObject can only live in one box, so store a COPY, not `post` itself.
    final copy = Post(
      id: post.id,
      title: post.title,
      body: post.body,
      userId: post.userId,
    );
    await _box.put(post.id, copy);
    return true;
  }

  List<Post> getFavorites() => _box.values.toList();
}
