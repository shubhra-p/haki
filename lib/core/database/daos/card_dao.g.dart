// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_dao.dart';

// ignore_for_file: type=lint
mixin _$CardDaoMixin on DatabaseAccessor<HakiDatabase> {
  $DeckTableTable get deckTable => attachedDatabase.deckTable;
  $CardTableTable get cardTable => attachedDatabase.cardTable;
  CardDaoManager get managers => CardDaoManager(this);
}

class CardDaoManager {
  final _$CardDaoMixin _db;
  CardDaoManager(this._db);
  $$DeckTableTableTableManager get deckTable =>
      $$DeckTableTableTableManager(_db.attachedDatabase, _db.deckTable);
  $$CardTableTableTableManager get cardTable =>
      $$CardTableTableTableManager(_db.attachedDatabase, _db.cardTable);
}
