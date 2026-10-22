import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';
import 'daos/deck_dao.dart';
import 'daos/card_dao.dart';
import 'daos/review_dao.dart';

part 'database.g.dart';

/// Main Drift database for Haki.
///
/// All persistent data flows through this single database instance.
/// Access data through typed DAOs rather than raw queries.
@DriftDatabase(
  tables: [DeckTable, CardTable, ReviewEventTable, StudySessionTable],
  daos: [DeckDao, CardDao, ReviewDao],
)
class HakiDatabase extends _$HakiDatabase {
  HakiDatabase() : super(_openConnection());

  /// For testing: accept a custom query executor
  HakiDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(deckTable, deckTable.showReadingOnFront);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'haki.db'));
    return NativeDatabase.createInBackground(file);
  });
}
