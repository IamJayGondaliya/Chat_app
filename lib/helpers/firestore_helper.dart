import 'dart:developer';

import 'package:fb_revision/headers.dart';
import 'package:fb_revision/modals/chat_modal.dart';
import 'package:fb_revision/modals/student_modal.dart';
import 'package:fb_revision/modals/user_modal.dart';

class FireStoreHelper {
  late FirebaseFirestore fireStore;
  FireStoreHelper._() {
    fireStore = FirebaseFirestore.instance;
    getUser();
  }

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  Logger logger = Logger();

  String studCollection = "Students";
  String studCounterCollection = "StudCounter";
  String idCount = "last_id";

  String userCollection = "Users";
  String allUserCollection = "allUsers";

  Future<UserModal> getUser({String userName = 'user_pioneer'}) async {
    DocumentSnapshot doc = await fireStore.collection(userCollection).doc(userName).get();
    Map data = doc.data() as Map<String, dynamic>;

    return UserModal.fromMap(data: data);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getContacts({required String userId}) {
    return fireStore.collection(userCollection).doc(userId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream({required String userName}) {
    return fireStore.collection(userCollection).doc(userName).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsersByEmail({required String email}) {
    return fireStore.collection(userCollection).where('email', isEqualTo: email).snapshots();
  }

  Future<void> registerUser({required UserModal user}) async {
    await fireStore.collection(userCollection).doc(user.userName).set(user.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllStudents() {
    return fireStore.collection(studCollection).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream({required String senderId, required String receiverId}) {
    return fireStore.collection(userCollection).doc(senderId).collection(receiverId).snapshots();
  }

  sendMessage({required String senderId, required String receiverId, required String message}) {
    DateTime d = DateTime.now();

    int id = d.millisecondsSinceEpoch;

    ChatModal sentChat = ChatModal(
      id,
      message,
      DateTime.fromMillisecondsSinceEpoch(id),
      'sent',
    );

    ChatModal receivedChat = ChatModal(
      id,
      message,
      DateTime.fromMillisecondsSinceEpoch(id),
      'received',
    );

    fireStore.collection(userCollection).doc(senderId).collection(receiverId).doc(sentChat.id.toString()).set(sentChat.toMap);
    fireStore
        .collection(userCollection)
        .doc(receiverId)
        .collection(senderId)
        .doc(receivedChat.id.toString())
        .set(receivedChat.toMap);
  }

  Future<int> _getLastId() async {
    DocumentSnapshot documentSnapshot = await fireStore.collection(studCounterCollection).doc("counter").get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    return data[idCount];
  }

  _increaseLastId() async {
    int id = await _getLastId();
    fireStore.collection(studCounterCollection).doc('counter').set(
      {idCount: ++id},
    );
  }

  addStudent({required Map<String, dynamic> stud}) async {
    stud.addAll(
      {
        'id': await _getLastId(),
      },
    );
    await fireStore.collection(studCollection).doc((await _getLastId()).toString()).set(stud).then(
          (value) => _increaseLastId(),
        );
  }

  Future<Map<String, dynamic>> deleteStudent({required String id}) async {
    Map<String, dynamic> data = {
      'status': false,
      'msg': "Not yet",
    };
    await fireStore.collection(studCollection).doc(id).delete().then((value) {
      data['status'] = true;
      data['msg'] = "$id Deleted !!";
    }).onError((error, stackTrace) {
      data['status'] = false;
      data['msg'] = "$id failed to delete !!";
    });
    return data;
  }

  Future<Map<String, dynamic>> updateStudent({required Student student}) async {
    Student s = student;

    Map<String, dynamic> data = {
      'status': false,
      'msg': "Not yet",
    };
    logger.i("DATA: ${student.id} - ${student.name} - ${student.age}");
    await fireStore.collection(studCollection).doc(student.id.toString()).update(student.toMap).then((value) {
      data['status'] = true;
      data['msg'] = "${student.id} Updated !!";
      logger.i("DONE !!");
    }).onError((error, stackTrace) {
      data['status'] = false;
      data['msg'] = "${student.id} failed to update !!";
      logger.e("ERROR: $error");
    });

    return data;
  }
}
