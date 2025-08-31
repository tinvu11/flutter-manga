part of 'authentication_bloc.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.unInitialized() = _UnInitialized;
  const factory AuthenticationState.authenticated(UserEntity user) =
      _Authenticated;
  const factory AuthenticationState.unauthenticated() = _Unauthenticated;
}
