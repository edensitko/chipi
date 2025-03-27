import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chipi/constants/api_consts.dart';
import 'package:chipi/models/chat_model.dart';
import 'package:chipi/models/models_model.dart';
import 'package:chipi/providers/userprovider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:http/http.dart' as http;
// import 'package:google_mlkit_language_id/google_mlkit_language_id.dart' as google_mlkit;

class ApiService {
  // Function to retrieve the user's name from SharedPreferences
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('name') ?? ''; // Default to 'ילד' if name is not set
    print("User name from SharedPreferences: $userName"); // Print the retrieved name
    return userName;
  }

  // Function to retrieve models from the API
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
      }
      print("Models retrieved: $temp");
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      print("Error retrieving models: $error");
      rethrow;
    }
  }

  // Function to send a message to ChatGPT with user's name from SharedPreferences
  static Future<List<ChatModel>> sendMessageGPT({
    required String message,
    required String modelId,
    required UserProvider userProvider,
  }) async {
    try {
      final userName = await getUserName(); // Load user's name from SharedPreferences
      print("Model ID: $modelId");
      print("Message to send: $message");

      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": "אתה מדבר עם ילד ששמו $userName דבר איתו בצורה הולמת כמו לילדים  קטנים, שמך הוא צ`יפי  : . $message",
              }
            ]
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print("Response from API: $jsonResponse");

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].isNotEmpty) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      print("Chat list created: $chatList");
      return chatList;
    } catch (error) {
      print("Error in sendMessageGPT: $error");
      rethrow;
    }
  }

  // List of inappropriate words for filtering
  final List<String> forbiddenWords = ["מילה1", "מילה2", "מילה3"];

  String filterInappropriateContent(String text) {
    for (var word in forbiddenWords) {
      text = text.replaceAll(word, '*' * word.length);
    }
    print("Filtered content: $text");
    return text;
  }

  // Function to detect language
  Future<bool> isHebrew(String text) async {
    // Temporarily returning true since we've commented out Google ML Kit
    // final languageId = google_mlkit.LanguageIdentifier(confidenceThreshold: 0.5);
    // final languageTag = await languageId.identifyLanguage(text);
    // print("Language detected: $languageTag");
    // return languageTag == 'he';
    return true;
  }

  // Function to fetch response from OpenAI API with a customized prompt
  Future<String> fetchResponse(String userInput) async {
    // Check if the language is Hebrew
    if (!await isHebrew(userInput)) {
      print("User input is not in Hebrew.");
      return "נא לשאול בעברית בלבד.";
    }

    final userName = await getUserName(); // Get user's name from SharedPreferences
    print("User name used in prompt: $userName"); // Print user name before using it in prompt

    // Customized prompt for children
    final prompt = """
אתה כרגע מדבר עם  ושמך הוא צ`יפי. ענה בצורה ברורה, פשוטה וללא מילים לא הולמות. התגובה צריכה להיות בעברית בלבד. היי שלום, $userName
$userInput
""";
    print("Prompt sent to API: $prompt , User Name: $userName");

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/completions"),
      headers: {
        "Authorization": "Bearer $API_KEY",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "prompt": prompt,
        "max_tokens": 100
      })
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Raw response data: $responseData");

      String resultText = responseData['choices'][0]['text'];
      print("Original result text: $resultText");

      // Filter inappropriate words
      resultText = filterInappropriateContent(resultText);

      // Check if the response is in Hebrew
      if (!await isHebrew(resultText)) {
        print("Response is not in Hebrew.");
        return "נא לשאול בעברית בלבד.";
      }

      print("Final response text: $resultText");
      return resultText;
    } else {
      print("Error status code from API: ${response.statusCode}");
      return "שגיאה בקריאת ה-API";
    }
  }
}
