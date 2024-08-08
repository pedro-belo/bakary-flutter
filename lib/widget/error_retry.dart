import 'package:flutter/material.dart';
import 'package:bakery/utils.dart' as utils;

class ErrorRetry extends StatelessWidget {
  final String message;
  final void Function() onTryAgain;

  const ErrorRetry({
    super.key,
    required this.message,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            utils.createPrimaryButton(
              context,
              text: "Tentar novamente",
              onPressed: () {
                onTryAgain();
              },
            ),
          ],
        ),
      ),
    );
  }
}
