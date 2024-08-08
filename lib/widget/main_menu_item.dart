import 'package:flutter/material.dart';

class MainMenuItem extends StatelessWidget {
  final IconData icon;
  final String name;

  const MainMenuItem({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
        ],
      )),
    );
  }
}
