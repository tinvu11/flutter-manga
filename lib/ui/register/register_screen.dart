import 'dart:ui';
import 'package:fluter_comic/ui/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

  // Static method để show modal
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(create: (context) => RegisterBloc(), child: const RegisterScreen()),
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final typeTextField = ['name', 'email', 'password', 'confirmPassword'];

  @override
  void initState() {
    print('RegisterScreenState initState');

    super.initState();
    _email.addListener(() {
      _onEmailChanged();
    });
    _name.addListener(() {
      _onNameChanged();
    });
    _password.addListener(() {
      _onPasswordChanged();
    });
    _confirmPassword.addListener(() {
      _onConfirmPasswordChanged();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    print('chay _onEmailChanged');
    context.read<RegisterBloc>().add(RegisterEvent.emailChanged(_email.text));
  }

  void _onNameChanged() {
    context.read<RegisterBloc>().add(RegisterEvent.nameChanged(_name.text));
  }

  void _onPasswordChanged() {
    context.read<RegisterBloc>().add(RegisterEvent.passwordChanged(_password.text));
  }

  void _onConfirmPasswordChanged() {
    context.read<RegisterBloc>().add(RegisterEvent.confirmPasswordChanged(_confirmPassword.text, _password.text));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () => null,
              failure: (message) {
                print('Đăng ký thất bại: $message');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
              },
              success: () {
                print('Đăng ký thành công');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));
              },
            );
          },
          builder: (context, state) {
            final colorScheme = Theme.of(context).colorScheme;
            return Container(
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
                        child: Text('Đăng ký', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nếu bạn đã có tài khoản, ', style: textTheme.titleSmall),
                          Text('hãy đăng nhập ngay!', style: textTheme.titleSmall?.copyWith(color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(context, 'Tên hiển thị', typeTextField[0], _name, TextInputType.name),
                      _buildTextFormField(context, 'Email', typeTextField[1], _email, TextInputType.emailAddress),
                      _buildTextFormField(
                        context,
                        'Mật khẩu',
                        typeTextField[2],
                        _password,
                        TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      _buildTextFormField(
                        context,
                        'Nhập lại mật khẩu',
                        typeTextField[3],
                        _confirmPassword,
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
                            context.read<RegisterBloc>().add(
                              RegisterEvent.registerSubmitted(
                                email: _email.text,
                                name: _name.text,
                                password: _password.text,
                                confirmPassword: _confirmPassword.text,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: colorScheme.primary.withOpacity(0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Đăng Ký',
                            style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Nút Google
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<RegisterBloc>().add(RegisterEvent.registerWithGooglePressed());
                          },

                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.secondary, width: 2.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: Icon(Icons.g_mobiledata, color: Colors.deepPurple, size: 20),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Đăng nhập với Google',
                                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextFormField(
    BuildContext context,
    String label,
    String type,
    TextEditingController controller,
    TextInputType keyboardType, {
    bool obscureText = false,
  }) {
    final state = context.read<RegisterBloc>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },

        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          errorText: state.maybeWhen(
            orElse: () => null,
            failure: (message) => message,
            success: () => null,
            initial: (isNameValid, isEmailValid, isPasswordValid, isConfirmPasswordValid) {
              switch (type) {
                case 'name':
                  return isNameValid ? null : 'Tên không hợp lệ';
                case 'email':
                  return isEmailValid ? null : 'Email không hợp lệ';
                case 'password':
                  return isPasswordValid ? null : 'Mật khẩu không hợp lệ';
                case 'confirmPassword':
                  return isConfirmPasswordValid ? null : 'Mật khẩu xác nhận không khớp';
                default:
                  return null;
              }
            },
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
