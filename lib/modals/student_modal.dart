class Student {
  int id;
  String name;
  int age;

  Student(
    this.id,
    this.name,
    this.age,
  );

  Student.getInstance({
    this.id = 1,
    this.name = "No Name",
    this.age = 0,
  });

  factory Student.fromMap({required Map data}) {
    return Student(data['id'], data['name'], data['age']);
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
