import 'dart:developer';

import 'package:fb_revision/headers.dart';
import 'package:fb_revision/helpers/firestore_helper.dart';
import 'package:fb_revision/modals/student_modal.dart';
import 'package:fb_revision/modals/user_modal.dart';
import 'package:fb_revision/views/components/my_snack_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal user = ModalRoute.of(context)!.settings.arguments as UserModal;

    return Scaffold(
      appBar: AppBar(
        // leading: Container(),
        title: Text(user.displayName),
        actions: [
          IconButton(
            onPressed: () => FbAuthHelper.fbAuthHelper
                .signOut()
                .then(
                  (value) => Navigator.of(context).pushReplacementNamed(MyRoutes.loginPage),
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
          stream: FireStoreHelper.fireStoreHelper.getContacts(userId: user.userName),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? docs = snapShot.data;
              Map data = docs?.data() as Map<String, dynamic>;

              UserModal u = UserModal.fromMap(data: data);

              log("CONTACTS: ${u.contacts}");

              return ListView.builder(
                itemCount: u.contacts.length,
                itemBuilder: (ctx, index) {
                  return StreamBuilder(
                      stream: FireStoreHelper.fireStoreHelper.getUserStream(userName: u.contacts[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          DocumentSnapshot? docs2 = snapshot.data;

                          Map data2 = docs2!.data() as Map;

                          log("MAP: $data2");

                          UserModal other = UserModal.fromMap(data: data2);

                          Map pageData = {
                            'sender': user.userName,
                            'receiver': other,
                          };

                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  MyRoutes.chatPage,
                                  arguments: pageData,
                                );
                              },
                              title: Text(other.displayName),
                            ),
                          );
                        } else {
                          return const Card();
                        }
                      });
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_comment_outlined),
      ),
    );
  }
}
