import 'package:flutter/material.dart';
import './main_menu_item.dart';

enum MenuOption {
  settings,
  product,
  production,
  sales,
}

const menuOptions = {
  MenuOption.settings: ("Usuário", Icons.person),
  MenuOption.product: ("Produto", Icons.fastfood),
  MenuOption.production: ("Produção", Icons.factory_outlined),
  MenuOption.sales: ("Vendas", Icons.attach_money),
};

class MainMenu extends StatelessWidget {
  final void Function(BuildContext, MenuOption) onSelectOption;

  const MainMenu({super.key, required this.onSelectOption});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: menuOptions.entries
          .map((menuOption) => InkWell(
                child: MainMenuItem(
                  name: menuOption.value.$1,
                  icon: menuOption.value.$2,
                ),
                onTap: () {
                  onSelectOption(context, menuOption.key);
                },
              ))
          .toList(),
    );
  }
}
