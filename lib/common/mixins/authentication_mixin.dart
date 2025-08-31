import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/ui/login/login_screen.dart';

/// Mixin để xử lý authentication logic một cách reusable
mixin AuthenticationMixin<T extends StatefulWidget> on State<T> {
  /// Execute action only if user is authenticated, otherwise show login
  void executeWithAuth(VoidCallback action) {
    final authState = context.read<AuthenticationBloc>().state;
    authState.maybeMap(
      authenticated: (_) => action(),
      orElse: () => LoginScreen.show(context),
    );
  }

  /// Get current user info safely
  ({String? uid, String? userName}) getCurrentUser() {
    final authState = context.read<AuthenticationBloc>().state;
    return authState.maybeMap(
      authenticated: (value) =>
          (uid: value.user.uid, userName: value.user.name),
      orElse: () => (uid: null, userName: null),
    );
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    final authState = context.read<AuthenticationBloc>().state;
    return authState.maybeMap(authenticated: (_) => true, orElse: () => false);
  }

  /// Get user ID or null
  String? get currentUserId {
    return getCurrentUser().uid;
  }

  /// Get user name or null
  String? get currentUserName {
    return getCurrentUser().userName;
  }
}

/// Extension method cho BuildContext để access auth state dễ dàng hơn
extension AuthenticationContext on BuildContext {
  /// Get current user info from context
  ({String? uid, String? userName}) getCurrentUser() {
    final authState = read<AuthenticationBloc>().state;
    return authState.maybeMap(
      authenticated: (value) =>
          (uid: value.user.uid, userName: value.user.name),
      orElse: () => (uid: null, userName: null),
    );
  }

  /// Check if user is authenticated from context
  bool get isAuthenticated {
    final authState = read<AuthenticationBloc>().state;
    return authState.maybeMap(authenticated: (_) => true, orElse: () => false);
  }

  /// Execute action with auth check from context
  void executeWithAuth(VoidCallback action) {
    final authState = read<AuthenticationBloc>().state;
    authState.maybeMap(
      authenticated: (_) => action(),
      orElse: () => LoginScreen.show(this),
    );
  }
}
