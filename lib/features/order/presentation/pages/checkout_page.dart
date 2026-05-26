import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../../../../core/routes/app_router.dart';

class _PaymentOption {
  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _PaymentOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _selectedPaymentMethod;

  static const List<_PaymentOption> _paymentOptions = [
    _PaymentOption(
      value: 'gopay',
      label: 'GoPay',
      subtitle: 'Bayar instant dengan GoPay',
      icon: Icons.account_balance_wallet,
      iconColor: Color(0xFF00ADB5),
    ),
    _PaymentOption(
      value: 'bank_transfer',
      label: 'Transfer Bank',
      subtitle: 'BCA, Mandiri, BNI, BRI',
      icon: Icons.account_balance,
      iconColor: Color(0xFF1565C0),
    ),
    _PaymentOption(
      value: 'virtual_account',
      label: 'Virtual Account',
      subtitle: 'Nomor VA otomatis digenerate',
      icon: Icons.credit_card,
      iconColor: Color(0xFFE65100),
    ),
  ];

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih metode pembayaran terlebih dahulu',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final orderProv = context.read<OrderProvider>();
    final cartProv = context.read<CartProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await orderProv.checkout(
      shippingAddress: _addressCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      paymentMethod: _selectedPaymentMethod!,
    );

    if (context.mounted) Navigator.pop(context);

    if (success && context.mounted) {
      await cartProv.clearCart();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.orderSuccess,
        (route) =>
            route.settings.name == AppRouter.dashboard ||
            route.settings.name == '/main',
        arguments: orderProv.lastOrder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProv = context.watch<CartProvider>();
    final items = cartProv.cart?.items ?? [];
    final total = cartProv.cart?.total ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ringkasan pesanan
              Text('Ringkasan Pesanan', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    Text(
                                      '${item.quantity} x Rp ${item.product.price.toInt()}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp ${item.subtotal.toInt()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${total.toInt()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // alamat pengiriman
              Text('Alamat Pengiriman', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Masukkan alamat lengkap pengiriman...',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Alamat wajib diisi'
                    : null,
              ),
              const SizedBox(height: 24),

              // catatan opsional doang
              Text('Catatan (opsional)', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  hintText: 'Tambahkan catatan untuk ngopss...',
                ),
              ),
              const SizedBox(height: 24),

              // method payment
              Text('Metode Pembayaran', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ..._paymentOptions.map(
                (option) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: _selectedPaymentMethod == option.value
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : theme.cardTheme.color,
                  child: RadioListTile<String>(
                    value: option.value,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => _selectedPaymentMethod = value),
                    title: Text(
                      option.label,
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      option.subtitle,
                      style: theme.textTheme.bodyMedium,
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: option.iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(option.icon, color: option.iconColor),
                    ),
                    activeColor: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // button place order
      bottomNavigationBar: Container(
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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: items.isEmpty ? null : () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Buat Pesanan'),
            ),
          ),
        ),
      ),
    );
  }
}
