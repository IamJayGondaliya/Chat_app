import 'package:fb_revision/headers.dart';

class EmojiController extends ChangeNotifier {
  bool keyboardVisible = false;

  TextEditingController textEditingController = TextEditingController();

  void changeKeyboardVisibility() {
    keyboardVisible = !keyboardVisible;
    notifyListeners();
  }

  addEmojiToText({required String emoji}) {
    textEditingController.text += emoji;
    notifyListeners();
  }

  void closeKeyboard() {
    keyboardVisible = false;
    notifyListeners();
  }
}
