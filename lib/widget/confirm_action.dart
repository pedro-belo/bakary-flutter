import 'package:flutter/material.dart';

class ConfirmAction extends StatelessWidget {
  final String message;
  final void Function() onConfirmation;

  const ConfirmAction(
      {super.key, required this.message, required this.onConfirmation});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber,
            size: 120,
            color: Theme.of(context).colorScheme.error,
          ),
          Text(
            "Ação Irreversível",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.tertiaryContainer),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
            onPressed: () {
              onConfirmation();
              Navigator.pop(context);
            },
            child: const Text("Remover"),
          )
        ],
      ),
    );
  }
}
