import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/ui/login/login_screen.dart';

/// Utility class để handle authentication actions
class AuthUtils {
  /// Private constructor to prevent instantiation
  AuthUtils._();

  /// Execute action only if user is authenticated
  static void executeWithAuth(
    BuildContext context,
    VoidCallback action, {
    VoidCallback? onUnauthorized,
  }) {
    final authState = context.read<AuthenticationBloc>().state;
    authState.maybeMap(
      authenticated: (_) => action(),
      orElse: () {
        if (onUnauthorized != null) {
          onUnauthorized();
        } else {
          LoginScreen.show(context);
        }
      },
    );
  }

  /// Get current user info
  static ({String? uid, String? userName}) getCurrentUser(
    BuildContext context,
  ) {
    final authState = context.read<AuthenticationBloc>().state;
    return authState.maybeMap(
      authenticated: (value) =>
          (uid: value.user.uid, userName: value.user.name),
      orElse: () => (uid: null, userName: null),
    );
  }

  /// Check if user is authenticated
  static bool isAuthenticated(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    return authState.maybeMap(authenticated: (_) => true, orElse: () => false);
  }

  /// Get user ID safely
  static String? getUserId(BuildContext context) {
    return getCurrentUser(context).uid;
  }

  /// Get user name safely
  static String? getUserName(BuildContext context) {
    return getCurrentUser(context).userName;
  }

  /// Watch authentication state changes
  static Widget buildWithAuthState(
    BuildContext context, {
    required Widget Function(String uid, String userName) authenticatedBuilder,
    required Widget Function() unauthenticatedBuilder,
  }) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.maybeMap(
          authenticated: (value) =>
              authenticatedBuilder(value.user.uid, value.user.name),
          orElse: unauthenticatedBuilder,
        );
      },
    );
  }
}
