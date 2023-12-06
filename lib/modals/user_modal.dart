class UserModal {
  String userName;
  String email;
  String displayName;
  String password;
  int contact;
  List contacts;

  UserModal(
    this.userName,
    this.email,
    this.displayName,
    this.password,
    this.contact,
    this.contacts,
  );

  UserModal.dummyData({
    this.userName = "Dummy",
    this.displayName = "Demo",
    this.email = "demo",
    this.contacts = const [''],
    this.contact = 0,
    this.password = "ddd",
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      data['user_name'],
      data['email'],
      data['display_name'],
      data['password'],
      data['contact'],
      data['contacts'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'email': email,
      'display_name': displayName,
      'password': password,
      'contact': contact,
      'contacts': contacts,
    };
  }
}
