import 'package:flutter/material.dart';
import 'package:ngopss/features/order/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isInit = true;
  late int orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      orderId = ModalRoute.of(context)!.settings.arguments as int;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OrderProvider>().fetchOrderDetail(orderId);
      });
      _isInit = false;
    }
  }

  Color _statusColor(String status) {
    if (status.toLowerCase().contains('selesai')) return Colors.green;
    if (status.toLowerCase().contains('batal')) return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();
    final order = orderProv.selectedOrder;
    final error = orderProv.error;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: _buildBody(orderProv, order, error, theme),
    );
  }

  Widget _buildBody(
    dynamic prov,
    dynamic order,
    String? error,
    ThemeData theme,
  ) {
    if (error != null) {
      return Center(
        child: Text(
          'Waduh error bosku: $error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (order == null || order.id != orderId) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // info status & id
          _buildSectionCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          color: _statusColor(order.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Metode Pembayaran',
                  order.paymentMethod.toUpperCase(),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Tanggal',
                  order.createdAt.toString().substring(0, 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // barang yang ingin dibeli
          const Text(
            'Rincian Barang',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildSectionCard(
            child: Column(
              children: order.items.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product?.name ?? 'Produk tidak diketahui',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.quantity} x Rp ${item.price.toInt()}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp ${item.subtotal.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // pengiriman & total harga
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alamat Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  order.shippingAddress,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Rp ${order.totalAmount.toInt()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
