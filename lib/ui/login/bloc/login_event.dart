part of 'login_bloc.dart';

@freezed
abstract class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailChanged(String email) = _EmailChanged;
  const factory LoginEvent.passwordChanged(String password) = _PasswordChanged;
  const factory LoginEvent.loginSubmitted({
    required String email,
    required String password,
  }) = _LoginSubmitted;
  const factory LoginEvent.loginWithGooglePressed() = _LoginWithGooglePressed;
}
