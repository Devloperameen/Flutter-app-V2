import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/storage/storage_keys.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Provides a connected Socket.IO client that includes the JWT token.
/// Socket.IO connects to the production backend (https://flutter-app-v2.onrender.com)
/// with proper path (/socket.io/) and authentication via token.
final socketProvider = Provider<io.Socket>((ref) {
  // ✅ PRODUCTION URL - EXPLICIT, NO PORT APPEND
  const String socketUrl = 'https://flutter-app-v2.onrender.com';
  
  log.i('🔌 Socket.IO initializing: $socketUrl/socket.io/');

  // Create Socket.IO client with COMPLETE configuration
  final socket = io.io(
    socketUrl,
    io.OptionBuilder()
        .setTransports(['websocket', 'polling']) // WebSocket + fallback
        .disableAutoConnect() // Manual connection after token load
        .setPath('/socket.io/') // ✅ CRITICAL: Explicit path
        .setExtraHeaders({'Authorization': 'Bearer token'}) // Will add real token below
        .enableForceNew() // Fresh socket instance
        .setReconnectionDelay(1000)
        .setReconnectionDelayMax(5000)
        .setReconnectionAttempts(5)
        .setRandomizationFactor(0.5)
        .build(),
  );

  // Load JWT token and connect
  final storage = ref.read(secureStorageProvider);
  storage.read(StorageKeys.accessToken).then((token) {
    if (token != null && token.isNotEmpty && token != 'null') {
      log.i('✅ JWT loaded: ${token.substring(0, 20)}...');
      socket.auth = {'token': token};
      socket.connect();
      log.i('🔌 Socket.IO connecting...');
    } else {
      log.w('⚠️ No JWT token available');
    }
  }).catchError((e) {
    log.e('❌ Token error: $e');
  });

  // Connection event handlers with detailed logging
  socket.onConnect((_) {
    log.i('✅✅✅ Socket.IO CONNECTED ✅✅✅');
    log.i('Socket ID: ${socket.id}');
  });

  socket.onDisconnect((_) {
    log.w('⚠️ Socket.IO disconnected - will reconnect');
  });

  socket.onConnectError((err) {
    log.e('❌ Connection error: $err');
  });

  socket.on('connect_error', (error) {
    log.e('❌ Connect error event: $error');
  });

  socket.on('error', (error) {
    log.e('❌ Error event: $error');
  });

  socket.on('exception', (error) {
    log.e('❌ Exception: $error');
  });

  // Cleanup
  ref.onDispose(() {
    log.i('🧹 Socket.IO dispose');
    socket.disconnect();
  });

  return socket;
});
