import 'package:bakery/provider/auth_provider.dart';
import 'package:bakery/provider/user_provider.dart';
import 'package:bakery/repository/repository.dart';
import 'package:bakery/screen/registration_screen.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/user_credentials.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void navigateToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) {
          return const RegistrationScreen();
        },
      ),
    );
  }

  void onRegistration(
    String username,
    String password,
    BuildContext context,
    WidgetRef ref,
  ) {
    final http = ref.read(authProvider.notifier).getUnauthenticatedHttpClient();
    final repository = Repository(http);

    final result = repository.user.login(username, password);
    result.then((authData) {
      ref.read(authProvider.notifier).configure(
            accessToken: authData['accessToken'],
            refreshToken: authData['refreshToken'],
            calledWhenRefreshTokenExpire: () {
              utils.invalidateState(ref);
            },
          );
      ref.read(userProvider.notifier).authenticate(authData['user']);
    }).catchError((err) {
      utils.snackBarError(context, message: err.toString());
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: utils.createAppBar(
        context,
        title: "Identifique-se",
        actions: [
          IconButton(
            onPressed: () => navigateToRegistration(context),
            icon: const Icon(
              Icons.person_add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: UserCredentials(
          textSubmitButton: "Login",
          description: "Entre em sua conta para continuar",
          onFormSubmit: (username, password) {
            onRegistration(username, password, context, ref);
          },
        ),
      ),
    );
  }
}
