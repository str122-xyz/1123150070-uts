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
      appBar: AppBar(title: const Text('Detail Pesanan'), centerTitle: true),
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
  }
}
