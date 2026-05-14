import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/user.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void initSocket(String userId, WidgetRef ref, String token) {
  //String baseUrl = "http://localhost:3000";
  String baseUrl = "https://api.moonlinks.me";
  final socket = IO.io(baseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });
  socket.connect();

  socket.onConnect((_) {
    print('Connected with id: ${socket.id}');
    socket.emit('register_user', userId);
  });

  socket.on('subscription_updated', (data) async {
    print('Received subscription update: $data');
    ref.read(cartProvider.notifier).removeAll();
    updateSubServices(ref, token);
  });

  socket.on('invoice_paid', (data) async {
    print('Received invoice paid: $data');
    updateSubServices(ref, token);
  });

  socket.on('invoice_failed', (data) async {
    print('Received invoice failed: $data');
    ref.read(cartProvider.notifier).removeAll();
    updateSubServices(ref, token);
  });

  socket.onDisconnect((_) => print('Disconnected'));
}

void updateSubServices(WidgetRef ref, String token) async {
  final userAPI = User();
  final fetechedServices = await userAPI.getSubscribedServices(token);
  List<Map<String, dynamic>> subServices = [];

  if (fetechedServices is! List) {
    subServices = List<Map<String, dynamic>>.from(fetechedServices['data']);
    final subServicesNotifier = ref.read(subServicesProvider.notifier);
    subServicesNotifier.removeAll();
    for (var service in subServices) {
      subServicesNotifier.addToSubServices(service);
      print(service);
    }
  }
  ref.read(cartProvider.notifier).removeSubscribedServices(subServices);
}
