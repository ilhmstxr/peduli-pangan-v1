// data/merchant_realtime_source.dart
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'merchant_model.dart';
import 'merchant_mapper.dart';

enum MerchantEventType { insert, update, delete }

class MerchantEvent {
  final MerchantEventType type;
  final Merchant? newRow;
  final int? oldId;

  MerchantEvent.insert(this.newRow)
      : type = MerchantEventType.insert,
        oldId = null;

  MerchantEvent.update(this.newRow)
      : type = MerchantEventType.update,
        oldId = null;

  MerchantEvent.delete(this.oldId)
      : type = MerchantEventType.delete,
        newRow = null;
}

class MerchantRealtimeSource {
  final SupabaseClient client;
  RealtimeChannel? _channel;

  MerchantRealtimeSource(this.client);

  Stream<MerchantEvent> subscribe() {
    _channel?.unsubscribe();
    final controller = StreamController<MerchantEvent>.broadcast();

    _channel = client.channel('public:merchants');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'merchants',
          callback: (payload) {
            controller.add(
              MerchantEvent.insert(
                MerchantMapper.fromDb(payload.newRecord),
              ),
            );
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'merchants',
          callback: (payload) {
            controller.add(
              MerchantEvent.update(
                MerchantMapper.fromDb(payload.newRecord),
              ),
            );
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'merchants',
          callback: (payload) {
            controller.add(MerchantEvent.delete((payload.oldRecord['id'] as num).toInt()));
          },
        )
        .subscribe();

    controller.onCancel = () => _channel?.unsubscribe();

    return controller.stream;
  }
}
