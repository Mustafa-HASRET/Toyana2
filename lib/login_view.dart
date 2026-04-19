import 'package:flutter/material.dart';

import 'common_widget/auth_action_button.dart';
import 'main_wrapper.dart';
import 'viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

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

  Future<void> _loginAsGuest() async {
    final success = await viewModel.loginAsGuest();
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

  @override
  Widget build(BuildContext context) {
    final isLoading = viewModel.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'ARIK',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 64),
              const Center(
                child: Text(
                  'Oturum Açın',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      icon: Icons.lock,
                      label: 'Gmail ile Giriş Yap',
                      onPressed: isLoading
                          ? null
                          : () => _showError('Gmail girişi henüz desteklenmiyor.'),
                    ),
                    const SizedBox(height: 16),
                    AuthActionButton(
                      backgroundColor: const Color(0xFF1877F2),
                      foregroundColor: Colors.white,
                      icon: Icons.facebook,
                      label: 'Facebook ile Giriş Yap',
                      onPressed: isLoading
                          ? null
                          : () => _showError('Facebook girişi henüz desteklenmiyor.'),
                    ),
                    const SizedBox(height: 16),
                    AuthActionButton(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.email,
                      label: 'Email ve Şifre ile Giriş Yap',
                      onPressed: isLoading ? null : _loginWithEmail,
                    ),
                    const SizedBox(height: 16),
                    AuthActionButton(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.group,
                      label: 'Misafir Girişi',
                      onPressed: isLoading ? null : _loginAsGuest,
                    ),
                    if (isLoading) ...[
                      const SizedBox(height: 24),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
