import 'package:bakery/provider/auth_provider.dart';
import 'package:bakery/repository/repository.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/user_credentials.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  void onFormSubmit(
    String username,
    String password,
    BuildContext context,
    WidgetRef ref,
  ) {
    final http = ref.read(authProvider.notifier).getUnauthenticatedHttpClient();
    final repository = Repository(http);
    final result = repository.user.register(username, password);

    result.then((successMessage) {
      utils.snackBarSuccess(context, message: successMessage);
      Navigator.pop(context);
    }).catchError((err) {
      utils.snackBarError(context, message: err.toString());
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Cadastro"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: UserCredentials(
          textSubmitButton: "Cadastrar",
          description: "Informe os dados de cadastro",
          onFormSubmit: (username, password) {
            onFormSubmit(username, password, context, ref);
          },
        ),
      ),
    );
  }
}
