import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {
  final String description;

  const LoadingData({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
