import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/provider/auth_provider.dart';
import 'package:bakery/provider/user_provider.dart';
import 'package:bakery/provider/product_provider.dart';
import 'package:bakery/provider/production_provider.dart';

PreferredSizeWidget createAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    iconTheme:
        IconThemeData(color: Theme.of(context).colorScheme.primaryContainer),
    title: Text(
      title,
      style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
    ),
    actions: actions,
  );
}

Widget createPrimaryButton(
  BuildContext context, {
  required String text,
  bool loading = false,
  VoidCallback? onPressed,
}) {
  return ElevatedButton(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    onPressed: onPressed,
    child: loading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          )
        : Text(text),
  );
}

void invalidateState(WidgetRef ref) {
  ref.read(authProvider.notifier).clean();
  ref.invalidate(authProvider);

  ref.read(userProvider.notifier).logout();
  ref.invalidate(userProvider);

  ref.read(productionProvider.notifier).clean();
  ref.invalidate(productionProvider);

  ref.read(productProvider.notifier).clean();
  ref.invalidate(productProvider);
}

void snackBarError(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 5),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.errorContainer),
      ),
    ),
  );
}

void snackBarSuccess(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 5),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        message,
        style:
            TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
      ),
    ),
  );
}

const pendingId = 0;
