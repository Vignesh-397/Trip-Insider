import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripinsider/models/user.dart' as model;
import 'package:tripinsider/providers/user_provider.dart';
import 'package:tripinsider/resources/firestore_methods.dart';
import 'package:tripinsider/screens/comment_screen.dart';
import 'package:tripinsider/screens/info_screen.dart';
import 'package:tripinsider/screens/profile_screen.dart';
import 'package:tripinsider/utils/colorsScheme.dart';
import 'package:tripinsider/utils/utils.dart';
import 'package:tripinsider/widgets/like_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String currentUid = FirebaseAuth.instance.currentUser!.uid;
  bool isLikeAnimating = false;
  int commentLength = 0;
  List savedposts = [];
  bool isPostSaved = false;

  @override
  void initState() {
    super.initState();
    getComments();
    getuser();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLength = snap.docs.length;
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  void getuser() async {
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .get();
      setState(() {
        savedposts =
            (userSnap.data() as Map<String, dynamic>?)?['savedposts'] ?? [];
        isPostSaved = savedposts.contains(widget.snap['postId']);
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300.0,
          child: const Column(
            children: [
              ListTile(
                title: Text('Location: New York'),
                subtitle: Text('Expenditure: \$500'),
              ),
              ListTile(
                title: Text('Location: Paris'),
                subtitle: Text('Expenditure: \$800'),
              ),
              ListTile(
                title: Text('Location: Tokyo'),
                subtitle: Text('Expenditure: \$600'),
              ),
              // Add more ListTile widgets as needed
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getComments();
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(225, 232, 252, 1),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(225, 232, 252, 1),
            Color.fromRGBO(15, 13, 88, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      // padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(
              right: 0,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        NetworkImage(widget.snap['profImage'].toString()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: user.uid),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 111, 87, 210),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: InfoScreen(snap: widget.snap),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.info_outline_rounded,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      widget.snap['postId'].toString(),
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Color.fromRGBO(225, 232, 252, 1),
                        ),
                ),
              ),
              IconButton(
                onPressed: () => showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) {
                    return CommentScreen(
                      snap: widget.snap,
                    );
                  },
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Color.fromRGBO(225, 232, 252, 1),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () async {
                      String res = await FireStoreMethods()
                          .toggleSavedPost(widget.snap['postId']);
                      setState(() {
                        isPostSaved = !isPostSaved;
                      });
                      showSnackbar(res, context);
                    },
                    icon: isPostSaved
                        ? const Icon(
                            Icons.bookmark,
                            color: Color.fromRGBO(225, 232, 252, 1),
                          )
                        : const Icon(
                            Icons.bookmark_border,
                            color: Color.fromRGBO(225, 232, 252, 1),
                          ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (widget.snap['likes']?.length ?? 0).toString() + ' likes',
                  style: TextStyle(color: Color.fromARGB(255, 174, 176, 243)),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: loginButtonColor),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                          style: const TextStyle(
                            color: Color.fromRGBO(225, 232, 252, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: commentLength > 0
                        ? InkWell(
                            onTap: () => showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (ctx) {
                                return CommentScreen(
                                  snap: widget.snap,
                                );
                              },
                            ),
                            child: Text(
                              'View all ${commentLength} comments',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
