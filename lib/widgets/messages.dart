import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_bubble.dart';

class Messages extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapShot) {
          if (chatSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              reverse: true,
              itemCount: chatSnapShot.data.docs.length,
              itemBuilder: (ctx, index) {
                return ChatBubble(
                    chatSnapShot.data.docs[index].data()['text'],
                    chatSnapShot.data.docs[index].data()['username'],
                    chatSnapShot.data.docs[index].data()['userId'] == user.uid,
                    chatSnapShot.data.docs[index]['imageUrl'],
                    key: ValueKey(chatSnapShot.data.docs[index].id));
              });
        });
  }
}
