import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripinsider/resources/firestore_methods.dart';
import 'package:tripinsider/utils/colorsScheme.dart';
import 'package:tripinsider/utils/utils.dart';
import 'package:tripinsider/widgets/comment_card.dart';
import 'package:tripinsider/models/user.dart' as model;
import 'package:tripinsider/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final dynamic snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreeState();
}

class _CommentScreeState extends State<CommentScreen> {
  bool isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 208, 220, 253),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 208, 220, 253),
          title: const Text('Comments'),
          centerTitle: false,
          automaticallyImplyLeading: false),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          isLoading = true;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || (snapshot.data?.docs ?? []).isEmpty) {
            return const Center(
              child: Text('No comments yet.'),
            );
          }
          isLoading = false;
          return isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => CommentCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user.imgUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  String res = await FireStoreMethods().postComment(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.imgUrl,
                  );

                  _commentController.clear();
                  if (res == 'success') {
                    showSnackbar('Comment posted!', context);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: mobileBackgroundColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
