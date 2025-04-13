import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../cubits/user_cubit.dart';
import '../generated/l10n.dart';
import '../widgets/login_inline_view.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthLoggedIn) {
          return _buildLoggedIn(context);
        } else {
          return _buildLogin(context);
        }
      },
    );
  }

  Widget _buildLogin(BuildContext context) {
    return const LoginInlineView();
  }

  Widget _buildLoggedIn(BuildContext context) {
    final user = context.watch<UserCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: Icon(context.watch<ThemeCubit>().state == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(user.avatarAsset),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // TODO: open avatar edit
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                 Expanded(
                  child: Text(user.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldPlaceholder(label: 'Email', value: user.email),
                _FieldPlaceholder(label: 'Phone', value: user.phone),
                _FieldPlaceholder(label: 'Country', value: user.country),
                _FieldPlaceholder(label: 'Joined', value: user.joinedAt.toString()),
              ],
            ),
          ),

          const Divider(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Withdrawal Methods",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ...user.withdrawalAccounts.map((account) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.credit_card, size: 28),
                              const SizedBox(width: 12),
                              Expanded(child: Text(account)),
                              const Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement add card screen or dialog
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Card"),
                )
              ],
            ),
          ),


          const Spacer(),

          Center(
            child: TextButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.redAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

}

class _FieldPlaceholder extends StatelessWidget {
  final String label;
  final String value;

  const _FieldPlaceholder({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}