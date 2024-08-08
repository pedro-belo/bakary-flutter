import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/models/user.dart';

class UserData {
  final User? user;
  final bool isAuthenticated;

  UserData({
    this.user,
    required this.isAuthenticated,
  });
}

final userProvider = NotifierProvider<UserProvider, UserData>(
  () => UserProvider(),
);

class UserProvider extends Notifier<UserData> {
  @override
  UserData build() {
    return UserData(isAuthenticated: false);
  }

  void authenticate(User user) {
    state = UserData(
      user: user,
      isAuthenticated: true,
    );
  }

  void logout() {
    state = UserData(isAuthenticated: false);
  }

  bool isAuthenticated() => state.user != null && state.isAuthenticated;
}
