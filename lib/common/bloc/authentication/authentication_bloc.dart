import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/models/user_firebase.dart';
import 'package:fluter_comic/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'authentication_bloc.freezed.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.unInitialized()) {
    on<AuthenticationEvent>((event, emit) async {
      await event.map(
        appStarted: (e) => _onAppStarted(e, emit),
        signedOut: (e) => _onSignedOut(e, emit),
        signedIn: (e) => _onSignedIn(e, emit),
      );
    });
  }

  Future<void> _onAppStarted(
    _AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await DI().sl<AuthRepository>().getUser();
      user.fold((failure) {
        emit(AuthenticationState.unauthenticated());
      }, (userEntity) => emit(AuthenticationState.authenticated(userEntity)));
    } catch (e) {
      return emit(AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onSignedOut(
    _SignedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await DI().sl<AuthRepository>().signOut();
      emit(const AuthenticationState.unauthenticated());
    } catch (e) {
      emit(AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onSignedIn(
    _SignedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await DI().sl<AuthRepository>().isSignedIn();
      if (user) {
        final userEntity = await DI().sl<AuthRepository>().getUser();
        userEntity.fold((failure) {
          emit(AuthenticationState.unauthenticated());
        }, (userModel) => emit(AuthenticationState.authenticated(userModel)));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    } catch (e) {
      emit(AuthenticationState.unauthenticated());
    }
  }
}
