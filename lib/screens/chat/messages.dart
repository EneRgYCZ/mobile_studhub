import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:studhub/widgets/message_bubble_widget.dart';

import '../../services/firestore.dart';
import '../../services/models.dart';
import '../../shared/loading.dart';

class Messages extends StatelessWidget {
  final String roomId;
  const Messages({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserInfo>(context);
    List<Message> data = [];
    return StreamBuilder<List<Message>>(
      stream: FirestoreService().streamMessages(roomId),
      initialData: data,
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingScreen());
        } else if (chatSnapshot.hasData) {
          return ListView.builder(
            reverse: true,
            itemCount: chatSnapshot.data?.length,
            itemBuilder: (ctx, index) {
              return MessageBubbleWidget(
                message: chatSnapshot.data![index].text,
                isMe: chatSnapshot.data![index].uid == user.uid ? true : false,
              );
            },
          );
        } else {
          return const Text("An error has occured, please try again");
        }
      },
    );
  }
}
