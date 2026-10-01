import 'package:flutter/material.dart';
import 'package:autobank_mobile/features/notification_listener/presentation/notification_service.dart';

void main() {
  runApp(const AutoBankApp());
}

class AutoBankApp extends StatelessWidget {
  const AutoBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoBank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isListenerEnabled = false;
  final List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _startListening();
  }

  Future<void> _checkPermission() async {
    final isEnabled = await NotificationService.isListenerEnabled();
    setState(() {
      _isListenerEnabled = isEnabled;
    });
  }

  void _startListening() {
    NotificationService.notificationStream.listen((notification) {
      setState(() {
        _notifications.insert(0, notification);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoBank - Phase 1'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _isListenerEnabled ? Colors.green.shade100 : Colors.red.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isListenerEnabled ? 'Trạng thái: Đã cấp quyền' : 'Trạng thái: Chưa cấp quyền',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (!_isListenerEnabled)
                  ElevatedButton(
                    onPressed: () async {
                      await NotificationService.openSettings();
                    },
                    child: const Text('Cấp quyền ngay'),
                  ),
                if (_isListenerEnabled)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _checkPermission,
                  )
              ],
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? const Center(child: Text("Đang chờ thông báo ngân hàng..."))
                : ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: Text(notif['title'] ?? 'Unknown'),
                        subtitle: Text(notif['text'] ?? ''),
                        trailing: Text(
                          notif['package']?.toString().split('.').last ?? '',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
