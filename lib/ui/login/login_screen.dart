import 'dart:ui';
import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/ui/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  // Static method để show modal
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => LoginBloc(),
        child: const LoginScreen(),
      ),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.addListener(() {
      _onEmailChanged();
    });
    _password.addListener(() {
      _onPasswordChanged();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    context.read<LoginBloc>().add(LoginEvent.emailChanged(_email.text));
  }

  void _onPasswordChanged() {
    context.read<LoginBloc>().add(LoginEvent.passwordChanged(_password.text));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () => null,
          failure: (message) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message.toString())));
          },
          success: () {
            Navigator.pop(context);
            context.read<AuthenticationBloc>().add(
              const AuthenticationEvent.signedIn(),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đăng nhập thành công!')),
            );
          },
        );
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 28.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Đăng nhập',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nếu bạn chưa có tài khoản, ',
                            style: textTheme.titleSmall,
                          ),
                          Text(
                            'hãy đăng ký ngay!',
                            style: textTheme.titleSmall?.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        context,
                        'Email',
                        _email,
                        TextInputType.emailAddress,
                      ),
                      _buildTextFormField(
                        context,
                        'Mật khẩu',
                        _password,
                        TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      // Nút đăng nhập chính
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              LoginEvent.loginSubmitted(
                                email: _email.text,
                                password: _password.text,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            elevation: 2,
                            shadowColor: Colors.orange.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Nút quên mật khẩu
                      TextButton(
                        onPressed: () {
                          // Handle forgot password action
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Divider với text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: colorScheme.secondary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'hoặc',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Nút Google
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              const LoginEvent.loginWithGooglePressed(),
                            );
                          },

                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: colorScheme.secondary,
                              width: 2.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/ic_google.svg',
                                width: 24,
                                height: 24,
                                placeholderBuilder: (context) => Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.deepPurple,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Đăng nhập với Google',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFormField(
    BuildContext context,
    String label,
    TextEditingController controller,
    TextInputType keyboardType, {
    bool obscureText = false,
  }) {
    final state = context.watch<LoginBloc>().state;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },

        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          error: state.maybeMap(
            orElse: () => null,
            initial: (value) {
              if (keyboardType == TextInputType.emailAddress) {
                return value.isEmailValid
                    ? null
                    : const Text('Email không hợp lệ');
              } else {
                return value.isPasswordValid
                    ? null
                    : const Text('Mật khẩu không hợp lệ');
              }
            },
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          suffixIcon: obscureText
              ? Icon(Icons.visibility_off_outlined, color: Colors.grey[600])
              : (keyboardType == TextInputType.emailAddress
                    ? Icon(Icons.email_outlined, color: Colors.grey[600])
                    : null),
        ),
      ),
    );
  }
}
