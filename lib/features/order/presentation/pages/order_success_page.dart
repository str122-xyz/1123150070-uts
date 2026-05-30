import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../../../core/routes/app_router.dart';

class OrderSuccessPage extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessPage({super.key, required this.order});

  String _statusLabel(String status) {
    return switch (status) {
      'pending' => 'Menunggu Pembayaran',
      'processing' => 'Sedang Diproses',
      'shipped' => 'Dikirim',
      'delivered' => 'Diterima',
      'cancelled' => 'Dibatalkan',
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pesanan'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outlined,
                color: Colors.green,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pesanan Berhasil!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order #${order.id}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // card detail
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.payment_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Metode Pembayaran',
                        style: theme.textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        order.paymentMethod.toUpperCase(),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.attach_money_outlined,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Total Pembayaran',
                        style: theme.textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        'Rp ${order.totalAmount.toInt()}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.info_outlined,
                        color: Colors.orange,
                      ),
                      title: Text('Status', style: theme.textTheme.bodySmall),
                      subtitle: Text(
                        _statusLabel(order.status),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // button navigasi
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRouter.myOrders);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
                child: const Text('Lihat Detail Pesanan'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kembali ke Beranda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
