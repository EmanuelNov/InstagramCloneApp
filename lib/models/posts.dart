import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String uid;
  final String username;
  final String description;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post({
    required this.postId,
    required this.uid,
    required this.username,
    required this.description,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'uid': uid,
    'username': username,
    'description' : description,
    'datePublished' : datePublished,
    'postUrl': postUrl,
    'profileImage' : profileImage,
    'likes' : likes,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data()as Map<String, dynamic>;
    return Post(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      description: snapshot['description'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }

}
