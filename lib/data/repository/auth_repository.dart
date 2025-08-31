import 'package:dartz/dartz.dart';
import 'package:fluter_comic/data/data_sources/auth/auth_service.dart';
import 'package:fluter_comic/data/models/auth/edit_user_req.dart';
import 'package:fluter_comic/data/models/auth/login_user_req.dart';
import 'package:fluter_comic/data/models/auth/register_user_req.dart';
import 'package:fluter_comic/data/models/user_firebase.dart';

abstract class AuthRepository {
  Future<Either<String, String>> signup(RegisterUserRequest createUserRequest);
  Future<Either<String, String>> editUser(EditUserRequest editUserRequest);
  Future<Either<String, String>> signin(LoginUserReq signinUserRequest);
  Future<Either<String, String>> signInWithGoogle();
  Future<Either<String, UserEntity>> getUser();
  Future<Either<String, String>> signOut();
  Future<bool> isSignedIn();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  AuthRepositoryImpl({required AuthService authService})
    : _authService = authService;

  @override
  Future<Either<String, String>> signup(RegisterUserRequest createUserRequest) {
    return _authService.signup(createUserRequest);
  }

  @override
  Future<Either<String, String>> editUser(EditUserRequest editUserRequest) {
    return _authService.editUser(editUserRequest);
  }

  @override
  Future<Either<String, String>> signin(LoginUserReq signinUserRequest) {
    return _authService.signin(signinUserRequest);
  }

  @override
  Future<Either<String, String>> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }

  @override
  Future<Either<String, UserEntity>> getUser() {
    return _authService.getUser();
  }

  @override
  Future<Either<String, String>> signOut() {
    return _authService.signOut();
  }

  @override
  Future<bool> isSignedIn() {
    return _authService.isSignedIn();
  }
}
