import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

var homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text('notifications')),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
