import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/posts.dart';

class FirestoreMethods {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String uid, String description, Uint8List file,
      String username, String profileImage) async {

    String res = 'Some error occured';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        postId:postId,
        uid: uid,
        username: username,
        description: description,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes:[],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    }
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes)async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    }
    catch(err){
      print(err.toString());
    }

  }

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async{
    String res = 'Some error occured';
    try{
      if(text.isNotEmpty){
        String commentId = Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'text':text,
          'uid':uid,
          'commentId':commentId,
          'datePublished':DateTime.now(),
    });
        res = 'success';
      }
      else{
        res = 'The text was empty';
      }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId)async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }
    catch(err){
      print(err.toString());
    }
  }
  Future<void> followUser(
      String uid,
      String followId
      ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }
}