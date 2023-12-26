import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripinsider/screens/add_post_screen.dart';
import 'package:tripinsider/screens/feeds_screen.dart';
import 'package:tripinsider/screens/profile_screen.dart';
import 'package:tripinsider/screens/saerch_screen.dart';

List<Widget> homePageItems = [
  const FeedsScreen(),
  const AddPostScreen(),
  const SearchScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
