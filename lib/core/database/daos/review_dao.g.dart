// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dao.dart';

// ignore_for_file: type=lint
mixin _$ReviewDaoMixin on DatabaseAccessor<HakiDatabase> {
  $DeckTableTable get deckTable => attachedDatabase.deckTable;
  $CardTableTable get cardTable => attachedDatabase.cardTable;
  $ReviewEventTableTable get reviewEventTable =>
      attachedDatabase.reviewEventTable;
  $StudySessionTableTable get studySessionTable =>
      attachedDatabase.studySessionTable;
  ReviewDaoManager get managers => ReviewDaoManager(this);
}

class ReviewDaoManager {
  final _$ReviewDaoMixin _db;
  ReviewDaoManager(this._db);
  $$DeckTableTableTableManager get deckTable =>
      $$DeckTableTableTableManager(_db.attachedDatabase, _db.deckTable);
  $$CardTableTableTableManager get cardTable =>
      $$CardTableTableTableManager(_db.attachedDatabase, _db.cardTable);
  $$ReviewEventTableTableTableManager get reviewEventTable =>
      $$ReviewEventTableTableTableManager(
          _db.attachedDatabase, _db.reviewEventTable);
  $$StudySessionTableTableTableManager get studySessionTable =>
      $$StudySessionTableTableTableManager(
          _db.attachedDatabase, _db.studySessionTable);
}
