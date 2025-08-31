import 'package:fluter_comic/data/models/auth/user.dart';

class EditUserRequest extends UserModel {
  final String? password;
  EditUserRequest({required super.email, required super.name, this.password});
}
