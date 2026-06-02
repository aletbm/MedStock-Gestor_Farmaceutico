import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionProvider = StateNotifierProvider<SessionNotifier, bool?>((ref) {
  return SessionNotifier();
});

class SessionNotifier extends StateNotifier<bool?> {
  SessionNotifier() : super(null) {
    //print('SessionNotifier creado');
    _checkSession();
  }

  Future<void> _checkSession() async {
    //print('_checkSession iniciado');
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('isLoggedIn') ?? false;
    //print('_checkSession resultado: $value');
    state = value;
    //print('state actualizado a: $state');
  }

  Future<void> login(int userId, String rol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', userId);
    await prefs.setString('userRol', rol);
    state = true;
  }

  Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');
  await prefs.remove('userId');
  await prefs.remove('userRol');
  state = false;
}
}

final splashDoneProvider = StateProvider<bool>((ref) => false);