import 'package:fb_revision/controllers/emoji_controller.dart';
import 'package:fb_revision/views/screens/chat_page.dart';
import 'package:fb_revision/views/screens/confirmation_page.dart';
import 'package:fb_revision/views/screens/home_page.dart';
import 'package:provider/provider.dart';

import 'headers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => EmojiController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (ctx, _, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        routes: {
          MyRoutes.loginPage: (context) => const LoginPage(),
          MyRoutes.homePage: (context) => const HomePage(),
          MyRoutes.confirmationPage: (context) => const ConfirmationPage(),
          MyRoutes.chatPage: (context) => const ChatPage(),
        },
      ),
    );
  }
}
