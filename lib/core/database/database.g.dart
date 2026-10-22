// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DeckTableTable extends DeckTable
    with TableInfo<$DeckTableTable, DeckTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sourceLanguageMeta =
      const VerificationMeta('sourceLanguage');
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
      'source_language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetLanguageMeta =
      const VerificationMeta('targetLanguage');
  @override
  late final GeneratedColumn<String> targetLanguage = GeneratedColumn<String>(
      'target_language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastStudiedAtMeta =
      const VerificationMeta('lastStudiedAt');
  @override
  late final GeneratedColumn<DateTime> lastStudiedAt =
      GeneratedColumn<DateTime>('last_studied_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        sourceLanguage,
        targetLanguage,
        createdAt,
        updatedAt,
        lastStudiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(Insertable<DeckTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_language')) {
      context.handle(
          _sourceLanguageMeta,
          sourceLanguage.isAcceptableOrUnknown(
              data['source_language']!, _sourceLanguageMeta));
    }
    if (data.containsKey('target_language')) {
      context.handle(
          _targetLanguageMeta,
          targetLanguage.isAcceptableOrUnknown(
              data['target_language']!, _targetLanguageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_studied_at')) {
      context.handle(
          _lastStudiedAtMeta,
          lastStudiedAt.isAcceptableOrUnknown(
              data['last_studied_at']!, _lastStudiedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sourceLanguage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_language']),
      targetLanguage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_language']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastStudiedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_studied_at']),
    );
  }

  @override
  $DeckTableTable createAlias(String alias) {
    return $DeckTableTable(attachedDatabase, alias);
  }
}

class DeckTableData extends DataClass implements Insertable<DeckTableData> {
  final String id;
  final String name;
  final String? sourceLanguage;
  final String? targetLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastStudiedAt;
  const DeckTableData(
      {required this.id,
      required this.name,
      this.sourceLanguage,
      this.targetLanguage,
      required this.createdAt,
      required this.updatedAt,
      this.lastStudiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sourceLanguage != null) {
      map['source_language'] = Variable<String>(sourceLanguage);
    }
    if (!nullToAbsent || targetLanguage != null) {
      map['target_language'] = Variable<String>(targetLanguage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastStudiedAt != null) {
      map['last_studied_at'] = Variable<DateTime>(lastStudiedAt);
    }
    return map;
  }

  DeckTableCompanion toCompanion(bool nullToAbsent) {
    return DeckTableCompanion(
      id: Value(id),
      name: Value(name),
      sourceLanguage: sourceLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLanguage),
      targetLanguage: targetLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(targetLanguage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastStudiedAt: lastStudiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStudiedAt),
    );
  }

  factory DeckTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sourceLanguage: serializer.fromJson<String?>(json['sourceLanguage']),
      targetLanguage: serializer.fromJson<String?>(json['targetLanguage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastStudiedAt: serializer.fromJson<DateTime?>(json['lastStudiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sourceLanguage': serializer.toJson<String?>(sourceLanguage),
      'targetLanguage': serializer.toJson<String?>(targetLanguage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastStudiedAt': serializer.toJson<DateTime?>(lastStudiedAt),
    };
  }

  DeckTableData copyWith(
          {String? id,
          String? name,
          Value<String?> sourceLanguage = const Value.absent(),
          Value<String?> targetLanguage = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastStudiedAt = const Value.absent()}) =>
      DeckTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        sourceLanguage:
            sourceLanguage.present ? sourceLanguage.value : this.sourceLanguage,
        targetLanguage:
            targetLanguage.present ? targetLanguage.value : this.targetLanguage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastStudiedAt:
            lastStudiedAt.present ? lastStudiedAt.value : this.lastStudiedAt,
      );
  DeckTableData copyWithCompanion(DeckTableCompanion data) {
    return DeckTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
      targetLanguage: data.targetLanguage.present
          ? data.targetLanguage.value
          : this.targetLanguage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastStudiedAt: data.lastStudiedAt.present
          ? data.lastStudiedAt.value
          : this.lastStudiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastStudiedAt: $lastStudiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sourceLanguage, targetLanguage,
      createdAt, updatedAt, lastStudiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.sourceLanguage == this.sourceLanguage &&
          other.targetLanguage == this.targetLanguage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastStudiedAt == this.lastStudiedAt);
}

class DeckTableCompanion extends UpdateCompanion<DeckTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> sourceLanguage;
  final Value<String?> targetLanguage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastStudiedAt;
  final Value<int> rowid;
  const DeckTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastStudiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeckTableCompanion.insert({
    required String id,
    required String name,
    this.sourceLanguage = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastStudiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<DeckTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sourceLanguage,
    Expression<String>? targetLanguage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastStudiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastStudiedAt != null) 'last_studied_at': lastStudiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeckTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? sourceLanguage,
      Value<String?>? targetLanguage,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastStudiedAt,
      Value<int>? rowid}) {
    return DeckTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    if (targetLanguage.present) {
      map['target_language'] = Variable<String>(targetLanguage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastStudiedAt.present) {
      map['last_studied_at'] = Variable<DateTime>(lastStudiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastStudiedAt: $lastStudiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardTableTable extends CardTable
    with TableInfo<$CardTableTable, CardTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES decks (id)'));
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word =
      GeneratedColumn<String>('word', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _meaningMeta =
      const VerificationMeta('meaning');
  @override
  late final GeneratedColumn<String> meaning =
      GeneratedColumn<String>('meaning', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _transliterationMeta =
      const VerificationMeta('transliteration');
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
      'transliteration', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pronunciationMeta =
      const VerificationMeta('pronunciation');
  @override
  late final GeneratedColumn<String> pronunciation = GeneratedColumn<String>(
      'pronunciation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reviewStatusMeta =
      const VerificationMeta('reviewStatus');
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
      'review_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('newCard'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _incorrectCountMeta =
      const VerificationMeta('incorrectCount');
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
      'incorrect_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deckId,
        word,
        meaning,
        transliteration,
        pronunciation,
        createdAt,
        updatedAt,
        lastReviewedAt,
        reviewStatus,
        dueDate,
        intervalDays,
        easeFactor,
        reviewCount,
        correctCount,
        incorrectCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<CardTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(_meaningMeta,
          meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta));
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
          _transliterationMeta,
          transliteration.isAcceptableOrUnknown(
              data['transliteration']!, _transliterationMeta));
    }
    if (data.containsKey('pronunciation')) {
      context.handle(
          _pronunciationMeta,
          pronunciation.isAcceptableOrUnknown(
              data['pronunciation']!, _pronunciationMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    if (data.containsKey('review_status')) {
      context.handle(
          _reviewStatusMeta,
          reviewStatus.isAcceptableOrUnknown(
              data['review_status']!, _reviewStatusMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
          _incorrectCountMeta,
          incorrectCount.isAcceptableOrUnknown(
              data['incorrect_count']!, _incorrectCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      meaning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning'])!,
      transliteration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transliteration']),
      pronunciation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pronunciation']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
      reviewStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}review_status'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
      incorrectCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incorrect_count'])!,
    );
  }

  @override
  $CardTableTable createAlias(String alias) {
    return $CardTableTable(attachedDatabase, alias);
  }
}

class CardTableData extends DataClass implements Insertable<CardTableData> {
  final String id;
  final String deckId;
  final String word;
  final String meaning;
  final String? transliteration;
  final String? pronunciation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReviewedAt;
  final String reviewStatus;
  final DateTime? dueDate;
  final int intervalDays;
  final double easeFactor;
  final int reviewCount;
  final int correctCount;
  final int incorrectCount;
  const CardTableData(
      {required this.id,
      required this.deckId,
      required this.word,
      required this.meaning,
      this.transliteration,
      this.pronunciation,
      required this.createdAt,
      required this.updatedAt,
      this.lastReviewedAt,
      required this.reviewStatus,
      this.dueDate,
      required this.intervalDays,
      required this.easeFactor,
      required this.reviewCount,
      required this.correctCount,
      required this.incorrectCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deck_id'] = Variable<String>(deckId);
    map['word'] = Variable<String>(word);
    map['meaning'] = Variable<String>(meaning);
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || pronunciation != null) {
      map['pronunciation'] = Variable<String>(pronunciation);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    map['review_status'] = Variable<String>(reviewStatus);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['review_count'] = Variable<int>(reviewCount);
    map['correct_count'] = Variable<int>(correctCount);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    return map;
  }

  CardTableCompanion toCompanion(bool nullToAbsent) {
    return CardTableCompanion(
      id: Value(id),
      deckId: Value(deckId),
      word: Value(word),
      meaning: Value(meaning),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      pronunciation: pronunciation == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciation),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      reviewStatus: Value(reviewStatus),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      intervalDays: Value(intervalDays),
      easeFactor: Value(easeFactor),
      reviewCount: Value(reviewCount),
      correctCount: Value(correctCount),
      incorrectCount: Value(incorrectCount),
    );
  }

  factory CardTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardTableData(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      word: serializer.fromJson<String>(json['word']),
      meaning: serializer.fromJson<String>(json['meaning']),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      pronunciation: serializer.fromJson<String?>(json['pronunciation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'word': serializer.toJson<String>(word),
      'meaning': serializer.toJson<String>(meaning),
      'transliteration': serializer.toJson<String?>(transliteration),
      'pronunciation': serializer.toJson<String?>(pronunciation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'correctCount': serializer.toJson<int>(correctCount),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
    };
  }

  CardTableData copyWith(
          {String? id,
          String? deckId,
          String? word,
          String? meaning,
          Value<String?> transliteration = const Value.absent(),
          Value<String?> pronunciation = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastReviewedAt = const Value.absent(),
          String? reviewStatus,
          Value<DateTime?> dueDate = const Value.absent(),
          int? intervalDays,
          double? easeFactor,
          int? reviewCount,
          int? correctCount,
          int? incorrectCount}) =>
      CardTableData(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        word: word ?? this.word,
        meaning: meaning ?? this.meaning,
        transliteration: transliteration.present
            ? transliteration.value
            : this.transliteration,
        pronunciation:
            pronunciation.present ? pronunciation.value : this.pronunciation,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
        reviewStatus: reviewStatus ?? this.reviewStatus,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        intervalDays: intervalDays ?? this.intervalDays,
        easeFactor: easeFactor ?? this.easeFactor,
        reviewCount: reviewCount ?? this.reviewCount,
        correctCount: correctCount ?? this.correctCount,
        incorrectCount: incorrectCount ?? this.incorrectCount,
      );
  CardTableData copyWithCompanion(CardTableCompanion data) {
    return CardTableData(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      word: data.word.present ? data.word.value : this.word,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      pronunciation: data.pronunciation.present
          ? data.pronunciation.value
          : this.pronunciation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      incorrectCount: data.incorrectCount.present
          ? data.incorrectCount.value
          : this.incorrectCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardTableData(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('word: $word, ')
          ..write('meaning: $meaning, ')
          ..write('transliteration: $transliteration, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('dueDate: $dueDate, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      deckId,
      word,
      meaning,
      transliteration,
      pronunciation,
      createdAt,
      updatedAt,
      lastReviewedAt,
      reviewStatus,
      dueDate,
      intervalDays,
      easeFactor,
      reviewCount,
      correctCount,
      incorrectCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardTableData &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.word == this.word &&
          other.meaning == this.meaning &&
          other.transliteration == this.transliteration &&
          other.pronunciation == this.pronunciation &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.reviewStatus == this.reviewStatus &&
          other.dueDate == this.dueDate &&
          other.intervalDays == this.intervalDays &&
          other.easeFactor == this.easeFactor &&
          other.reviewCount == this.reviewCount &&
          other.correctCount == this.correctCount &&
          other.incorrectCount == this.incorrectCount);
}

class CardTableCompanion extends UpdateCompanion<CardTableData> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<String> word;
  final Value<String> meaning;
  final Value<String?> transliteration;
  final Value<String?> pronunciation;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<String> reviewStatus;
  final Value<DateTime?> dueDate;
  final Value<int> intervalDays;
  final Value<double> easeFactor;
  final Value<int> reviewCount;
  final Value<int> correctCount;
  final Value<int> incorrectCount;
  final Value<int> rowid;
  const CardTableCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.word = const Value.absent(),
    this.meaning = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardTableCompanion.insert({
    required String id,
    required String deckId,
    required String word,
    required String meaning,
    this.transliteration = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        deckId = Value(deckId),
        word = Value(word),
        meaning = Value(meaning);
  static Insertable<CardTableData> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<String>? word,
    Expression<String>? meaning,
    Expression<String>? transliteration,
    Expression<String>? pronunciation,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<String>? reviewStatus,
    Expression<DateTime>? dueDate,
    Expression<int>? intervalDays,
    Expression<double>? easeFactor,
    Expression<int>? reviewCount,
    Expression<int>? correctCount,
    Expression<int>? incorrectCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (word != null) 'word': word,
      if (meaning != null) 'meaning': meaning,
      if (transliteration != null) 'transliteration': transliteration,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (dueDate != null) 'due_date': dueDate,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (reviewCount != null) 'review_count': reviewCount,
      if (correctCount != null) 'correct_count': correctCount,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? deckId,
      Value<String>? word,
      Value<String>? meaning,
      Value<String?>? transliteration,
      Value<String?>? pronunciation,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastReviewedAt,
      Value<String>? reviewStatus,
      Value<DateTime?>? dueDate,
      Value<int>? intervalDays,
      Value<double>? easeFactor,
      Value<int>? reviewCount,
      Value<int>? correctCount,
      Value<int>? incorrectCount,
      Value<int>? rowid}) {
    return CardTableCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      transliteration: transliteration ?? this.transliteration,
      pronunciation: pronunciation ?? this.pronunciation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      dueDate: dueDate ?? this.dueDate,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (pronunciation.present) {
      map['pronunciation'] = Variable<String>(pronunciation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardTableCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('word: $word, ')
          ..write('meaning: $meaning, ')
          ..write('transliteration: $transliteration, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('dueDate: $dueDate, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewEventTableTable extends ReviewEventTable
    with TableInfo<$ReviewEventTableTable, ReviewEventTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewEventTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cards (id)'));
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES decks (id)'));
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<String> rating = GeneratedColumn<String>(
      'rating', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _previousIntervalDaysMeta =
      const VerificationMeta('previousIntervalDays');
  @override
  late final GeneratedColumn<int> previousIntervalDays = GeneratedColumn<int>(
      'previous_interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _newIntervalDaysMeta =
      const VerificationMeta('newIntervalDays');
  @override
  late final GeneratedColumn<int> newIntervalDays = GeneratedColumn<int>(
      'new_interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _previousEaseFactorMeta =
      const VerificationMeta('previousEaseFactor');
  @override
  late final GeneratedColumn<double> previousEaseFactor =
      GeneratedColumn<double>('previous_ease_factor', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(2.5));
  static const VerificationMeta _newEaseFactorMeta =
      const VerificationMeta('newEaseFactor');
  @override
  late final GeneratedColumn<double> newEaseFactor = GeneratedColumn<double>(
      'new_ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _responseTimeMsMeta =
      const VerificationMeta('responseTimeMs');
  @override
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
      'response_time_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cardId,
        deckId,
        rating,
        reviewedAt,
        previousIntervalDays,
        newIntervalDays,
        previousEaseFactor,
        newEaseFactor,
        responseTimeMs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_events';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReviewEventTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    }
    if (data.containsKey('previous_interval_days')) {
      context.handle(
          _previousIntervalDaysMeta,
          previousIntervalDays.isAcceptableOrUnknown(
              data['previous_interval_days']!, _previousIntervalDaysMeta));
    }
    if (data.containsKey('new_interval_days')) {
      context.handle(
          _newIntervalDaysMeta,
          newIntervalDays.isAcceptableOrUnknown(
              data['new_interval_days']!, _newIntervalDaysMeta));
    }
    if (data.containsKey('previous_ease_factor')) {
      context.handle(
          _previousEaseFactorMeta,
          previousEaseFactor.isAcceptableOrUnknown(
              data['previous_ease_factor']!, _previousEaseFactorMeta));
    }
    if (data.containsKey('new_ease_factor')) {
      context.handle(
          _newEaseFactorMeta,
          newEaseFactor.isAcceptableOrUnknown(
              data['new_ease_factor']!, _newEaseFactorMeta));
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
          _responseTimeMsMeta,
          responseTimeMs.isAcceptableOrUnknown(
              data['response_time_ms']!, _responseTimeMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewEventTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewEventTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      deckId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rating'])!,
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at'])!,
      previousIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}previous_interval_days'])!,
      newIntervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_interval_days'])!,
      previousEaseFactor: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}previous_ease_factor'])!,
      newEaseFactor: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}new_ease_factor'])!,
      responseTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}response_time_ms'])!,
    );
  }

  @override
  $ReviewEventTableTable createAlias(String alias) {
    return $ReviewEventTableTable(attachedDatabase, alias);
  }
}

class ReviewEventTableData extends DataClass
    implements Insertable<ReviewEventTableData> {
  final String id;
  final String cardId;
  final String deckId;
  final String rating;
  final DateTime reviewedAt;
  final int previousIntervalDays;
  final int newIntervalDays;
  final double previousEaseFactor;
  final double newEaseFactor;
  final int responseTimeMs;
  const ReviewEventTableData(
      {required this.id,
      required this.cardId,
      required this.deckId,
      required this.rating,
      required this.reviewedAt,
      required this.previousIntervalDays,
      required this.newIntervalDays,
      required this.previousEaseFactor,
      required this.newEaseFactor,
      required this.responseTimeMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['deck_id'] = Variable<String>(deckId);
    map['rating'] = Variable<String>(rating);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    map['previous_interval_days'] = Variable<int>(previousIntervalDays);
    map['new_interval_days'] = Variable<int>(newIntervalDays);
    map['previous_ease_factor'] = Variable<double>(previousEaseFactor);
    map['new_ease_factor'] = Variable<double>(newEaseFactor);
    map['response_time_ms'] = Variable<int>(responseTimeMs);
    return map;
  }

  ReviewEventTableCompanion toCompanion(bool nullToAbsent) {
    return ReviewEventTableCompanion(
      id: Value(id),
      cardId: Value(cardId),
      deckId: Value(deckId),
      rating: Value(rating),
      reviewedAt: Value(reviewedAt),
      previousIntervalDays: Value(previousIntervalDays),
      newIntervalDays: Value(newIntervalDays),
      previousEaseFactor: Value(previousEaseFactor),
      newEaseFactor: Value(newEaseFactor),
      responseTimeMs: Value(responseTimeMs),
    );
  }

  factory ReviewEventTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewEventTableData(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      deckId: serializer.fromJson<String>(json['deckId']),
      rating: serializer.fromJson<String>(json['rating']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      previousIntervalDays:
          serializer.fromJson<int>(json['previousIntervalDays']),
      newIntervalDays: serializer.fromJson<int>(json['newIntervalDays']),
      previousEaseFactor:
          serializer.fromJson<double>(json['previousEaseFactor']),
      newEaseFactor: serializer.fromJson<double>(json['newEaseFactor']),
      responseTimeMs: serializer.fromJson<int>(json['responseTimeMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'deckId': serializer.toJson<String>(deckId),
      'rating': serializer.toJson<String>(rating),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'previousIntervalDays': serializer.toJson<int>(previousIntervalDays),
      'newIntervalDays': serializer.toJson<int>(newIntervalDays),
      'previousEaseFactor': serializer.toJson<double>(previousEaseFactor),
      'newEaseFactor': serializer.toJson<double>(newEaseFactor),
      'responseTimeMs': serializer.toJson<int>(responseTimeMs),
    };
  }

  ReviewEventTableData copyWith(
          {String? id,
          String? cardId,
          String? deckId,
          String? rating,
          DateTime? reviewedAt,
          int? previousIntervalDays,
          int? newIntervalDays,
          double? previousEaseFactor,
          double? newEaseFactor,
          int? responseTimeMs}) =>
      ReviewEventTableData(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        deckId: deckId ?? this.deckId,
        rating: rating ?? this.rating,
        reviewedAt: reviewedAt ?? this.reviewedAt,
        previousIntervalDays: previousIntervalDays ?? this.previousIntervalDays,
        newIntervalDays: newIntervalDays ?? this.newIntervalDays,
        previousEaseFactor: previousEaseFactor ?? this.previousEaseFactor,
        newEaseFactor: newEaseFactor ?? this.newEaseFactor,
        responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      );
  ReviewEventTableData copyWithCompanion(ReviewEventTableCompanion data) {
    return ReviewEventTableData(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
      previousIntervalDays: data.previousIntervalDays.present
          ? data.previousIntervalDays.value
          : this.previousIntervalDays,
      newIntervalDays: data.newIntervalDays.present
          ? data.newIntervalDays.value
          : this.newIntervalDays,
      previousEaseFactor: data.previousEaseFactor.present
          ? data.previousEaseFactor.value
          : this.previousEaseFactor,
      newEaseFactor: data.newEaseFactor.present
          ? data.newEaseFactor.value
          : this.newEaseFactor,
      responseTimeMs: data.responseTimeMs.present
          ? data.responseTimeMs.value
          : this.responseTimeMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventTableData(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('deckId: $deckId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('previousIntervalDays: $previousIntervalDays, ')
          ..write('newIntervalDays: $newIntervalDays, ')
          ..write('previousEaseFactor: $previousEaseFactor, ')
          ..write('newEaseFactor: $newEaseFactor, ')
          ..write('responseTimeMs: $responseTimeMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cardId,
      deckId,
      rating,
      reviewedAt,
      previousIntervalDays,
      newIntervalDays,
      previousEaseFactor,
      newEaseFactor,
      responseTimeMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewEventTableData &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.deckId == this.deckId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.previousIntervalDays == this.previousIntervalDays &&
          other.newIntervalDays == this.newIntervalDays &&
          other.previousEaseFactor == this.previousEaseFactor &&
          other.newEaseFactor == this.newEaseFactor &&
          other.responseTimeMs == this.responseTimeMs);
}

class ReviewEventTableCompanion extends UpdateCompanion<ReviewEventTableData> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> deckId;
  final Value<String> rating;
  final Value<DateTime> reviewedAt;
  final Value<int> previousIntervalDays;
  final Value<int> newIntervalDays;
  final Value<double> previousEaseFactor;
  final Value<double> newEaseFactor;
  final Value<int> responseTimeMs;
  final Value<int> rowid;
  const ReviewEventTableCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.deckId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.previousIntervalDays = const Value.absent(),
    this.newIntervalDays = const Value.absent(),
    this.previousEaseFactor = const Value.absent(),
    this.newEaseFactor = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewEventTableCompanion.insert({
    required String id,
    required String cardId,
    required String deckId,
    required String rating,
    this.reviewedAt = const Value.absent(),
    this.previousIntervalDays = const Value.absent(),
    this.newIntervalDays = const Value.absent(),
    this.previousEaseFactor = const Value.absent(),
    this.newEaseFactor = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cardId = Value(cardId),
        deckId = Value(deckId),
        rating = Value(rating);
  static Insertable<ReviewEventTableData> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? deckId,
    Expression<String>? rating,
    Expression<DateTime>? reviewedAt,
    Expression<int>? previousIntervalDays,
    Expression<int>? newIntervalDays,
    Expression<double>? previousEaseFactor,
    Expression<double>? newEaseFactor,
    Expression<int>? responseTimeMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (deckId != null) 'deck_id': deckId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (previousIntervalDays != null)
        'previous_interval_days': previousIntervalDays,
      if (newIntervalDays != null) 'new_interval_days': newIntervalDays,
      if (previousEaseFactor != null)
        'previous_ease_factor': previousEaseFactor,
      if (newEaseFactor != null) 'new_ease_factor': newEaseFactor,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewEventTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? cardId,
      Value<String>? deckId,
      Value<String>? rating,
      Value<DateTime>? reviewedAt,
      Value<int>? previousIntervalDays,
      Value<int>? newIntervalDays,
      Value<double>? previousEaseFactor,
      Value<double>? newEaseFactor,
      Value<int>? responseTimeMs,
      Value<int>? rowid}) {
    return ReviewEventTableCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      deckId: deckId ?? this.deckId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      previousIntervalDays: previousIntervalDays ?? this.previousIntervalDays,
      newIntervalDays: newIntervalDays ?? this.newIntervalDays,
      previousEaseFactor: previousEaseFactor ?? this.previousEaseFactor,
      newEaseFactor: newEaseFactor ?? this.newEaseFactor,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<String>(rating.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (previousIntervalDays.present) {
      map['previous_interval_days'] = Variable<int>(previousIntervalDays.value);
    }
    if (newIntervalDays.present) {
      map['new_interval_days'] = Variable<int>(newIntervalDays.value);
    }
    if (previousEaseFactor.present) {
      map['previous_ease_factor'] = Variable<double>(previousEaseFactor.value);
    }
    if (newEaseFactor.present) {
      map['new_ease_factor'] = Variable<double>(newEaseFactor.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventTableCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('deckId: $deckId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('previousIntervalDays: $previousIntervalDays, ')
          ..write('newIntervalDays: $newIntervalDays, ')
          ..write('previousEaseFactor: $previousEaseFactor, ')
          ..write('newEaseFactor: $newEaseFactor, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudySessionTableTable extends StudySessionTable
    with TableInfo<$StudySessionTableTable, StudySessionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES decks (id)'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _cardsStudiedMeta =
      const VerificationMeta('cardsStudied');
  @override
  late final GeneratedColumn<int> cardsStudied = GeneratedColumn<int>(
      'cards_studied', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _incorrectCountMeta =
      const VerificationMeta('incorrectCount');
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
      'incorrect_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deckId,
        startedAt,
        endedAt,
        cardsStudied,
        correctCount,
        incorrectCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_sessions';
  @override
  VerificationContext validateIntegrity(
      Insertable<StudySessionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    if (data.containsKey('cards_studied')) {
      context.handle(
          _cardsStudiedMeta,
          cardsStudied.isAcceptableOrUnknown(
              data['cards_studied']!, _cardsStudiedMeta));
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
          _incorrectCountMeta,
          incorrectCount.isAcceptableOrUnknown(
              data['incorrect_count']!, _incorrectCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySessionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySessionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
      cardsStudied: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cards_studied'])!,
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
      incorrectCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incorrect_count'])!,
    );
  }

  @override
  $StudySessionTableTable createAlias(String alias) {
    return $StudySessionTableTable(attachedDatabase, alias);
  }
}

class StudySessionTableData extends DataClass
    implements Insertable<StudySessionTableData> {
  final String id;
  final String deckId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int cardsStudied;
  final int correctCount;
  final int incorrectCount;
  const StudySessionTableData(
      {required this.id,
      required this.deckId,
      required this.startedAt,
      this.endedAt,
      required this.cardsStudied,
      required this.correctCount,
      required this.incorrectCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deck_id'] = Variable<String>(deckId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['cards_studied'] = Variable<int>(cardsStudied);
    map['correct_count'] = Variable<int>(correctCount);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    return map;
  }

  StudySessionTableCompanion toCompanion(bool nullToAbsent) {
    return StudySessionTableCompanion(
      id: Value(id),
      deckId: Value(deckId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      cardsStudied: Value(cardsStudied),
      correctCount: Value(correctCount),
      incorrectCount: Value(incorrectCount),
    );
  }

  factory StudySessionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySessionTableData(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      cardsStudied: serializer.fromJson<int>(json['cardsStudied']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'cardsStudied': serializer.toJson<int>(cardsStudied),
      'correctCount': serializer.toJson<int>(correctCount),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
    };
  }

  StudySessionTableData copyWith(
          {String? id,
          String? deckId,
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent(),
          int? cardsStudied,
          int? correctCount,
          int? incorrectCount}) =>
      StudySessionTableData(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
        cardsStudied: cardsStudied ?? this.cardsStudied,
        correctCount: correctCount ?? this.correctCount,
        incorrectCount: incorrectCount ?? this.incorrectCount,
      );
  StudySessionTableData copyWithCompanion(StudySessionTableCompanion data) {
    return StudySessionTableData(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      cardsStudied: data.cardsStudied.present
          ? data.cardsStudied.value
          : this.cardsStudied,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      incorrectCount: data.incorrectCount.present
          ? data.incorrectCount.value
          : this.incorrectCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionTableData(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('cardsStudied: $cardsStudied, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deckId, startedAt, endedAt, cardsStudied,
      correctCount, incorrectCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionTableData &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.cardsStudied == this.cardsStudied &&
          other.correctCount == this.correctCount &&
          other.incorrectCount == this.incorrectCount);
}

class StudySessionTableCompanion
    extends UpdateCompanion<StudySessionTableData> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> cardsStudied;
  final Value<int> correctCount;
  final Value<int> incorrectCount;
  final Value<int> rowid;
  const StudySessionTableCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.cardsStudied = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionTableCompanion.insert({
    required String id,
    required String deckId,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.cardsStudied = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        deckId = Value(deckId);
  static Insertable<StudySessionTableData> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? cardsStudied,
    Expression<int>? correctCount,
    Expression<int>? incorrectCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (cardsStudied != null) 'cards_studied': cardsStudied,
      if (correctCount != null) 'correct_count': correctCount,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? deckId,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? cardsStudied,
      Value<int>? correctCount,
      Value<int>? incorrectCount,
      Value<int>? rowid}) {
    return StudySessionTableCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      cardsStudied: cardsStudied ?? this.cardsStudied,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (cardsStudied.present) {
      map['cards_studied'] = Variable<int>(cardsStudied.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionTableCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('cardsStudied: $cardsStudied, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$HakiDatabase extends GeneratedDatabase {
  _$HakiDatabase(QueryExecutor e) : super(e);
  $HakiDatabaseManager get managers => $HakiDatabaseManager(this);
  late final $DeckTableTable deckTable = $DeckTableTable(this);
  late final $CardTableTable cardTable = $CardTableTable(this);
  late final $ReviewEventTableTable reviewEventTable =
      $ReviewEventTableTable(this);
  late final $StudySessionTableTable studySessionTable =
      $StudySessionTableTable(this);
  late final DeckDao deckDao = DeckDao(this as HakiDatabase);
  late final CardDao cardDao = CardDao(this as HakiDatabase);
  late final ReviewDao reviewDao = ReviewDao(this as HakiDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [deckTable, cardTable, reviewEventTable, studySessionTable];
}

typedef $$DeckTableTableCreateCompanionBuilder = DeckTableCompanion Function({
  required String id,
  required String name,
  Value<String?> sourceLanguage,
  Value<String?> targetLanguage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastStudiedAt,
  Value<int> rowid,
});
typedef $$DeckTableTableUpdateCompanionBuilder = DeckTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> sourceLanguage,
  Value<String?> targetLanguage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastStudiedAt,
  Value<int> rowid,
});

class $$DeckTableTableTableManager extends RootTableManager<
    _$HakiDatabase,
    $DeckTableTable,
    DeckTableData,
    $$DeckTableTableFilterComposer,
    $$DeckTableTableOrderingComposer,
    $$DeckTableTableCreateCompanionBuilder,
    $$DeckTableTableUpdateCompanionBuilder> {
  $$DeckTableTableTableManager(_$HakiDatabase db, $DeckTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DeckTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DeckTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> sourceLanguage = const Value.absent(),
            Value<String?> targetLanguage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastStudiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeckTableCompanion(
            id: id,
            name: name,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastStudiedAt: lastStudiedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> sourceLanguage = const Value.absent(),
            Value<String?> targetLanguage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastStudiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeckTableCompanion.insert(
            id: id,
            name: name,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastStudiedAt: lastStudiedAt,
            rowid: rowid,
          ),
        ));
}

class $$DeckTableTableFilterComposer
    extends FilterComposer<_$HakiDatabase, $DeckTableTable> {
  $$DeckTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceLanguage => $state.composableBuilder(
      column: $state.table.sourceLanguage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get targetLanguage => $state.composableBuilder(
      column: $state.table.targetLanguage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastStudiedAt => $state.composableBuilder(
      column: $state.table.lastStudiedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter cardTableRefs(
      ComposableFilter Function($$CardTableTableFilterComposer f) f) {
    final $$CardTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.cardTable,
        getReferencedColumn: (t) => t.deckId,
        builder: (joinBuilder, parentComposers) =>
            $$CardTableTableFilterComposer(ComposerState(
                $state.db, $state.db.cardTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter reviewEventTableRefs(
      ComposableFilter Function($$ReviewEventTableTableFilterComposer f) f) {
    final $$ReviewEventTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.reviewEventTable,
            getReferencedColumn: (t) => t.deckId,
            builder: (joinBuilder, parentComposers) =>
                $$ReviewEventTableTableFilterComposer(ComposerState($state.db,
                    $state.db.reviewEventTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter studySessionTableRefs(
      ComposableFilter Function($$StudySessionTableTableFilterComposer f) f) {
    final $$StudySessionTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.studySessionTable,
            getReferencedColumn: (t) => t.deckId,
            builder: (joinBuilder, parentComposers) =>
                $$StudySessionTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.studySessionTable,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$DeckTableTableOrderingComposer
    extends OrderingComposer<_$HakiDatabase, $DeckTableTable> {
  $$DeckTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceLanguage => $state.composableBuilder(
      column: $state.table.sourceLanguage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get targetLanguage => $state.composableBuilder(
      column: $state.table.targetLanguage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastStudiedAt => $state.composableBuilder(
      column: $state.table.lastStudiedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CardTableTableCreateCompanionBuilder = CardTableCompanion Function({
  required String id,
  required String deckId,
  required String word,
  required String meaning,
  Value<String?> transliteration,
  Value<String?> pronunciation,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewedAt,
  Value<String> reviewStatus,
  Value<DateTime?> dueDate,
  Value<int> intervalDays,
  Value<double> easeFactor,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> incorrectCount,
  Value<int> rowid,
});
typedef $$CardTableTableUpdateCompanionBuilder = CardTableCompanion Function({
  Value<String> id,
  Value<String> deckId,
  Value<String> word,
  Value<String> meaning,
  Value<String?> transliteration,
  Value<String?> pronunciation,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewedAt,
  Value<String> reviewStatus,
  Value<DateTime?> dueDate,
  Value<int> intervalDays,
  Value<double> easeFactor,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> incorrectCount,
  Value<int> rowid,
});

class $$CardTableTableTableManager extends RootTableManager<
    _$HakiDatabase,
    $CardTableTable,
    CardTableData,
    $$CardTableTableFilterComposer,
    $$CardTableTableOrderingComposer,
    $$CardTableTableCreateCompanionBuilder,
    $$CardTableTableUpdateCompanionBuilder> {
  $$CardTableTableTableManager(_$HakiDatabase db, $CardTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CardTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CardTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> deckId = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String> meaning = const Value.absent(),
            Value<String?> transliteration = const Value.absent(),
            Value<String?> pronunciation = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<String> reviewStatus = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> incorrectCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardTableCompanion(
            id: id,
            deckId: deckId,
            word: word,
            meaning: meaning,
            transliteration: transliteration,
            pronunciation: pronunciation,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewedAt: lastReviewedAt,
            reviewStatus: reviewStatus,
            dueDate: dueDate,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            reviewCount: reviewCount,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String deckId,
            required String word,
            required String meaning,
            Value<String?> transliteration = const Value.absent(),
            Value<String?> pronunciation = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<String> reviewStatus = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> incorrectCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardTableCompanion.insert(
            id: id,
            deckId: deckId,
            word: word,
            meaning: meaning,
            transliteration: transliteration,
            pronunciation: pronunciation,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewedAt: lastReviewedAt,
            reviewStatus: reviewStatus,
            dueDate: dueDate,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            reviewCount: reviewCount,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            rowid: rowid,
          ),
        ));
}

class $$CardTableTableFilterComposer
    extends FilterComposer<_$HakiDatabase, $CardTableTable> {
  $$CardTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get word => $state.composableBuilder(
      column: $state.table.word,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get meaning => $state.composableBuilder(
      column: $state.table.meaning,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get transliteration => $state.composableBuilder(
      column: $state.table.transliteration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pronunciation => $state.composableBuilder(
      column: $state.table.pronunciation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastReviewedAt => $state.composableBuilder(
      column: $state.table.lastReviewedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reviewStatus => $state.composableBuilder(
      column: $state.table.reviewStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get easeFactor => $state.composableBuilder(
      column: $state.table.easeFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reviewCount => $state.composableBuilder(
      column: $state.table.reviewCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get correctCount => $state.composableBuilder(
      column: $state.table.correctCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get incorrectCount => $state.composableBuilder(
      column: $state.table.incorrectCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$DeckTableTableFilterComposer get deckId {
    final $$DeckTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deckId,
        referencedTable: $state.db.deckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$DeckTableTableFilterComposer(ComposerState(
                $state.db, $state.db.deckTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter reviewEventTableRefs(
      ComposableFilter Function($$ReviewEventTableTableFilterComposer f) f) {
    final $$ReviewEventTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.reviewEventTable,
            getReferencedColumn: (t) => t.cardId,
            builder: (joinBuilder, parentComposers) =>
                $$ReviewEventTableTableFilterComposer(ComposerState($state.db,
                    $state.db.reviewEventTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CardTableTableOrderingComposer
    extends OrderingComposer<_$HakiDatabase, $CardTableTable> {
  $$CardTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get word => $state.composableBuilder(
      column: $state.table.word,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get meaning => $state.composableBuilder(
      column: $state.table.meaning,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get transliteration => $state.composableBuilder(
      column: $state.table.transliteration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pronunciation => $state.composableBuilder(
      column: $state.table.pronunciation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastReviewedAt => $state.composableBuilder(
      column: $state.table.lastReviewedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reviewStatus => $state.composableBuilder(
      column: $state.table.reviewStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get easeFactor => $state.composableBuilder(
      column: $state.table.easeFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reviewCount => $state.composableBuilder(
      column: $state.table.reviewCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get correctCount => $state.composableBuilder(
      column: $state.table.correctCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get incorrectCount => $state.composableBuilder(
      column: $state.table.incorrectCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$DeckTableTableOrderingComposer get deckId {
    final $$DeckTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deckId,
        referencedTable: $state.db.deckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$DeckTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.deckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ReviewEventTableTableCreateCompanionBuilder
    = ReviewEventTableCompanion Function({
  required String id,
  required String cardId,
  required String deckId,
  required String rating,
  Value<DateTime> reviewedAt,
  Value<int> previousIntervalDays,
  Value<int> newIntervalDays,
  Value<double> previousEaseFactor,
  Value<double> newEaseFactor,
  Value<int> responseTimeMs,
  Value<int> rowid,
});
typedef $$ReviewEventTableTableUpdateCompanionBuilder
    = ReviewEventTableCompanion Function({
  Value<String> id,
  Value<String> cardId,
  Value<String> deckId,
  Value<String> rating,
  Value<DateTime> reviewedAt,
  Value<int> previousIntervalDays,
  Value<int> newIntervalDays,
  Value<double> previousEaseFactor,
  Value<double> newEaseFactor,
  Value<int> responseTimeMs,
  Value<int> rowid,
});

class $$ReviewEventTableTableTableManager extends RootTableManager<
    _$HakiDatabase,
    $ReviewEventTableTable,
    ReviewEventTableData,
    $$ReviewEventTableTableFilterComposer,
    $$ReviewEventTableTableOrderingComposer,
    $$ReviewEventTableTableCreateCompanionBuilder,
    $$ReviewEventTableTableUpdateCompanionBuilder> {
  $$ReviewEventTableTableTableManager(
      _$HakiDatabase db, $ReviewEventTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ReviewEventTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ReviewEventTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<String> deckId = const Value.absent(),
            Value<String> rating = const Value.absent(),
            Value<DateTime> reviewedAt = const Value.absent(),
            Value<int> previousIntervalDays = const Value.absent(),
            Value<int> newIntervalDays = const Value.absent(),
            Value<double> previousEaseFactor = const Value.absent(),
            Value<double> newEaseFactor = const Value.absent(),
            Value<int> responseTimeMs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewEventTableCompanion(
            id: id,
            cardId: cardId,
            deckId: deckId,
            rating: rating,
            reviewedAt: reviewedAt,
            previousIntervalDays: previousIntervalDays,
            newIntervalDays: newIntervalDays,
            previousEaseFactor: previousEaseFactor,
            newEaseFactor: newEaseFactor,
            responseTimeMs: responseTimeMs,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cardId,
            required String deckId,
            required String rating,
            Value<DateTime> reviewedAt = const Value.absent(),
            Value<int> previousIntervalDays = const Value.absent(),
            Value<int> newIntervalDays = const Value.absent(),
            Value<double> previousEaseFactor = const Value.absent(),
            Value<double> newEaseFactor = const Value.absent(),
            Value<int> responseTimeMs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewEventTableCompanion.insert(
            id: id,
            cardId: cardId,
            deckId: deckId,
            rating: rating,
            reviewedAt: reviewedAt,
            previousIntervalDays: previousIntervalDays,
            newIntervalDays: newIntervalDays,
            previousEaseFactor: previousEaseFactor,
            newEaseFactor: newEaseFactor,
            responseTimeMs: responseTimeMs,
            rowid: rowid,
          ),
        ));
}

class $$ReviewEventTableTableFilterComposer
    extends FilterComposer<_$HakiDatabase, $ReviewEventTableTable> {
  $$ReviewEventTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rating => $state.composableBuilder(
      column: $state.table.rating,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get reviewedAt => $state.composableBuilder(
      column: $state.table.reviewedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get previousIntervalDays => $state.composableBuilder(
      column: $state.table.previousIntervalDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get newIntervalDays => $state.composableBuilder(
      column: $state.table.newIntervalDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get previousEaseFactor => $state.composableBuilder(
      column: $state.table.previousEaseFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get newEaseFactor => $state.composableBuilder(
      column: $state.table.newEaseFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get responseTimeMs => $state.composableBuilder(
      column: $state.table.responseTimeMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CardTableTableFilterComposer get cardId {
    final $$CardTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $state.db.cardTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CardTableTableFilterComposer(ComposerState(
                $state.db, $state.db.cardTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$DeckTableTableFilterComposer get deckId {
    final $$DeckTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deckId,
        referencedTable: $state.db.deckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$DeckTableTableFilterComposer(ComposerState(
                $state.db, $state.db.deckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ReviewEventTableTableOrderingComposer
    extends OrderingComposer<_$HakiDatabase, $ReviewEventTableTable> {
  $$ReviewEventTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rating => $state.composableBuilder(
      column: $state.table.rating,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get reviewedAt => $state.composableBuilder(
      column: $state.table.reviewedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get previousIntervalDays => $state.composableBuilder(
      column: $state.table.previousIntervalDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get newIntervalDays => $state.composableBuilder(
      column: $state.table.newIntervalDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get previousEaseFactor => $state.composableBuilder(
      column: $state.table.previousEaseFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get newEaseFactor => $state.composableBuilder(
      column: $state.table.newEaseFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get responseTimeMs => $state.composableBuilder(
      column: $state.table.responseTimeMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CardTableTableOrderingComposer get cardId {
    final $$CardTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $state.db.cardTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CardTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.cardTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$DeckTableTableOrderingComposer get deckId {
    final $$DeckTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deckId,
        referencedTable: $state.db.deckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$DeckTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.deckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$StudySessionTableTableCreateCompanionBuilder
    = StudySessionTableCompanion Function({
  required String id,
  required String deckId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> cardsStudied,
  Value<int> correctCount,
  Value<int> incorrectCount,
  Value<int> rowid,
});
typedef $$StudySessionTableTableUpdateCompanionBuilder
    = StudySessionTableCompanion Function({
  Value<String> id,
  Value<String> deckId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> cardsStudied,
  Value<int> correctCount,
  Value<int> incorrectCount,
  Value<int> rowid,
});

class $$StudySessionTableTableTableManager extends RootTableManager<
    _$HakiDatabase,
    $StudySessionTableTable,
    StudySessionTableData,
    $$StudySessionTableTableFilterComposer,
    $$StudySessionTableTableOrderingComposer,
    $$StudySessionTableTableCreateCompanionBuilder,
    $$StudySessionTableTableUpdateCompanionBuilder> {
  $$StudySessionTableTableTableManager(
      _$HakiDatabase db, $StudySessionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StudySessionTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$StudySessionTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> deckId = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> cardsStudied = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> incorrectCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudySessionTableCompanion(
            id: id,
            deckId: deckId,
            startedAt: startedAt,
            endedAt: endedAt,
            cardsStudied: cardsStudied,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String deckId,
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> cardsStudied = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> incorrectCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudySessionTableCompanion.insert(
            id: id,
            deckId: deckId,
            startedAt: startedAt,
            endedAt: endedAt,
            cardsStudied: cardsStudied,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            rowid: rowid,
          ),
        ));
}

class $$StudySessionTableTableFilterComposer
    extends FilterComposer<_$HakiDatabase, $StudySessionTableTable> {
  $$StudySessionTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get endedAt => $state.composableBuilder(
      column: $state.table.endedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get cardsStudied => $state.composableBuilder(
      column: $state.table.cardsStudied,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get correctCount => $state.composableBuilder(
      column: $state.table.correctCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get incorrectCount => $state.composableBuilder(
      column: $state.table.incorrectCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$DeckTableTableFilterComposer get deckId {
    final $$DeckTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deckId,
        referencedTable: $state.db.deckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$DeckTableTableFilterComposer(ComposerState(
                $state.db, $state.db.deckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$StudySessionTableTableOrderingComposer
    extends OrderingComposer<_$HakiDatabase, $StudySessionTableTable> {
  $$StudySessionTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get endedAt => $state.composableBuilder(
      column: $state.table.endedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get cardsStudied => $state.composableBuilder(
      column: $state.table.cardsStudied,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get correctCount => $state.composableBuilder(
      column: $state.table.correctCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get incorrectCount => $state.composableBuilder(
      column: $state.table.incorrectCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$DeckTableTableOrderingComposer get deckId {
    final $$DeckTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deckId,
        referencedTable: $state.db.deckTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$DeckTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.deckTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $HakiDatabaseManager {
  final _$HakiDatabase _db;
  $HakiDatabaseManager(this._db);
  $$DeckTableTableTableManager get deckTable =>
      $$DeckTableTableTableManager(_db, _db.deckTable);
  $$CardTableTableTableManager get cardTable =>
      $$CardTableTableTableManager(_db, _db.cardTable);
  $$ReviewEventTableTableTableManager get reviewEventTable =>
      $$ReviewEventTableTableTableManager(_db, _db.reviewEventTable);
  $$StudySessionTableTableTableManager get studySessionTable =>
      $$StudySessionTableTableTableManager(_db, _db.studySessionTable);
}
