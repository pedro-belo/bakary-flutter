import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/not_implemented.dart';
import 'package:flutter/material.dart';

class NotImplementedScreen extends StatelessWidget {
  const NotImplementedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "NoImpl"),
      body: const NotImplemented(),
    );
  }
}
