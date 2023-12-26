import 'package:flutter/material.dart';
import 'package:tripinsider/screens/add_post_screen.dart';
import 'package:tripinsider/screens/feeds_screen.dart';
import 'package:tripinsider/screens/profile_screen.dart';

final homePageItems = [
  const FeedsScreen(),
  const AddPostScreen(),
  const Center(child: Text('Search')),
  const ProfileScreen()
];
