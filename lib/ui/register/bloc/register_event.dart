part of 'register_bloc.dart';

@freezed
abstract class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.emailChanged(String email) = _EmailChanged;
  const factory RegisterEvent.nameChanged(String name) = _NameChanged;
  const factory RegisterEvent.passwordChanged(String password) =
      _PasswordChanged;
  const factory RegisterEvent.confirmPasswordChanged(
    String confirmPassword,
    String password,
  ) = _ConfirmPasswordChanged;
  const factory RegisterEvent.registerSubmitted({
    required String email,
    required String name,
    required String confirmPassword,
    required String password,
  }) = _RegisterSubmitted;
  const factory RegisterEvent.registerWithGooglePressed() =
      _RegisterWithGooglePressed;
}
