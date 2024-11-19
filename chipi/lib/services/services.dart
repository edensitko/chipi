import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // fp,ur jzur 
                const TextWidget(
                  label: 'פרטי צוות הפיתוח',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                // Close button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
                  // exit button  to the  screen before 
                  IconButton(onPressed: 
                  () => Navigator.of(context).pushReplacementNamed('/splash'),
                  icon: const Icon(Icons.exit_to_app)),


              ],
            ),
          );
        });
  }
}
