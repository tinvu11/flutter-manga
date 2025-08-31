import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_comic/data/models/auth/edit_user_req.dart';
import 'package:fluter_comic/data/models/auth/login_user_req.dart';
import 'package:fluter_comic/data/models/auth/register_user_req.dart';
import 'package:fluter_comic/data/models/user_firebase.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<Either<String, String>> signup(RegisterUserRequest createUserRequest);
  Future<Either<String, String>> editUser(EditUserRequest editUserRequest);
  Future<Either<String, String>> signin(LoginUserReq signinUserRequest);
  Future<Either<String, String>> signInWithGoogle();
  Future<Either<String, UserEntity>> getUser();
  Future<Either<String, String>> signOut();
  Future<bool> isSignedIn();
}

class AuthServiceImpl extends AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthServiceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  // Hàm đăng ký tài khoản
  @override
  Future<Either<String, String>> signup(RegisterUserRequest createUserRequest) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: createUserRequest.email!,
        password: createUserRequest.password,
      );

      // Lưu thông tin người dùng vào Firestore
      String uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': createUserRequest.email,
        'fullName': createUserRequest.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Right('Signup was Successfull');
    } catch (e) {
      return Left('Error signup');
    }
  }

  // Hàm đăng nhập bằng email và mật khẩu
  @override
  Future<Either<String, String>> signin(LoginUserReq signinUserRequest) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: signinUserRequest.email,
        password: signinUserRequest.password,
      );
      return const Right('Login was Successfull');
    } catch (e) {
      return Left('Error signin');
    }
  }

  @override
  Future<Either<String, String>> editUser(EditUserRequest editInfo) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && editInfo.email == user.email && editInfo.password != null) {
        await user.updatePassword(editInfo.password!);
      }
      String uid = user!.uid;
      await _firestore.collection('users').doc(uid).update({'email': editInfo.email, 'fullName': editInfo.name});

      return const Right('User information updated successfully');
    } catch (e) {
      return Left('Error editing user');
    }
  }

  @override
  Future<Either<String, String>> signInWithGoogle() async {
    try {
      const scopes = [
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
        'openid',
      ];
      _googleSignIn.initialize(
        serverClientId: "333357329063-jtpj97lseomfg7mi05j3h2nnc42tus6j.apps.googleusercontent.com",
      );
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(scopeHint: scopes);
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final googleAuthorization = await googleUser.authorizationClient.authorizationForScopes(scopes);

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuthorization!.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return const Right('Google sign-in was successful');
    } catch (e) {
      return Left('Error signing in with Google: $e');
    }
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          UserEntity userEntity = UserEntity.fromJson(userDoc.data() as Map<String, dynamic>);
          return Right(userEntity);
        } else {
          return Left('User document does not exist');
        }
      } else {
        return Left('No user is currently signed in');
      }
    } catch (e) {
      return Left('Error fetching user data');
    }
  }

  @override
  Future<Either<String, String>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      return const Right('Sign out was successful');
    } catch (e) {
      return Left('Error signing out');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }
}
