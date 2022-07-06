import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studhub/screens/chat/chatRoomBox.dart';

import '../../services/firestore.dart';
import '../../services/models.dart';
import '../../shared/loading.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userExtraData = Provider.of<UserInfo>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: FutureBuilder<List>(
        future: FirestoreService().getChatRooms(userExtraData.uid),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LoadingScreen());
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                (snapshot.data[index] != userExtraData.uid
                    ? ChatRoomBox(uid: snapshot.data[index])
                    : Container());
              },
            );
          }
        },
      ),
    );
  }
}
