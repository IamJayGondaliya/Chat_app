import 'package:fb_revision/headers.dart';
import 'package:fb_revision/modals/user_modal.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../helpers/firestore_helper.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    User userData = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmation Page"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => FbAuthHelper.fbAuthHelper
                .signOut()
                .then(
                  (value) => Navigator.of(context).pop(),
                )
                .onError(
                  (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("ERROR: $error"),
                    ),
                  ),
                ),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.fetchUsersByEmail(email: userData.email ?? ""),
          builder: (ctx, snapShot) {
            List<QueryDocumentSnapshot> allData = snapShot.data?.docs ?? [];

            List<UserModal> allUsers = allData.map((e) => UserModal.fromMap(data: e.data() as Map<String, dynamic>)).toList();

            return Column(
              children: [
                Expanded(
                  child: Skeletonizer(
                    enabled: allUsers.isEmpty,
                    child: ListView.builder(
                      itemCount: allUsers.isEmpty ? 2 : allUsers.length,
                      itemBuilder: (context, index) {
                        UserModal u = allUsers.isEmpty ? UserModal.dummyData() : allUsers[index];
                        return Card(
                          child: ListTile(
                            title: Text(u.displayName),
                            subtitle: Text(u.userName),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                  MyRoutes.homePage,
                                  arguments: u,
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    UserModal user = UserModal.dummyData();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Add account"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (val) {
                                user.displayName = val;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Display Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              onChanged: (val) {
                                user.userName = val;
                              },
                              decoration: const InputDecoration(
                                labelText: 'User Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              onChanged: (val) {
                                user.password = val;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              onChanged: (val) {
                                user.contact = int.parse(val);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Contact',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              user.email = userData.email ?? "";
                              user.contacts = [];

                              await FireStoreHelper.fireStoreHelper.registerUser(user: user);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add account"),
                ),
              ],
            );
            // if (snapShot.hasData) {
            //   return Column(
            //     children: snapShot.data!
            //         .map(
            //           (e) => ListTile(
            //             title: Text(e.displayName),
            //             subtitle: Text(e.userName),
            //           ),
            //         )
            //         .toList(),
            //   );
            // } else {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
          },
        ),
      ),
    );
  }
}
