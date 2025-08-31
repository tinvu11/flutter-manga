part of 'authentication_bloc.dart';

@freezed
abstract class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.appStarted() = _AppStarted;
  const factory AuthenticationEvent.signedOut() = _SignedOut;
  const factory AuthenticationEvent.signedIn() = _SignedIn;
}
