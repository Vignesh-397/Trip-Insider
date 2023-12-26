import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final String destination;
  final String origin;
  final String homeStay;
  final String expd;
  final String travelMode;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.destination,
    required this.origin,
    required this.homeStay,
    required this.expd,
    required this.travelMode,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        'profImage': profImage,
        "postId": postId,
        "username": username,
        "description": description,
        "likes": likes,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'destination': destination,
        'origin': origin,
        'homeStay': homeStay,
        'expd': expd,
        'travelMode': travelMode,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        destination: snapshot['destination'],
        origin: snapshot['origin'],
        homeStay: snapshot['homeStay'],
        expd: snapshot['expd'],
        travelMode: snapshot['travelMode']);
  }
}
