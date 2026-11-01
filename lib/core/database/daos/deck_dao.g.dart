// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_dao.dart';

// ignore_for_file: type=lint
mixin _$DeckDaoMixin on DatabaseAccessor<HakiDatabase> {
  $DeckTableTable get deckTable => attachedDatabase.deckTable;
  $CardTableTable get cardTable => attachedDatabase.cardTable;
  DeckDaoManager get managers => DeckDaoManager(this);
}

class DeckDaoManager {
  final _$DeckDaoMixin _db;
  DeckDaoManager(this._db);
  $$DeckTableTableTableManager get deckTable =>
      $$DeckTableTableTableManager(_db.attachedDatabase, _db.deckTable);
  $$CardTableTableTableManager get cardTable =>
      $$CardTableTableTableManager(_db.attachedDatabase, _db.cardTable);
}
