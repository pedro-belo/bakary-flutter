import 'package:bakery/screen/not_implemented_screen.dart';
import 'package:bakery/screen/product/list.dart';
import 'package:bakery/screen/production_list_screen.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/main_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final Map<MenuOption, Function> screens = {
  MenuOption.settings: () => const NotImplementedScreen(),
  MenuOption.product: () => const ProductListScreen(),
  MenuOption.production: () => const ProductionScreen(),
  MenuOption.sales: () => const NotImplementedScreen(),
};

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  void navigateToSelectedOption(
      BuildContext context, MenuOption selectedOption) {
    Function? fnGetSelectedScreen = screens[selectedOption];

    if (fnGetSelectedScreen == null) {
      throw ArgumentError("$selectedOption is not a valid option.");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) {
          return fnGetSelectedScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: utils.createAppBar(
        context,
        title: "Menu",
        actions: [
          IconButton(
            onPressed: () {
              utils.invalidateState(ref);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: MainMenu(onSelectOption: navigateToSelectedOption),
      ),
    );
  }
}
