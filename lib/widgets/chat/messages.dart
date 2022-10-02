import 'package:chat_app_2/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.data == null) {
          return Center(
            child: Text('No messages yet...'),
          );
        }

        final chatDocs = chatSnapshots.data!.docs;
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, i) => MessageBubble(
                chatDocs[i]['text'],
                chatDocs[i]['username'],
                chatDocs[i]['userImage'],
                chatDocs[i]['uid'] == FirebaseAuth.instance.currentUser!.uid,
                key: ValueKey(chatDocs[i].id)),
          );
        }
      },
    );
  }
}
