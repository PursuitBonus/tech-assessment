import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit.dart';

class LoginInlineView extends StatelessWidget {
  const LoginInlineView({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FlutterLogo(size: 64),
                const SizedBox(height: 24),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Login'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final login = usernameController.text.trim();
                    final password = passwordController.text.trim();
                    context.read<AuthCubit>().login(login, password);
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 24),
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
