import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/post_model.dart';
import 'screens/posts_screen.dart';

void main() async {
  // Needed because we await before runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialise Hive
  await Hive.initFlutter();

  // 2. Register adapters (before opening any box that stores this type)
  Hive.registerAdapter(PostAdapter());

  // 3. Open boxes early so Hive.box(...) works synchronously everywhere
  await Hive.openBox<Post>('postsBox');
  await Hive.openBox<Post>('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostsScreen(),
    );
  }
}
