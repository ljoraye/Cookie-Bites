import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'order_board_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Load this user's products before entering the app, so the Order
      // Entry Form's catalog is ready the moment Order Board appears. If
      // this fails (e.g. no products table rows yet), don't block login
      // over it — just start with an empty catalog.
      try {
        await ProductCatalog.loadFromSupabase();
      } catch (_) {
        // Non-fatal — Manage Products screen can still add the first ones.
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OrderBoardPage()),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Image.asset(
                  'assets/images/cookie_bites_logo.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: AppTextStyles.logoFontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      size: 20, color: Color(0xFFBDBDBD)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email';
                    }
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline,
                      size: 20, color: Color(0xFFBDBDBD)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFFBDBDBD),
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: navigate to a password recovery screen
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  label: 'LOGIN',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: Divider(color: Colors.white.withValues(alpha: 0.4))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child:
                          Text('or', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(
                        child: Divider(color: Colors.white.withValues(alpha: 0.4))),
                  ],
                ),
                const SizedBox(height: 24),
                _OAuthButton(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 20,
                    width: 20,
                  ),
                  label: 'Continue with Google',
                  backgroundColor: const Color(0xFFD8F26D),
                  textColor: Colors.black87,
                  onPressed: () {
                    // TODO: Supabase Google OAuth sign-in
                  },
                ),
                const SizedBox(height: 12),
                _OAuthButton(
                  icon: Image.asset(
                    'assets/images/apple_logo.png',
                    height: 20,
                    width: 20,
                  ),
                  label: 'Continue with Apple',
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    // TODO: Supabase Apple OAuth sign-in
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Need an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: navigate to the sign-up form
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OAuthButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _OAuthButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
