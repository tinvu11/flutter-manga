class UserEntity {
  late String uid;
  late String email;
  late String name;

  UserEntity({required this.uid, required this.email, required this.name});

  UserEntity.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    name = json['fullName'];
  }
  @override
  String toString() {
    return 'UserEntity{email: $email, name: $name uid: $uid}';
  }
}
