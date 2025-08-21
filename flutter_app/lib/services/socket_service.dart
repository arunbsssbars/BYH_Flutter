import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  final String serverUrl;
  SocketService(this.serverUrl);

  void connect({String? vendorId, void Function(dynamic)? onNewOrder, void Function(dynamic)? onOrderUpdated, void Function(dynamic)? onProductUpdated}) {
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket?.on('connect', (_) {
      print('socket connected ${socket?.id}');
      if (vendorId != null) socket?.emit('join-vendor', vendorId);
    });

    socket?.on('new-order', (data) { if (onNewOrder != null) onNewOrder(data); });
    socket?.on('order-updated', (data) { if (onOrderUpdated != null) onOrderUpdated(data); });
    socket?.on('product-updated', (data) { if (onProductUpdated != null) onProductUpdated(data); });
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
