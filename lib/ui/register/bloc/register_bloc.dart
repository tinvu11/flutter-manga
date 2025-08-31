import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/common/helper/is_valid.dart';
import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/models/auth/register_user_req.dart';
import 'package:fluter_comic/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_bloc.freezed.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState.initial()) {
    on<RegisterEvent>((event, emit) async {
      await event.map(
        emailChanged: (e) => _onEmailChanged(e, emit),
        nameChanged: (e) => _onNameChanged(e, emit),
        passwordChanged: (e) => _onPasswordChanged(e, emit),
        confirmPasswordChanged: (e) => _onConfirmPasswordChanged(e, emit),
        registerSubmitted: (e) => _onRegisterSubmitted(e, emit),
        registerWithGooglePressed: (e) => _onRegisterWithGooglePressed(e, emit),
      );
    });
  }
  Future<void> _onEmailChanged(_EmailChanged event, Emitter<RegisterState> emit) async {
    final isValid = Validators.isValidEmail(event.email);
    state.maybeMap(
      orElse: () {},
      initial: (currentState) {
        emit(currentState.copyWith(isEmailValid: isValid));
      },
    );
  }

  Future<void> _onNameChanged(_NameChanged event, Emitter<RegisterState> emit) async {
    final isValid = Validators.isValidName(event.name);
    state.maybeMap(
      orElse: () {},
      initial: (currentState) {
        emit(currentState.copyWith(isNameValid: isValid));
      },
    );
  }

  Future<void> _onPasswordChanged(_PasswordChanged event, Emitter<RegisterState> emit) async {
    final isValid = Validators.isValidPassword(event.password);
    state.maybeMap(
      orElse: () {},
      initial: (currentState) {
        emit(currentState.copyWith(isPasswordValid: isValid));
      },
    );
  }

  Future<void> _onConfirmPasswordChanged(_ConfirmPasswordChanged event, Emitter<RegisterState> emit) async {
    final isValid = Validators.isValidConfirmPassword(event.confirmPassword, event.password);
    state.maybeMap(
      orElse: () {},
      initial: (currentState) {
        emit(currentState.copyWith(isConfirmPasswordValid: isValid));
      },
    );
  }

  Future<void> _onRegisterSubmitted(_RegisterSubmitted event, Emitter<RegisterState> emit) async {
    try {
      if (!state.isFormValid) {
        return emit(RegisterState.failure(message: 'Please fill in all fields correctly.'));
      }
      final isRegistered = await DI().sl<AuthRepository>().signup(
        RegisterUserRequest(email: event.email, name: event.name, password: event.password),
      );
      isRegistered.fold((failure) => emit(RegisterState.failure(message: failure)), (success) {
        emit(const RegisterState.success());
        DI().sl<AuthenticationBloc>().add(const AuthenticationEvent.signedIn());
      });
    } catch (e) {
      emit(RegisterState.failure(message: 'Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterWithGooglePressed(_RegisterWithGooglePressed event, Emitter<RegisterState> emit) async {
    try {
      final result = await DI().sl<AuthRepository>().signInWithGoogle();
      result.fold((failure) {
        print('Google sign-in failed: $failure');
        emit(RegisterState.failure(message: failure));
      }, (success) => emit(const RegisterState.success()));
    } catch (e) {
      emit(RegisterState.failure(message: 'Google registration failed: ${e.toString()}'));
    }
  }
}
