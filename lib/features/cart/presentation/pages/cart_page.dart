import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../../../core/routes/app_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final theme = Theme.of(context);

    final items = cartProv.cart?.items ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Ngops',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(context, cartProv, items, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CartProvider cartProv,
    List<dynamic> items,
    ThemeData theme,
  ) {
    if (cartProv.status == CartStatus.loading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartProv.status == CartStatus.error) {
      return Center(child: Text('Gagal memuat keranjang: ${cartProv.error}'));
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Keranjangmu masih kosong nih!',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cartItem = items[index];
              final product = cartItem.product;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${cartItem.subtotal.toInt()}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              if (cartItem.quantity <= 1) {
                                cartProv.removeItem(cartItem.id);
                              } else {
                                cartProv.updateItem(
                                  cartItem.id,
                                  cartItem.quantity - 1,
                                );
                              }
                            },
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () => cartProv.updateItem(
                              cartItem.id,
                              cartItem.quantity + 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // total & checkout
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'Rp ${(cartProv.cart?.total ?? 0).toInt()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (items.isEmpty) return;
                      Navigator.pushNamed(context, AppRouter.checkout);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Lanjut Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
