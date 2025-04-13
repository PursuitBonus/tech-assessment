import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {}

class AuthLoggedOut extends AuthState {}

class AuthLoginError extends AuthState {
  final String message;
  AuthLoginError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  static const _key = 'is_logged_in';

  AuthCubit() : super(AuthInitial()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_key) ?? false;
    emit(isLoggedIn ? AuthLoggedIn() : AuthLoggedOut());
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(milliseconds: 100)); // simulation whatever

    if (username == 'user') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
      emit(AuthLoggedIn());
    } else {
      emit(AuthLoginError('Invalid login or password'));
      emit(AuthLoggedOut());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    emit(AuthLoggedOut());
  }
}