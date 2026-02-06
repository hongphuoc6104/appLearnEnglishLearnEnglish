import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../core/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() { _nameController.dispose(); _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) context.go('/home');
        else if (state is AuthError) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    const Icon(Icons.school, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text('Create Account', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),
                    TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Display Name', prefixIcon: Icon(Icons.person_outlined)), validator: (v) => v != null && v.length >= 2 ? null : 'Min 2 characters'),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)), validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email'),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outlined)), validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters'),
                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading ? null : () { if (_formKey.currentState!.validate()) context.read<AuthBloc>().add(RegisterRequested(email: _emailController.text.trim(), password: _passwordController.text, displayName: _nameController.text.trim())); },
                        child: state is AuthLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Register'),
                      );
                    }),
                    const SizedBox(height: 16),
                    TextButton(onPressed: () => context.go('/login'), child: const Text('Already have an account? Login')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
