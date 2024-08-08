import 'package:bakery/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bakery/screen/menu_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/provider/user_provider.dart';
import 'package:bakery/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: Bakery(),
    ),
  );
}

class Bakery extends ConsumerWidget {
  const Bakery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userProvider);

    return MaterialApp(
      title: 'Bakery App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: ref.read(userProvider.notifier).isAuthenticated()
          ? const MenuScreen()
          : const LoginScreen(),
    );
  }
}
