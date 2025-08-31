import 'dart:async';

import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/common/helper/is_valid.dart';
import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/models/auth/login_user_req.dart';
import 'package:fluter_comic/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_bloc.freezed.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginEvent>((event, emit) async {
      await event.map(
        emailChanged: (e) => _onEmailChanged(e, emit),
        passwordChanged: (e) => _onPasswordChanged(e, emit),
        loginSubmitted: (e) => _onLoginSubmitted(e, emit),
        loginWithGooglePressed: (e) => _onLoginWithGooglePressed(e, emit),
      );
    });
  }
  Future<void> _onEmailChanged(
    _EmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    final isValid = Validators.isValidEmail(event.email);
    state.maybeMap(
      orElse: () {},
      initial: (currentState) {
        emit(currentState.copyWith(isEmailValid: isValid));
      },
    );
  }

  Future<void> _onPasswordChanged(
    _PasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final isValid = Validators.isValidPassword(event.password);

    state.maybeMap(
      orElse: () {},
      initial: (currentState) {
        emit(currentState.copyWith(isPasswordValid: isValid));
      },
    );
  }

  Future<void> _onLoginSubmitted(
    _LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final isSignedIn = await DI().sl<AuthRepository>().signin(
        LoginUserReq(email: event.email, password: event.password),
      );
      isSignedIn.fold((failure) => emit(LoginState.failure(message: failure)), (
        success,
      ) {
        emit(const LoginState.success());
        DI().sl<AuthenticationBloc>().add(const AuthenticationEvent.signedIn());
      });
    } catch (e) {
      return emit(LoginState.failure(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onLoginWithGooglePressed(
    _LoginWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final result = await DI().sl<AuthRepository>().signInWithGoogle();
      result.fold(
        (failure) => emit(LoginState.failure(message: failure)),
        (success) => emit(const LoginState.success()),
      );
    } catch (e) {
      return emit(
        LoginState.failure(message: 'Google login failed: ${e.toString()}'),
      );
    }
  }
}
