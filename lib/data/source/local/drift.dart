import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../../domain/models/role.dart';
import '../../../utils/logger.dart';
import 'database/chat_room_dao.dart';
import 'database/message_dao.dart';
import 'database/table/chat_room_table.dart';
import 'database/table/message_table.dart';

part 'drift.g.dart';

@DriftDatabase(
  tables: [
    ChatRoomTable,
    MessageTable,
  ],
  daos: [
    ChatRoomDao,
    MessageDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;

  AppDatabase()
      : super(
          driftDatabase(
            name: 'talk',
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
              onResult: (result) {
                if (result.missingFeatures.isNotEmpty) {
                  logDebug(
                      'Using ${result.chosenImplementation} due to unsupported '
                      'browser features: ${result.missingFeatures}');
                }
              },
            ),
          ),
        );

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          logInfo('Database beforeOpen wasCreated: ${details.wasCreated}');
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          logInfo('Database onUpgrade $from -> $to');
        },
      );

  AppDatabase.forTesting(DatabaseConnection super.connection);

  Future<void> deleteAllData() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
