import 'package:flutter/material.dart';

import 'main_wrapper.dart';
import 'viewmodel/login_viewmodel.dart';

const Color _primaryOrange = Color(0xFFFF8C00);
const Color _successGreen = Color(0xFF4CAF50);
const Color _neutralGray = Color(0xFF9E9E9E);
const Color _backgroundColor = Color(0xFFFFF6EE);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel viewModel = LoginViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  Future<void> _loginWithEmail() async {
    final success = await viewModel.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainWrapper()),
      );
    } else if (viewModel.errorMessage != null) {
      _showError(viewModel.errorMessage!);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback? onPressed,
    BorderSide? border,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: foregroundColor),
      label: Text(
        label,
        style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        side: border,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = viewModel.isLoading;

    return Scaffold(
      backgroundColor: _backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Giriş / Kayıt',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Etkinlikleri keşfetmek için hızlı ve güvenli giriş yapın.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 22,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 140, 0, 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.event, color: _primaryOrange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hoş geldiniz! Etkinliklerinizi şimdi yönetin.',
                              style: TextStyle(
                                color: _primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: _neutralGray),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock, color: _neutralGray),
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _loginWithEmail,
                      icon: const Icon(Icons.login),
                      label: const Text('Email ve Şifre ile Giriş Yap'),
                    ),
                    const SizedBox(height: 16),
                    _buildSocialButton(
                      label: 'Google ile Giriş Yap',
                      icon: Icons.email,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      border: BorderSide(color: Colors.grey.shade300),
                      onPressed: isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              final success = await viewModel.loginWithGoogle();
                              if (!mounted) return;
                              if (success) {
                                navigator.pushReplacement(
                                  MaterialPageRoute(builder: (_) => const MainWrapper()),
                                );
                              } else if (viewModel.errorMessage != null) {
                                messenger.showSnackBar(
                                  SnackBar(content: Text(viewModel.errorMessage!)),
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      label: 'Facebook ile Giriş Yap',
                      icon: Icons.facebook,
                      backgroundColor: const Color(0xFF1877F2),
                      foregroundColor: Colors.white,
                      onPressed: isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              final success = await viewModel.loginWithFacebook();
                              if (!mounted) return;
                              if (success) {
                                navigator.pushReplacement(
                                  MaterialPageRoute(builder: (_) => const MainWrapper()),
                                );
                              } else if (viewModel.errorMessage != null) {
                                messenger.showSnackBar(
                                  SnackBar(content: Text(viewModel.errorMessage!)),
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      label: 'Misafir Girişi',
                      icon: Icons.person,
                      backgroundColor: _successGreen,
                      foregroundColor: Colors.white,
                      onPressed: isLoading
                          ? null
                          : () async {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              final success = await viewModel.loginAsGuest();
                              if (!mounted) return;
                              if (success) {
                                navigator.pushReplacement(
                                  MaterialPageRoute(builder: (_) => const MainWrapper()),
                                );
                              } else if (viewModel.errorMessage != null) {
                                messenger.showSnackBar(
                                  SnackBar(content: Text(viewModel.errorMessage!)),
                                );
                              }
                            },
                    ),
                    if (isLoading) ...[
                      const SizedBox(height: 24),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    _showError('Kayıt sayfası henüz kullanılabilir değil.');
                  },
                  child: const Text(
                    'Hesabınız Yok Mu? Kayıt Olun',
                    style: TextStyle(
                      color: _primaryOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
