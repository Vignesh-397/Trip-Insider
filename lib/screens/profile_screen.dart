import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripinsider/resources/auth_methods.dart';
import 'package:tripinsider/resources/firestore_methods.dart';
import 'package:tripinsider/screens/followers_screen.dart';
import 'package:tripinsider/screens/following_screen.dart';
import 'package:tripinsider/screens/login_screen.dart';
import 'package:tripinsider/screens/saved_posts_screen.dart';
import 'package:tripinsider/utils/colorsScheme.dart';
import 'package:tripinsider/utils/utils.dart';
import 'package:tripinsider/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool isLoading = false;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      var validPosts = postSnap.docs.where((doc) => doc.exists).toList();

      postLen = validPosts.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        userData = userSnap.data()!;
        isLoading = false;
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      var validPosts = postSnap.docs.where((doc) => doc.exists).toList();

      setState(() {
        postLen = validPosts.length;
      });
    } catch (err) {
      showSnackbar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: Color.fromRGBO(225, 232, 252, 1),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
              title: Text(
                userData['username'],
                style: GoogleFonts.pacifico(color: mobileBackgroundColor),
              ),
              centerTitle: false,
              automaticallyImplyLeading: false,
              actions: [
                FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SavedPostsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.saved_search,
                          color: mobileBackgroundColor,
                        ),
                      )
                    : const Icon(Icons.more_vert),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      content: ClipRect(
                                        child: CachedNetworkImage(
                                          imageUrl: userData['imgUrl'],
                                          height: 300,
                                          width: 60,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(
                                userData['imgUrl'],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'posts'),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          useSafeArea: true,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (ctx) {
                                            return FollowersScreen(
                                              uid: widget.uid,
                                            );
                                          },
                                        );
                                      },
                                      child: buildStatColumn(
                                          followers, 'followers'),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          useSafeArea: true,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (ctx) {
                                            return FollowingScreen(
                                              uid: widget.uid,
                                            );
                                          },
                                        );
                                      },
                                      child: buildStatColumn(
                                          following, 'following'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: Colors.white,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              if (context.mounted) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 200, 199, 205),
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  String res =
                                                      await FireStoreMethods()
                                                          .followUser(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid']);
                                                  setState(() {
                                                    followers--;
                                                    isFollowing = false;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  String res =
                                                      await FireStoreMethods()
                                                          .followUser(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid']);
                                                  setState(() {
                                                    followers++;
                                                    isFollowing = true;
                                                  });
                                                },
                                              ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: mobileBackgroundColor,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(
                            color: mobileBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];

                        return InkWell(
                          onLongPress: () {
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                                onTap: () {
                                                  deletePost(
                                                    snapshot.data!
                                                        .docs[index]['postId']
                                                        .toString(),
                                                  );
                                                  // remove the dialog box
                                                  Navigator.of(context).pop();
                                                }),
                                          )
                                          .toList()),
                                );
                              },
                            );
                          },
                          child: Container(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: mobileBackgroundColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: mobileBackgroundColor),
          ),
        )
      ],
    );
  }
}
