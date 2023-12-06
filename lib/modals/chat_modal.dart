class ChatModal {
  int id;
  String message;
  DateTime time;
  String type;

  ChatModal(this.id, this.message, this.time, this.type);

  factory ChatModal.fromMap({required Map data}) {
    DateTime t = DateTime.fromMillisecondsSinceEpoch(data['id']);

    return ChatModal(data['id'], data['message'], t, data['type']);
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'message': message,
      'time': time.millisecondsSinceEpoch,
      'type': type,
    };
  }
}
