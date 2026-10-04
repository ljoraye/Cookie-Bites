import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _costController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final product = Product(
      id: '', // server-generated; ignored by ProductCatalog.add
      name: _nameController.text.trim(),
      sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0,
      costOfGoods: double.tryParse(_costController.text) ?? 0,
    );

    try {
      await ProductCatalog.add(product);
      if (!mounted) return;
      setState(() {
        _nameController.clear();
        _sellingPriceController.clear();
        _costController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _removeProduct(String id) async {
    try {
      await ProductCatalog.remove(id);
      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Manage Products'),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Products',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ProductCatalog.items.isEmpty
                  ? const Center(child: Text('No products yet'))
                  : ListView.separated(
                      itemCount: ProductCatalog.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final product = ProductCatalog.items[index];
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Sells for ₱${product.sellingPrice.toStringAsFixed(2)} · '
                                      'Cost ₱${product.costOfGoods.toStringAsFixed(2)} · '
                                      'Profit ₱${product.profitPerUnit.toStringAsFixed(2)}/unit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeProduct(product.id),
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 32),
            const Text(
              'Add a New Product',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.sm),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Product Name',
                    controller: _nameController,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Selling Price (₱)',
                          controller: _sellingPriceController,
                          keyboardType: TextInputType.number,
                          validator: (v) => double.tryParse(v ?? '') == null
                              ? 'Enter a number'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: 'Cost of Goods (₱)',
                          controller: _costController,
                          keyboardType: TextInputType.number,
                          validator: (v) => double.tryParse(v ?? '') == null
                              ? 'Enter a number'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _addProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Add Product',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
