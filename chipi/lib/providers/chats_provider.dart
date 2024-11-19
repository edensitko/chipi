import 'package:chipi/providers/userprovider.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  final userProvider = UserProvider(); // Define userProvider here
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
                  userProvider: userProvider, // Pass userProvider here

      ));
    } else {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      userProvider: userProvider, // Pass userProvider here

      ));
   
    }
    notifyListeners();
  }
}
