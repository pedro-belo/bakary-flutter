import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:flutter/material.dart';

class ProductionForm extends StatefulWidget {
  final Future<void> Function(Production) onCreateProduction;
  final List<Product> products;

  const ProductionForm({
    super.key,
    required this.products,
    required this.onCreateProduction,
  });

  @override
  State<ProductionForm> createState() {
    return _ProductionForm();
  }
}

String? numberValidator(String? value, {num? min, num? max}) {
  if (value == null) {
    return "Campo obrigatório";
  }

  final number = num.tryParse(value);

  if (number == null) {
    return "Apenas valores numéricos";
  }

  if (min != null && number < min) {
    return "Deve ser maior ou igual a $min";
  }

  if (max != null && number > max) {
    return "Deve ser menor ou igual a $max";
  }

  return null;
}

class _ProductionForm extends State<ProductionForm> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: "1");
  final _productionPriceController = TextEditingController(text: "0.0");
  final _salePriceController = TextEditingController(text: "0.0");
  int? _selectedProduct;
  double? expectedRevenue;
  DateTime? _selectedDate;
  bool isLocked = false;

  _ProductionForm();

  void reset() {
    _formState.currentState!.reset();
    setState(() {
      _selectedDate = null;
    });
    setState(() {
      _selectedProduct = null;
    });
  }

  void onFormSubmit() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nenhum produto selecionado."),
        ),
      );
      return;
    }
    ;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data de produção não informada."),
        ),
      );
      return;
    }

    bool formIsValid = _formState.currentState!.validate();
    if (!formIsValid) {
      return;
    }

    setState(() {
      isLocked = true;
    });

    await widget.onCreateProduction(
      Production(
        id: utils.pendingId,
        productId: _selectedProduct!,
        productionPrice: double.parse(_productionPriceController.text),
        salePrice: double.parse(_salePriceController.text),
        quantity: int.parse(_quantityController.text),
        date: _selectedDate!,
      ),
    );

    setState(() {
      isLocked = false;
    });
  }

  void updateExpectedRevenue() {
    final quantity = double.tryParse(_quantityController.text);
    final productionPrice = double.tryParse(_productionPriceController.text);
    final salePrice = double.tryParse(_salePriceController.text);
    bool isValid =
        quantity != null && productionPrice != null && salePrice != null;
    if (isValid) {
      setState(() {
        expectedRevenue = (salePrice - productionPrice) * quantity;
      });
    } else {
      setState(() {
        expectedRevenue = null;
      });
    }
  }

  void openDatePicker() async {
    DateTime? seletedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().copyWith(year: 2000),
      lastDate: DateTime.now(),
    );
    if (seletedDate != null) {
      setState(() {
        _selectedDate = seletedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropDownItems = [...widget.products];
    dropDownItems
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Form(
      key: _formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
            iconEnabledColor: Colors.white,
            value: _selectedProduct,
            isExpanded: true,
            isDense: true,
            hint: const Text(
              "Produto",
              style: TextStyle(color: Colors.white),
            ),
            validator: (value) {
              if (value == null) return "Obrigatório";
              return null;
            },
            items: dropDownItems
                .map(
                  (product) => DropdownMenuItem(
                    value: product.id,
                    child: Text(
                      '${product.name} (${product.category.name})',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedProduct = value;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _salePriceController,
                  decoration: const InputDecoration(
                    label: Text(
                      "Preço de Venda",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    updateExpectedRevenue();
                  },
                  validator: (value) => numberValidator(value, min: 0.0),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextFormField(
                  controller: _productionPriceController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Preço de Produção',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    updateExpectedRevenue();
                  },
                  validator: (value) => numberValidator(value, min: 0.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (expectedRevenue != null && expectedRevenue != 0)
            Text(
              "${expectedRevenue! > 0 ? 'Receita' : 'Prejuizo'} esperado: ${expectedRevenue!.abs().toStringAsFixed(2)} R\$",
              style: TextStyle(
                  color:
                      expectedRevenue! > 0 ? Colors.green : Colors.redAccent),
            ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Quantidade',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    updateExpectedRevenue();
                  },
                  validator: (value) => numberValidator(value, min: 1),
                ),
              ),
              const SizedBox(width: 20),
              _selectedDate == null
                  ? IconButton(
                      color: Colors.white,
                      onPressed: openDatePicker,
                      icon: const Icon(Icons.date_range_outlined),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                      child: Text(
                        "${_selectedDate!.day.toString()} / ${_selectedDate!.month.toString()} / ${_selectedDate!.year.toString()}",
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white),
                onPressed: reset,
                child: const Text("Limpar"),
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