import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

/// Lightweight Socket.IO client with auto-cleanup hooks.
class RealtimeSocketService {
  io.Socket? _socket;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<bool> connect({
    required Uri uri,
    required void Function(Map<String, dynamic> event) onEvent,
    void Function(Object error, StackTrace stackTrace)? onError,
    void Function()? onDone,
  }) async {
    try {
      await disconnect();

      final completer = Completer<bool>();
      final baseUrl = _buildSocketBaseUrl(uri);
      final socket = io.io(
        baseUrl,
        io.OptionBuilder()
            .setPath('/socket.io')
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableForceNew()
            .build(),
      );

      _socket = socket;

      void completeOnce(bool connected) {
        if (!completer.isCompleted) {
          completer.complete(connected);
        }
      }

      _registerForwardedEvents(socket, onEvent);

      socket.onConnect((_) {
        _isConnected = true;
        completeOnce(true);
      });

      socket.onConnectError((dynamic error) {
        _isConnected = false;
        onError?.call(Exception(error.toString()), StackTrace.current);
        completeOnce(false);
      });

      socket.onError((dynamic error) {
        _isConnected = false;
        onError?.call(Exception(error.toString()), StackTrace.current);
      });

      socket.onDisconnect((_) {
        _isConnected = false;
        onDone?.call();
      });

      socket.connect();

      return completer.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          _isConnected = false;
          return false;
        },
      );
    } catch (_) {
      _isConnected = false;
      return false;
    }
  }

  void send(Map<String, dynamic> event) {
    final socket = _socket;
    if (socket == null || !_isConnected) {
      return;
    }

    final type = event['type'];
    if (type is! String || type.isEmpty) {
      return;
    }

    final payload = Map<String, dynamic>.from(event)..remove('type');
    socket.emit(type, payload);
  }

  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    _isConnected = false;

    if (socket == null) {
      return;
    }

    socket.dispose();
    socket.disconnect();
  }

  String _buildSocketBaseUrl(Uri uri) {
    final portPart = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$portPart';
  }

  void _registerForwardedEvents(
    io.Socket socket,
    void Function(Map<String, dynamic> event) onEvent,
  ) {
    const forwardedEvents = [
      'connection.ready',
      'auth.success',
      'auth.error',
      'subscribed',
      'subscription.error',
      'comment.created',
      'comment.deleted',
      'message.created',
      'conversation.message.created',
    ];

    for (final eventName in forwardedEvents) {
      socket.on(eventName, (dynamic payload) {
        onEvent({'type': eventName, 'data': _normalizePayload(payload)});
      });
    }
  }

  Map<String, dynamic> _normalizePayload(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }

    return {'value': payload};
  }
}
