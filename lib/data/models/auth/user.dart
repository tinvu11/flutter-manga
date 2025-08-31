class UserModel {
  String? email;
  String? name;

  UserModel({this.email, this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
  }
  @override
  String toString() {
    return 'UserModel{email: $email, name: $name}';
  }
}

// extension UserModelX on UserModel {
//   UserEntity toEntity() {
//     return UserEntity(email: email ?? '', name: name ?? '');
//   }
// }
