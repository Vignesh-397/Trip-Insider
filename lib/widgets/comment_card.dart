import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripinsider/screens/profile_screen.dart';
import 'package:tripinsider/utils/colorsScheme.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isCommentLiked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(uid: widget.snap['uid']),
                ),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage(widget.snap['profilePic'].toString()),
            ),
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
                          text: widget.snap['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mobileBackgroundColor),
                        ),
                        TextSpan(
                            text: ' ${widget.snap['text']}',
                            style: const TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isCommentLiked = !isCommentLiked;
              });
            },
            icon: isCommentLiked
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16,
                  )
                : const Icon(
                    Icons.favorite,
                    size: 16,
                  ),
          )
        ],
      ),
    );
  }
}
