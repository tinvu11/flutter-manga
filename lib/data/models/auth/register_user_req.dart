import 'package:fluter_comic/data/models/auth/user.dart';

class RegisterUserRequest extends UserModel {
  String password;

  RegisterUserRequest({
    required super.email,
    required this.password,
    required super.name,
  });
}
