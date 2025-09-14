import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/providers/supabase_providers.dart';

enum ProductEventType { insert, update, delete }

class ProductRealtimeEvent {
  final ProductEventType type;
  final Map<String, dynamic> row; // payload dari Supabase
  ProductRealtimeEvent(this.type, this.row);
}

final productRealtimeSourceProvider = Provider<ProductRealtimeSource>((ref) {
  final sb = ref.read(supabaseClientProvider);
  final src = ProductRealtimeSource(sb);
  ref.onDispose(src.dispose);
  return src;
});

class ProductRealtimeSource {
  ProductRealtimeSource(this._sb);
  final SupabaseClient _sb;

  RealtimeChannel? _chan;
  StreamController<ProductRealtimeEvent>? _ctrl;

  Stream<ProductRealtimeEvent> stream() {
    _ctrl ??= StreamController.broadcast(onListen: _ensureChannel);
    _ensureChannel();
    return _ctrl!.stream;
  }

  void _ensureChannel() {
    if (_chan != null) return;

    _chan = _sb.channel('realtime:public:products')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'products',
        callback: (payload) {
          _ctrl?.add(ProductRealtimeEvent(
            ProductEventType.insert,
            (payload.newRecord as Map).cast<String, dynamic>(),
          ));
        },
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'products',
        callback: (payload) {
          _ctrl?.add(ProductRealtimeEvent(
            ProductEventType.update,
            (payload.newRecord as Map).cast<String, dynamic>(),
          ));
        },
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'products',
        callback: (payload) {
          _ctrl?.add(ProductRealtimeEvent(
            ProductEventType.delete,
            (payload.oldRecord as Map).cast<String, dynamic>(),
          ));
        },
      )
      ..subscribe();
  }

  void dispose() {
    _chan?.unsubscribe();
    _chan = null;
    _ctrl?.close();
    _ctrl = null;
  }
}
