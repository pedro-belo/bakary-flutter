import 'package:bakery/models/product.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  final Future<void> Function(Product) onCreateProduct;

  const ProductForm({
    super.key,
    required this.onCreateProduct,
  });

  @override
  State<ProductForm> createState() {
    return _ProductForm();
  }
}

class _ProductForm extends State<ProductForm> {
  final _formState = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _productCategory;
  bool isLocked = false;

  _ProductForm();

  void onFormSubmit() async {
    final isValid = _formState.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (_productCategory == null) {
      utils.snackBarError(context, message: "Categoria é obrigatório.");
      return;
    }

    setState(() {
      isLocked = true;
    });

    await widget.onCreateProduct(
      Product(
        id: utils.pendingId,
        name: _nameController.text,
        category: ProductCategory.fromValue(_productCategory!),
      ),
    );

    setState(() {
      isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text(
                'Nome',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo Obrigatório";
              }

              return null;
            },
          ),
          const SizedBox(height: 22),
          DropdownButton(
            dropdownColor:
                Theme.of(context).colorScheme.background.withAlpha(100),
            value: _productCategory,
            isExpanded: true,
            isDense: true,
            hint: const Text(
              "Categoria",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            items: ProductCategory.values
                .toList()
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit.index,
                    child: Text(
                      unit.name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _productCategory = value;
              });
            },
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _nameController.clear();
                  });
                  setState(() {
                    _productCategory = null;
                  });
                },
                child: const Text(
                  "Limpar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              utils.createPrimaryButton(
                context,
                text: "Salvar",
                loading: isLocked,
                onPressed: isLocked ? null : onFormSubmit,
              ),
            ],
          )
        ],
      ),
    );
  }
}
