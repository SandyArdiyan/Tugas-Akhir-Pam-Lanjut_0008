import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginMode = true; // true = Layar Login, false = Layar Register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLoginMode ? 'Login PustakaSiswa' : 'Daftar Akun Baru')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home'); // Masuk jika berhasil auth
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (isLoginMode) {
                            context.read<AuthBloc>().add(AuthLoginRequested(_emailController.text, _passwordController.text));
                          } else {
                            context.read<AuthBloc>().add(AuthRegisterRequested(_emailController.text, _passwordController.text));
                          }
                        },
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        child: Text(isLoginMode ? 'MASUK' : 'DAFTAR & MASUK'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginMode = !isLoginMode; // Ganti mode
                          });
                        },
                        child: Text(isLoginMode ? 'Belum punya akun? Daftar di sini' : 'Sudah punya akun? Login di sini'),
                      )
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}