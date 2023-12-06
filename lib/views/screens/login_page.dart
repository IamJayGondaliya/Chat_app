import 'package:fb_revision/headers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool validated = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: validated
                    ? () async {
                        await FbAuthHelper.fbAuthHelper.signInWithEmailPassword(
                          email: "demo@gmail.com",
                          password: "Demo@123",
                        );
                      }
                    : null,
                child: const Text("Sign in"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account yet?"),
                  TextButton(
                    onPressed: () async {
                      await FbAuthHelper.fbAuthHelper.registerUser(
                        email: "demo@gmail.com",
                        password: "Demo@123",
                      );
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: Divider(),
                  ),
                  Gap(20),
                  Text("OR"),
                  Gap(20),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  User? user = await FbAuthHelper.fbAuthHelper.signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed(
                    MyRoutes.confirmationPage,
                    arguments: user,
                  );
                },
                icon: Image.asset(
                  "assets/images/g-logo.png",
                  fit: BoxFit.contain,
                  height: 30,
                ),
                label: const Text("Sign with Google"),
              ),
              ElevatedButton(
                onPressed: () async {
                  User? user = await FbAuthHelper.fbAuthHelper.signInAnonymously();

                  Navigator.of(context).pushReplacementNamed(
                    MyRoutes.homePage,
                    arguments: user,
                  );
                },
                child: const Text("Guest login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
