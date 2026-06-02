import 'package:flutter_riverpod/legacy.dart';
import 'package:medstock/config/database/user_dbhelper.dart';
import 'package:medstock/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>((ref) {
  return UserListNotifier();
});

class UserListNotifier extends StateNotifier<List<User>> {
  final UserDatabaseHelper dbHelper = UserDatabaseHelper();

  UserListNotifier() : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    final users = await dbHelper.getUsers();
    state = users;
  }

  Future<void> addUser(User user) async {
    await dbHelper.insertUser(user);
    await loadUsers();
  }

  Future<void> updateUser(User user) async {
    await dbHelper.updateUser(user);
    await loadUsers();
  }

  Future<void> deleteUser(int id) async {
    await dbHelper.deleteUser(id);
    await loadUsers();
  }

  Future<User?> checkUserData(String matricula, String password) async {
    return await dbHelper.findByMatriculaAndPassword(matricula, password);
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends StateNotifier<User?> {
  final UserDatabaseHelper dbHelper = UserDatabaseHelper();

  CurrentUserNotifier() : super(null) {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;
    state = await dbHelper.findById(userId);
  }

  Future<void> updateCurrentUser(User user) async {
    await dbHelper.updateUser(user);
    state = user;
  }
}