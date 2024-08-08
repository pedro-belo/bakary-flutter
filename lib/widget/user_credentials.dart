import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/utils.dart' as utils;

class UserCredentials extends ConsumerStatefulWidget {
  final String textSubmitButton;
  final String description;
  final void Function(String, String) onFormSubmit;

  const UserCredentials({
    super.key,
    required this.textSubmitButton,
    required this.onFormSubmit,
    required this.description,
  });

  @override
  ConsumerState<UserCredentials> createState() {
    return _UserCredentials();
  }
}

class _UserCredentials extends ConsumerState<UserCredentials> {
  final _formState = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "user@example.com");
  final _passwordController = TextEditingController(text: "string");
  bool isLocked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onFormSubmit() async {
    bool isValid = _formState.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLocked = true;
    });

    widget.onFormSubmit(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      isLocked = false;
    });
  }

  _UserCredentials();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text(
                'E-Mail',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              label: Text(
                'Senha',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            obscureText: true,
            validator: (password) {
              if (password == null || password.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          utils.createPrimaryButton(
            context,
            text: widget.textSubmitButton,
            loading: isLocked,
            onPressed: isLocked ? null : onFormSubmit,
          ),
        ],
      ),
    );
  }
}
