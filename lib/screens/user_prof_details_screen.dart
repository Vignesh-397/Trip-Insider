import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripinsider/screens/profile_screen.dart';

class UserProfDetails extends StatefulWidget {
  final snap;
  const UserProfDetails({super.key, required this.snap});

  @override
  State<UserProfDetails> createState() => _UserProfDetailsState();
}

class _UserProfDetailsState extends State<UserProfDetails> {
  bool isFecthing = false;
  var userInfo;
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    setState(() {
      isFecthing = true;
    });
    var follower = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap)
        .get();
    setState(() {
      userInfo = follower.data();
      isFecthing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isFecthing
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  uid: userInfo['uid'],
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        CachedNetworkImageProvider(userInfo['imgUrl']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: userInfo['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
