import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fb_revision/controllers/emoji_controller.dart';
import 'package:fb_revision/headers.dart';
import 'package:fb_revision/helpers/firestore_helper.dart';
import 'package:fb_revision/modals/chat_modal.dart';
import 'package:fb_revision/modals/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map pageData = ModalRoute.of(context)!.settings.arguments as Map;

    UserModal userModal = pageData['receiver'];

    return GestureDetector(
      onTap: () {
        Provider.of<EmojiController>(context, listen: false).closeKeyboard();
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(userModal.displayName),
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: FireStoreHelper.fireStoreHelper.getChatStream(senderId: pageData['sender'], receiverId: userModal.userName),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  QuerySnapshot snap = snapShot.data!;

                  List<QueryDocumentSnapshot> docs = snap.docs;

                  List<ChatModal> allChats = docs
                      .map(
                        (e) => ChatModal.fromMap(data: e.data() as Map),
                      )
                      .toList();

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: allChats.length,
                        itemBuilder: (ctx, index) {
                          ChatModal chat = allChats[index];

                          return Row(
                            mainAxisAlignment: allChats[index].type == 'sent' ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    allChats[index].type == 'sent' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(allChats[index].message),
                                    ),
                                  ),
                                  Text(
                                    "${chat.time.hour}:${chat.time.minute}:${chat.time.second}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Provider.of<EmojiController>(context, listen: false).changeKeyboardVisibility();
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        onTap: () {
                          Provider.of<EmojiController>(context, listen: false).closeKeyboard();
                        },
                        controller: Provider.of<EmojiController>(context).textEditingController,
                        textAlignVertical: const TextAlignVertical(
                          y: -1,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FireStoreHelper.fireStoreHelper.sendMessage(
                        senderId: pageData['sender'],
                        receiverId: userModal.userName,
                        message: Provider.of<EmojiController>(context, listen: false).textEditingController.text,
                      );
                      FocusManager.instance.primaryFocus!.unfocus();
                      Provider.of<EmojiController>(context, listen: false).closeKeyboard();
                      Provider.of<EmojiController>(context, listen: false).textEditingController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<EmojiController>(builder: (context, pro, _) {
              return Visibility(
                visible: pro.keyboardVisible,
                child: SizedBox(
                  height: 35.h,
                  width: 100.w,
                  child: EmojiPicker(
                    config: const Config(
                      categoryIcons: CategoryIcons(),
                      initCategory: Category.RECENT,
                    ),
                    onEmojiSelected: (category, emoji) {
                      log("EMOJI: ${emoji.emoji}");
                      pro.addEmojiToText(emoji: emoji.emoji);
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
