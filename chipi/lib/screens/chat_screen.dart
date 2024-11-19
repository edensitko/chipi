import 'dart:developer';

import 'package:chipi/constants/constants.dart';
import 'package:chipi/providers/chats_provider.dart';
import 'package:chipi/services/services.dart';
import 'package:chipi/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    
    return Directionality(  // Ensures the entire screen is in RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiLogo),
          ),
          title: const Text("צ'יפי", style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',  // Put your background image path here
                fit: BoxFit.cover,
              ),
            ),
            // Content Layer
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: chatProvider.getChatList.length,
                        itemBuilder: (context, index) {
                          return ChatWidget(
                            msg: chatProvider.getChatList[index].msg,
                            chatIndex: chatProvider.getChatList[index].chatIndex,
                            shouldAnimate: chatProvider.getChatList.length - 1 == index,
                          );
                        }),
                  ),
                  if (_isTyping) ...[
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                  const SizedBox(height: 15),
                  Material(
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.white),
                              controller: textEditingController,
                              onSubmitted: (value) async {
                                await sendMessageFCT(
                                    modelsProvider: modelsProvider,
                                    chatProvider: chatProvider);
                              },
                              textDirection: TextDirection.rtl,  // RTL text direction
                              decoration: const InputDecoration.collapsed(
                                  hintText: "רשום כאן",
                                  hintStyle: TextStyle(color: Color.fromARGB(255, 248, 246, 246))),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await sendMessageFCT(
                                    modelsProvider: modelsProvider,
                                    chatProvider: chatProvider);
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "אי אפשר לשלוח הודעות מרובות"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "בבקשה הקלד הודעה"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(label: error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
