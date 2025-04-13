import 'package:flutter/material.dart';
import 'package:flutter_app/screens/account_screen.dart';
import 'package:flutter_app/screens/chat_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/wallet_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/auth_cubit.dart';
import 'generated/l10n.dart';


class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    final List<Widget> _screens = [
      const HomeScreen(),
      const ChatScreen(),
      const WalletScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: S.of(context).homeTitle),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: S.of(context).chatTitle),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: S.of(context).walletTitle),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: S.of(context).accountTitle),
        ],
      ),
    );
  }
}

