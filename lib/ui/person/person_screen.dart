import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/ui/login/login_screen.dart';
import 'package:fluter_comic/ui/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.maybeMap(
          unInitialized: (_) => Center(child: CircularProgressIndicator()),
          orElse: () {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Scaffold(
                appBar: AppBar(toolbarHeight: 100, titleSpacing: 0, title: _buildUserSection(state)),
                body: _buildBodyContent(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserSection(AuthenticationState state) {
    return state.maybeWhen(
      authenticated: (user) => _buildAuthenticatedUserSection(user),
      unauthenticated: () => _buildUnauthenticatedUserSection(),
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildAuthenticatedUserSection(dynamic user) {
    return Column(
      children: [
        _buildUserInfo(
          name: user.name,
          email: user.email,
          avatarUrl: 'https://i.pinimg.com/736x/ff/06/ea/ff06eab08bb5dc6bfad42ccc943b3e3b.jpg',
        ),
        const SizedBox(height: 10),
        _buildAuthenticatedActionButtons(),
      ],
    );
  }

  Widget _buildUnauthenticatedUserSection() {
    return Column(
      children: [
        _buildUserInfo(
          name: 'Tài khoản',
          avatarUrl: 'https://i.pinimg.com/736x/ff/06/ea/ff06eab08bb5dc6bfad42ccc943b3e3b.jpg',
        ),
        const SizedBox(height: 10),
        _buildUnauthenticatedActionButtons(),
      ],
    );
  }

  Widget _buildUserInfo({required String name, String? email, required String avatarUrl}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(avatarUrl),
          onBackgroundImageError: (error, stackTrace) {
            // Handle image loading error
          },
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              if (email != null) ...[
                const SizedBox(height: 2),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedActionButtons() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildActionButton(
            title: 'Quản lý tài khoản',
            onTap: _handleAccountManagement,
            color: colorScheme.primary,
            icon: Icons.manage_accounts,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            title: 'Đăng xuất',
            onTap: () {
              context.read<AuthenticationBloc>().add(const AuthenticationEvent.signedOut());
            },
            color: Colors.red[600]!,
            icon: Icons.logout,
          ),
        ),
      ],
    );
  }

  Widget _buildUnauthenticatedActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Đăng nhập',
            onTap: _handleSignIn,
            color: Colors.blue[600]!,
            icon: Icons.login,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            title: 'Đăng ký',
            onTap: _handleSignUp,
            color: Colors.green[600]!,
            icon: Icons.person_add,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required VoidCallback onTap,
    required Color color,
    IconData? icon,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, color: Colors.white, size: 18), const SizedBox(width: 6)],
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAccountManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quản lý tài khoản'),
        content: const Text('Chức năng đang được phát triển'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
      ),
    );
  }

  void _handleSignIn() {
    LoginScreen.show(context);
  }

  void _handleSignUp() {
    RegisterScreen.show(context);
  }

  Widget _buildBodyContent() {
    return Column(children: [const SizedBox(height: 16), _buildSettingsSection()]);
  }

  Widget _buildSettingsSection() {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.settings,
            title: 'Cài đặt',
            onTap: () {
              // Navigate to settings
            },
          ),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: 'Trợ giúp',
            onTap: () {
              // Navigate to help
            },
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'Về chúng tôi',
            onTap: () {
              // Navigate to about
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
      onTap: onTap,
    );
  }
}
