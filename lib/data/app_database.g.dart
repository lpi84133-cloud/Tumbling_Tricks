// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TricksTable extends Tricks with TableInfo<$TricksTable, TrickRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TricksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Discipline, String> discipline =
      GeneratedColumn<String>(
        'discipline',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Discipline>($TricksTable.$converterdiscipline);
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    check: () => ComparableExpr(difficulty).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Mastery, String> mastery =
      GeneratedColumn<String>(
        'mastery',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(Mastery.learning.name),
      ).withConverter<Mastery>($TricksTable.$convertermastery);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _setupNoteMeta = const VerificationMeta(
    'setupNote',
  );
  @override
  late final GeneratedColumn<String> setupNote = GeneratedColumn<String>(
    'setup_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _safetyNoteMeta = const VerificationMeta(
    'safetyNote',
  );
  @override
  late final GeneratedColumn<String> safetyNote = GeneratedColumn<String>(
    'safety_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typicalSecondsMeta = const VerificationMeta(
    'typicalSeconds',
  );
  @override
  late final GeneratedColumn<int> typicalSeconds = GeneratedColumn<int>(
    'typical_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _isCatalogMeta = const VerificationMeta(
    'isCatalog',
  );
  @override
  late final GeneratedColumn<bool> isCatalog = GeneratedColumn<bool>(
    'is_catalog',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_catalog" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timesRehearsedMeta = const VerificationMeta(
    'timesRehearsed',
  );
  @override
  late final GeneratedColumn<int> timesRehearsed = GeneratedColumn<int>(
    'times_rehearsed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastRehearsedAtMeta = const VerificationMeta(
    'lastRehearsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRehearsedAt =
      GeneratedColumn<DateTime>(
        'last_rehearsed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _masteryDecayedAtMeta = const VerificationMeta(
    'masteryDecayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> masteryDecayedAt =
      GeneratedColumn<DateTime>(
        'mastery_decayed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    name,
    discipline,
    difficulty,
    mastery,
    summary,
    setupNote,
    safetyNote,
    typicalSeconds,
    isCatalog,
    isArchived,
    timesRehearsed,
    lastRehearsedAt,
    masteryDecayedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tricks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrickRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('setup_note')) {
      context.handle(
        _setupNoteMeta,
        setupNote.isAcceptableOrUnknown(data['setup_note']!, _setupNoteMeta),
      );
    }
    if (data.containsKey('safety_note')) {
      context.handle(
        _safetyNoteMeta,
        safetyNote.isAcceptableOrUnknown(data['safety_note']!, _safetyNoteMeta),
      );
    }
    if (data.containsKey('typical_seconds')) {
      context.handle(
        _typicalSecondsMeta,
        typicalSeconds.isAcceptableOrUnknown(
          data['typical_seconds']!,
          _typicalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_catalog')) {
      context.handle(
        _isCatalogMeta,
        isCatalog.isAcceptableOrUnknown(data['is_catalog']!, _isCatalogMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('times_rehearsed')) {
      context.handle(
        _timesRehearsedMeta,
        timesRehearsed.isAcceptableOrUnknown(
          data['times_rehearsed']!,
          _timesRehearsedMeta,
        ),
      );
    }
    if (data.containsKey('last_rehearsed_at')) {
      context.handle(
        _lastRehearsedAtMeta,
        lastRehearsedAt.isAcceptableOrUnknown(
          data['last_rehearsed_at']!,
          _lastRehearsedAtMeta,
        ),
      );
    }
    if (data.containsKey('mastery_decayed_at')) {
      context.handle(
        _masteryDecayedAtMeta,
        masteryDecayedAt.isAcceptableOrUnknown(
          data['mastery_decayed_at']!,
          _masteryDecayedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrickRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrickRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      discipline: $TricksTable.$converterdiscipline.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}discipline'],
        )!,
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      mastery: $TricksTable.$convertermastery.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mastery'],
        )!,
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      setupNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setup_note'],
      ),
      safetyNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}safety_note'],
      ),
      typicalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}typical_seconds'],
      )!,
      isCatalog: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_catalog'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      timesRehearsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_rehearsed'],
      )!,
      lastRehearsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_rehearsed_at'],
      ),
      masteryDecayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}mastery_decayed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TricksTable createAlias(String alias) {
    return $TricksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Discipline, String, String> $converterdiscipline =
      const EnumNameConverter<Discipline>(Discipline.values);
  static JsonTypeConverter2<Mastery, String, String> $convertermastery =
      const EnumNameConverter<Mastery>(Mastery.values);
}

class TrickRow extends DataClass implements Insertable<TrickRow> {
  final int id;

  /// Stable identifier for seeded entries, `null` for user-created tricks.
  /// Lets a later catalogue revision add material without duplicating rows.
  final String? slug;
  final String name;
  final Discipline discipline;

  /// 1 (foundational) to 5 (advanced).
  final int difficulty;
  final Mastery mastery;
  final String summary;

  /// What has to be in place before this can be attempted.
  final String? setupNote;

  /// Spotting, matting or rigging requirements. Surfaced prominently in the UI.
  final String? safetyNote;

  /// How long the trick usually takes on stage, in seconds.
  final int typicalSeconds;

  /// True for rows that came from the bundled catalogue.
  final bool isCatalog;
  final bool isArchived;
  final int timesRehearsed;
  final DateTime? lastRehearsedAt;

  /// Set when the mastery decay pass most recently downgraded this trick.
  /// Distinct from an explicit user rating so the "recently atrophied" list
  /// on the Stage Console can single out decay events without also flagging
  /// deliberate reclassifications.
  final DateTime? masteryDecayedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TrickRow({
    required this.id,
    this.slug,
    required this.name,
    required this.discipline,
    required this.difficulty,
    required this.mastery,
    required this.summary,
    this.setupNote,
    this.safetyNote,
    required this.typicalSeconds,
    required this.isCatalog,
    required this.isArchived,
    required this.timesRehearsed,
    this.lastRehearsedAt,
    this.masteryDecayedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || slug != null) {
      map['slug'] = Variable<String>(slug);
    }
    map['name'] = Variable<String>(name);
    {
      map['discipline'] = Variable<String>(
        $TricksTable.$converterdiscipline.toSql(discipline),
      );
    }
    map['difficulty'] = Variable<int>(difficulty);
    {
      map['mastery'] = Variable<String>(
        $TricksTable.$convertermastery.toSql(mastery),
      );
    }
    map['summary'] = Variable<String>(summary);
    if (!nullToAbsent || setupNote != null) {
      map['setup_note'] = Variable<String>(setupNote);
    }
    if (!nullToAbsent || safetyNote != null) {
      map['safety_note'] = Variable<String>(safetyNote);
    }
    map['typical_seconds'] = Variable<int>(typicalSeconds);
    map['is_catalog'] = Variable<bool>(isCatalog);
    map['is_archived'] = Variable<bool>(isArchived);
    map['times_rehearsed'] = Variable<int>(timesRehearsed);
    if (!nullToAbsent || lastRehearsedAt != null) {
      map['last_rehearsed_at'] = Variable<DateTime>(lastRehearsedAt);
    }
    if (!nullToAbsent || masteryDecayedAt != null) {
      map['mastery_decayed_at'] = Variable<DateTime>(masteryDecayedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TricksCompanion toCompanion(bool nullToAbsent) {
    return TricksCompanion(
      id: Value(id),
      slug: slug == null && nullToAbsent ? const Value.absent() : Value(slug),
      name: Value(name),
      discipline: Value(discipline),
      difficulty: Value(difficulty),
      mastery: Value(mastery),
      summary: Value(summary),
      setupNote: setupNote == null && nullToAbsent
          ? const Value.absent()
          : Value(setupNote),
      safetyNote: safetyNote == null && nullToAbsent
          ? const Value.absent()
          : Value(safetyNote),
      typicalSeconds: Value(typicalSeconds),
      isCatalog: Value(isCatalog),
      isArchived: Value(isArchived),
      timesRehearsed: Value(timesRehearsed),
      lastRehearsedAt: lastRehearsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRehearsedAt),
      masteryDecayedAt: masteryDecayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(masteryDecayedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TrickRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrickRow(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String?>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      discipline: $TricksTable.$converterdiscipline.fromJson(
        serializer.fromJson<String>(json['discipline']),
      ),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      mastery: $TricksTable.$convertermastery.fromJson(
        serializer.fromJson<String>(json['mastery']),
      ),
      summary: serializer.fromJson<String>(json['summary']),
      setupNote: serializer.fromJson<String?>(json['setupNote']),
      safetyNote: serializer.fromJson<String?>(json['safetyNote']),
      typicalSeconds: serializer.fromJson<int>(json['typicalSeconds']),
      isCatalog: serializer.fromJson<bool>(json['isCatalog']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      timesRehearsed: serializer.fromJson<int>(json['timesRehearsed']),
      lastRehearsedAt: serializer.fromJson<DateTime?>(json['lastRehearsedAt']),
      masteryDecayedAt: serializer.fromJson<DateTime?>(
        json['masteryDecayedAt'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String?>(slug),
      'name': serializer.toJson<String>(name),
      'discipline': serializer.toJson<String>(
        $TricksTable.$converterdiscipline.toJson(discipline),
      ),
      'difficulty': serializer.toJson<int>(difficulty),
      'mastery': serializer.toJson<String>(
        $TricksTable.$convertermastery.toJson(mastery),
      ),
      'summary': serializer.toJson<String>(summary),
      'setupNote': serializer.toJson<String?>(setupNote),
      'safetyNote': serializer.toJson<String?>(safetyNote),
      'typicalSeconds': serializer.toJson<int>(typicalSeconds),
      'isCatalog': serializer.toJson<bool>(isCatalog),
      'isArchived': serializer.toJson<bool>(isArchived),
      'timesRehearsed': serializer.toJson<int>(timesRehearsed),
      'lastRehearsedAt': serializer.toJson<DateTime?>(lastRehearsedAt),
      'masteryDecayedAt': serializer.toJson<DateTime?>(masteryDecayedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TrickRow copyWith({
    int? id,
    Value<String?> slug = const Value.absent(),
    String? name,
    Discipline? discipline,
    int? difficulty,
    Mastery? mastery,
    String? summary,
    Value<String?> setupNote = const Value.absent(),
    Value<String?> safetyNote = const Value.absent(),
    int? typicalSeconds,
    bool? isCatalog,
    bool? isArchived,
    int? timesRehearsed,
    Value<DateTime?> lastRehearsedAt = const Value.absent(),
    Value<DateTime?> masteryDecayedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TrickRow(
    id: id ?? this.id,
    slug: slug.present ? slug.value : this.slug,
    name: name ?? this.name,
    discipline: discipline ?? this.discipline,
    difficulty: difficulty ?? this.difficulty,
    mastery: mastery ?? this.mastery,
    summary: summary ?? this.summary,
    setupNote: setupNote.present ? setupNote.value : this.setupNote,
    safetyNote: safetyNote.present ? safetyNote.value : this.safetyNote,
    typicalSeconds: typicalSeconds ?? this.typicalSeconds,
    isCatalog: isCatalog ?? this.isCatalog,
    isArchived: isArchived ?? this.isArchived,
    timesRehearsed: timesRehearsed ?? this.timesRehearsed,
    lastRehearsedAt: lastRehearsedAt.present
        ? lastRehearsedAt.value
        : this.lastRehearsedAt,
    masteryDecayedAt: masteryDecayedAt.present
        ? masteryDecayedAt.value
        : this.masteryDecayedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TrickRow copyWithCompanion(TricksCompanion data) {
    return TrickRow(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      discipline: data.discipline.present
          ? data.discipline.value
          : this.discipline,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      mastery: data.mastery.present ? data.mastery.value : this.mastery,
      summary: data.summary.present ? data.summary.value : this.summary,
      setupNote: data.setupNote.present ? data.setupNote.value : this.setupNote,
      safetyNote: data.safetyNote.present
          ? data.safetyNote.value
          : this.safetyNote,
      typicalSeconds: data.typicalSeconds.present
          ? data.typicalSeconds.value
          : this.typicalSeconds,
      isCatalog: data.isCatalog.present ? data.isCatalog.value : this.isCatalog,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      timesRehearsed: data.timesRehearsed.present
          ? data.timesRehearsed.value
          : this.timesRehearsed,
      lastRehearsedAt: data.lastRehearsedAt.present
          ? data.lastRehearsedAt.value
          : this.lastRehearsedAt,
      masteryDecayedAt: data.masteryDecayedAt.present
          ? data.masteryDecayedAt.value
          : this.masteryDecayedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrickRow(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('discipline: $discipline, ')
          ..write('difficulty: $difficulty, ')
          ..write('mastery: $mastery, ')
          ..write('summary: $summary, ')
          ..write('setupNote: $setupNote, ')
          ..write('safetyNote: $safetyNote, ')
          ..write('typicalSeconds: $typicalSeconds, ')
          ..write('isCatalog: $isCatalog, ')
          ..write('isArchived: $isArchived, ')
          ..write('timesRehearsed: $timesRehearsed, ')
          ..write('lastRehearsedAt: $lastRehearsedAt, ')
          ..write('masteryDecayedAt: $masteryDecayedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slug,
    name,
    discipline,
    difficulty,
    mastery,
    summary,
    setupNote,
    safetyNote,
    typicalSeconds,
    isCatalog,
    isArchived,
    timesRehearsed,
    lastRehearsedAt,
    masteryDecayedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrickRow &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.discipline == this.discipline &&
          other.difficulty == this.difficulty &&
          other.mastery == this.mastery &&
          other.summary == this.summary &&
          other.setupNote == this.setupNote &&
          other.safetyNote == this.safetyNote &&
          other.typicalSeconds == this.typicalSeconds &&
          other.isCatalog == this.isCatalog &&
          other.isArchived == this.isArchived &&
          other.timesRehearsed == this.timesRehearsed &&
          other.lastRehearsedAt == this.lastRehearsedAt &&
          other.masteryDecayedAt == this.masteryDecayedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TricksCompanion extends UpdateCompanion<TrickRow> {
  final Value<int> id;
  final Value<String?> slug;
  final Value<String> name;
  final Value<Discipline> discipline;
  final Value<int> difficulty;
  final Value<Mastery> mastery;
  final Value<String> summary;
  final Value<String?> setupNote;
  final Value<String?> safetyNote;
  final Value<int> typicalSeconds;
  final Value<bool> isCatalog;
  final Value<bool> isArchived;
  final Value<int> timesRehearsed;
  final Value<DateTime?> lastRehearsedAt;
  final Value<DateTime?> masteryDecayedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TricksCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.discipline = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.mastery = const Value.absent(),
    this.summary = const Value.absent(),
    this.setupNote = const Value.absent(),
    this.safetyNote = const Value.absent(),
    this.typicalSeconds = const Value.absent(),
    this.isCatalog = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.timesRehearsed = const Value.absent(),
    this.lastRehearsedAt = const Value.absent(),
    this.masteryDecayedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TricksCompanion.insert({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    required String name,
    required Discipline discipline,
    this.difficulty = const Value.absent(),
    this.mastery = const Value.absent(),
    this.summary = const Value.absent(),
    this.setupNote = const Value.absent(),
    this.safetyNote = const Value.absent(),
    this.typicalSeconds = const Value.absent(),
    this.isCatalog = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.timesRehearsed = const Value.absent(),
    this.lastRehearsedAt = const Value.absent(),
    this.masteryDecayedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       discipline = Value(discipline),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TrickRow> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? discipline,
    Expression<int>? difficulty,
    Expression<String>? mastery,
    Expression<String>? summary,
    Expression<String>? setupNote,
    Expression<String>? safetyNote,
    Expression<int>? typicalSeconds,
    Expression<bool>? isCatalog,
    Expression<bool>? isArchived,
    Expression<int>? timesRehearsed,
    Expression<DateTime>? lastRehearsedAt,
    Expression<DateTime>? masteryDecayedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (discipline != null) 'discipline': discipline,
      if (difficulty != null) 'difficulty': difficulty,
      if (mastery != null) 'mastery': mastery,
      if (summary != null) 'summary': summary,
      if (setupNote != null) 'setup_note': setupNote,
      if (safetyNote != null) 'safety_note': safetyNote,
      if (typicalSeconds != null) 'typical_seconds': typicalSeconds,
      if (isCatalog != null) 'is_catalog': isCatalog,
      if (isArchived != null) 'is_archived': isArchived,
      if (timesRehearsed != null) 'times_rehearsed': timesRehearsed,
      if (lastRehearsedAt != null) 'last_rehearsed_at': lastRehearsedAt,
      if (masteryDecayedAt != null) 'mastery_decayed_at': masteryDecayedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TricksCompanion copyWith({
    Value<int>? id,
    Value<String?>? slug,
    Value<String>? name,
    Value<Discipline>? discipline,
    Value<int>? difficulty,
    Value<Mastery>? mastery,
    Value<String>? summary,
    Value<String?>? setupNote,
    Value<String?>? safetyNote,
    Value<int>? typicalSeconds,
    Value<bool>? isCatalog,
    Value<bool>? isArchived,
    Value<int>? timesRehearsed,
    Value<DateTime?>? lastRehearsedAt,
    Value<DateTime?>? masteryDecayedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TricksCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      discipline: discipline ?? this.discipline,
      difficulty: difficulty ?? this.difficulty,
      mastery: mastery ?? this.mastery,
      summary: summary ?? this.summary,
      setupNote: setupNote ?? this.setupNote,
      safetyNote: safetyNote ?? this.safetyNote,
      typicalSeconds: typicalSeconds ?? this.typicalSeconds,
      isCatalog: isCatalog ?? this.isCatalog,
      isArchived: isArchived ?? this.isArchived,
      timesRehearsed: timesRehearsed ?? this.timesRehearsed,
      lastRehearsedAt: lastRehearsedAt ?? this.lastRehearsedAt,
      masteryDecayedAt: masteryDecayedAt ?? this.masteryDecayedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (discipline.present) {
      map['discipline'] = Variable<String>(
        $TricksTable.$converterdiscipline.toSql(discipline.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (mastery.present) {
      map['mastery'] = Variable<String>(
        $TricksTable.$convertermastery.toSql(mastery.value),
      );
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (setupNote.present) {
      map['setup_note'] = Variable<String>(setupNote.value);
    }
    if (safetyNote.present) {
      map['safety_note'] = Variable<String>(safetyNote.value);
    }
    if (typicalSeconds.present) {
      map['typical_seconds'] = Variable<int>(typicalSeconds.value);
    }
    if (isCatalog.present) {
      map['is_catalog'] = Variable<bool>(isCatalog.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (timesRehearsed.present) {
      map['times_rehearsed'] = Variable<int>(timesRehearsed.value);
    }
    if (lastRehearsedAt.present) {
      map['last_rehearsed_at'] = Variable<DateTime>(lastRehearsedAt.value);
    }
    if (masteryDecayedAt.present) {
      map['mastery_decayed_at'] = Variable<DateTime>(masteryDecayedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TricksCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('discipline: $discipline, ')
          ..write('difficulty: $difficulty, ')
          ..write('mastery: $mastery, ')
          ..write('summary: $summary, ')
          ..write('setupNote: $setupNote, ')
          ..write('safetyNote: $safetyNote, ')
          ..write('typicalSeconds: $typicalSeconds, ')
          ..write('isCatalog: $isCatalog, ')
          ..write('isArchived: $isArchived, ')
          ..write('timesRehearsed: $timesRehearsed, ')
          ..write('lastRehearsedAt: $lastRehearsedAt, ')
          ..write('masteryDecayedAt: $masteryDecayedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ActsTable extends Acts with TableInfo<$ActsTable, ActRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 90,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _venueMeta = const VerificationMeta('venue');
  @override
  late final GeneratedColumn<String> venue = GeneratedColumn<String>(
    'venue',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ActStatus.draft.name),
      ).withConverter<ActStatus>($ActsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<ActEmblem, String> emblem =
      GeneratedColumn<String>(
        'emblem',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ActEmblem.tent.name),
      ).withConverter<ActEmblem>($ActsTable.$converteremblem);
  @override
  late final GeneratedColumnWithTypeConverter<CueFrameStyle, String> cueFrame =
      GeneratedColumn<String>(
        'cue_frame',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(CueFrameStyle.curtain.name),
      ).withConverter<CueFrameStyle>($ActsTable.$convertercueFrame);
  static const VerificationMeta _targetSecondsMeta = const VerificationMeta(
    'targetSeconds',
  );
  @override
  late final GeneratedColumn<int> targetSeconds = GeneratedColumn<int>(
    'target_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(240),
  );
  static const VerificationMeta _performanceDateMeta = const VerificationMeta(
    'performanceDate',
  );
  @override
  late final GeneratedColumn<DateTime> performanceDate =
      GeneratedColumn<DateTime>(
        'performance_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subtitle,
    venue,
    status,
    emblem,
    cueFrame,
    targetSeconds,
    performanceDate,
    summary,
    isArchived,
    createdAt,
    updatedAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'acts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('venue')) {
      context.handle(
        _venueMeta,
        venue.isAcceptableOrUnknown(data['venue']!, _venueMeta),
      );
    }
    if (data.containsKey('target_seconds')) {
      context.handle(
        _targetSecondsMeta,
        targetSeconds.isAcceptableOrUnknown(
          data['target_seconds']!,
          _targetSecondsMeta,
        ),
      );
    }
    if (data.containsKey('performance_date')) {
      context.handle(
        _performanceDateMeta,
        performanceDate.isAcceptableOrUnknown(
          data['performance_date']!,
          _performanceDateMeta,
        ),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      venue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue'],
      ),
      status: $ActsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      emblem: $ActsTable.$converteremblem.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emblem'],
        )!,
      ),
      cueFrame: $ActsTable.$convertercueFrame.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cue_frame'],
        )!,
      ),
      targetSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_seconds'],
      )!,
      performanceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performance_date'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
    );
  }

  @override
  $ActsTable createAlias(String alias) {
    return $ActsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActStatus, String, String> $converterstatus =
      const EnumNameConverter<ActStatus>(ActStatus.values);
  static JsonTypeConverter2<ActEmblem, String, String> $converteremblem =
      const EnumNameConverter<ActEmblem>(ActEmblem.values);
  static JsonTypeConverter2<CueFrameStyle, String, String> $convertercueFrame =
      const EnumNameConverter<CueFrameStyle>(CueFrameStyle.values);
}

class ActRow extends DataClass implements Insertable<ActRow> {
  final int id;
  final String title;

  /// Optional second line, e.g. "Act II" or "Closing set".
  final String? subtitle;
  final String? venue;
  final ActStatus status;
  final ActEmblem emblem;
  final CueFrameStyle cueFrame;

  /// Target running time in seconds, set when the act is created.
  final int targetSeconds;
  final DateTime? performanceDate;

  /// One or two lines on what the act is going for.
  final String? summary;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Drives "continue where you left off" on the Stage Console.
  final DateTime? lastOpenedAt;
  const ActRow({
    required this.id,
    required this.title,
    this.subtitle,
    this.venue,
    required this.status,
    required this.emblem,
    required this.cueFrame,
    required this.targetSeconds,
    this.performanceDate,
    this.summary,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || venue != null) {
      map['venue'] = Variable<String>(venue);
    }
    {
      map['status'] = Variable<String>(
        $ActsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['emblem'] = Variable<String>(
        $ActsTable.$converteremblem.toSql(emblem),
      );
    }
    {
      map['cue_frame'] = Variable<String>(
        $ActsTable.$convertercueFrame.toSql(cueFrame),
      );
    }
    map['target_seconds'] = Variable<int>(targetSeconds);
    if (!nullToAbsent || performanceDate != null) {
      map['performance_date'] = Variable<DateTime>(performanceDate);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    return map;
  }

  ActsCompanion toCompanion(bool nullToAbsent) {
    return ActsCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      venue: venue == null && nullToAbsent
          ? const Value.absent()
          : Value(venue),
      status: Value(status),
      emblem: Value(emblem),
      cueFrame: Value(cueFrame),
      targetSeconds: Value(targetSeconds),
      performanceDate: performanceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(performanceDate),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
    );
  }

  factory ActRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      venue: serializer.fromJson<String?>(json['venue']),
      status: $ActsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      emblem: $ActsTable.$converteremblem.fromJson(
        serializer.fromJson<String>(json['emblem']),
      ),
      cueFrame: $ActsTable.$convertercueFrame.fromJson(
        serializer.fromJson<String>(json['cueFrame']),
      ),
      targetSeconds: serializer.fromJson<int>(json['targetSeconds']),
      performanceDate: serializer.fromJson<DateTime?>(json['performanceDate']),
      summary: serializer.fromJson<String?>(json['summary']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'venue': serializer.toJson<String?>(venue),
      'status': serializer.toJson<String>(
        $ActsTable.$converterstatus.toJson(status),
      ),
      'emblem': serializer.toJson<String>(
        $ActsTable.$converteremblem.toJson(emblem),
      ),
      'cueFrame': serializer.toJson<String>(
        $ActsTable.$convertercueFrame.toJson(cueFrame),
      ),
      'targetSeconds': serializer.toJson<int>(targetSeconds),
      'performanceDate': serializer.toJson<DateTime?>(performanceDate),
      'summary': serializer.toJson<String?>(summary),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
    };
  }

  ActRow copyWith({
    int? id,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    Value<String?> venue = const Value.absent(),
    ActStatus? status,
    ActEmblem? emblem,
    CueFrameStyle? cueFrame,
    int? targetSeconds,
    Value<DateTime?> performanceDate = const Value.absent(),
    Value<String?> summary = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
  }) => ActRow(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    venue: venue.present ? venue.value : this.venue,
    status: status ?? this.status,
    emblem: emblem ?? this.emblem,
    cueFrame: cueFrame ?? this.cueFrame,
    targetSeconds: targetSeconds ?? this.targetSeconds,
    performanceDate: performanceDate.present
        ? performanceDate.value
        : this.performanceDate,
    summary: summary.present ? summary.value : this.summary,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
  );
  ActRow copyWithCompanion(ActsCompanion data) {
    return ActRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      venue: data.venue.present ? data.venue.value : this.venue,
      status: data.status.present ? data.status.value : this.status,
      emblem: data.emblem.present ? data.emblem.value : this.emblem,
      cueFrame: data.cueFrame.present ? data.cueFrame.value : this.cueFrame,
      targetSeconds: data.targetSeconds.present
          ? data.targetSeconds.value
          : this.targetSeconds,
      performanceDate: data.performanceDate.present
          ? data.performanceDate.value
          : this.performanceDate,
      summary: data.summary.present ? data.summary.value : this.summary,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('venue: $venue, ')
          ..write('status: $status, ')
          ..write('emblem: $emblem, ')
          ..write('cueFrame: $cueFrame, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('performanceDate: $performanceDate, ')
          ..write('summary: $summary, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subtitle,
    venue,
    status,
    emblem,
    cueFrame,
    targetSeconds,
    performanceDate,
    summary,
    isArchived,
    createdAt,
    updatedAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.venue == this.venue &&
          other.status == this.status &&
          other.emblem == this.emblem &&
          other.cueFrame == this.cueFrame &&
          other.targetSeconds == this.targetSeconds &&
          other.performanceDate == this.performanceDate &&
          other.summary == this.summary &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class ActsCompanion extends UpdateCompanion<ActRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String?> venue;
  final Value<ActStatus> status;
  final Value<ActEmblem> emblem;
  final Value<CueFrameStyle> cueFrame;
  final Value<int> targetSeconds;
  final Value<DateTime?> performanceDate;
  final Value<String?> summary;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastOpenedAt;
  const ActsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.venue = const Value.absent(),
    this.status = const Value.absent(),
    this.emblem = const Value.absent(),
    this.cueFrame = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.performanceDate = const Value.absent(),
    this.summary = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  ActsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.subtitle = const Value.absent(),
    this.venue = const Value.absent(),
    this.status = const Value.absent(),
    this.emblem = const Value.absent(),
    this.cueFrame = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.performanceDate = const Value.absent(),
    this.summary = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastOpenedAt = const Value.absent(),
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? venue,
    Expression<String>? status,
    Expression<String>? emblem,
    Expression<String>? cueFrame,
    Expression<int>? targetSeconds,
    Expression<DateTime>? performanceDate,
    Expression<String>? summary,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (venue != null) 'venue': venue,
      if (status != null) 'status': status,
      if (emblem != null) 'emblem': emblem,
      if (cueFrame != null) 'cue_frame': cueFrame,
      if (targetSeconds != null) 'target_seconds': targetSeconds,
      if (performanceDate != null) 'performance_date': performanceDate,
      if (summary != null) 'summary': summary,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
    });
  }

  ActsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String?>? venue,
    Value<ActStatus>? status,
    Value<ActEmblem>? emblem,
    Value<CueFrameStyle>? cueFrame,
    Value<int>? targetSeconds,
    Value<DateTime?>? performanceDate,
    Value<String?>? summary,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastOpenedAt,
  }) {
    return ActsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      venue: venue ?? this.venue,
      status: status ?? this.status,
      emblem: emblem ?? this.emblem,
      cueFrame: cueFrame ?? this.cueFrame,
      targetSeconds: targetSeconds ?? this.targetSeconds,
      performanceDate: performanceDate ?? this.performanceDate,
      summary: summary ?? this.summary,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (venue.present) {
      map['venue'] = Variable<String>(venue.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ActsTable.$converterstatus.toSql(status.value),
      );
    }
    if (emblem.present) {
      map['emblem'] = Variable<String>(
        $ActsTable.$converteremblem.toSql(emblem.value),
      );
    }
    if (cueFrame.present) {
      map['cue_frame'] = Variable<String>(
        $ActsTable.$convertercueFrame.toSql(cueFrame.value),
      );
    }
    if (targetSeconds.present) {
      map['target_seconds'] = Variable<int>(targetSeconds.value);
    }
    if (performanceDate.present) {
      map['performance_date'] = Variable<DateTime>(performanceDate.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('venue: $venue, ')
          ..write('status: $status, ')
          ..write('emblem: $emblem, ')
          ..write('cueFrame: $cueFrame, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('performanceDate: $performanceDate, ')
          ..write('summary: $summary, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }
}

class $ActBlocksTable extends ActBlocks
    with TableInfo<$ActBlocksTable, ActBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actIdMeta = const VerificationMeta('actId');
  @override
  late final GeneratedColumn<int> actId = GeneratedColumn<int>(
    'act_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES acts (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BlockRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BlockRole>($ActBlocksTable.$converterrole);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 90,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentMeta = const VerificationMeta('intent');
  @override
  late final GeneratedColumn<String> intent = GeneratedColumn<String>(
    'intent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedSecondsMeta = const VerificationMeta(
    'plannedSeconds',
  );
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
    'planned_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actId,
    role,
    title,
    intent,
    plannedSeconds,
    position,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'act_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act_id')) {
      context.handle(
        _actIdMeta,
        actId.isAcceptableOrUnknown(data['act_id']!, _actIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('intent')) {
      context.handle(
        _intentMeta,
        intent.isAcceptableOrUnknown(data['intent']!, _intentMeta),
      );
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
        _plannedSecondsMeta,
        plannedSeconds.isAcceptableOrUnknown(
          data['planned_seconds']!,
          _plannedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActBlockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}act_id'],
      )!,
      role: $ActBlocksTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      intent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intent'],
      ),
      plannedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_seconds'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActBlocksTable createAlias(String alias) {
    return $ActBlocksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BlockRole, String, String> $converterrole =
      const EnumNameConverter<BlockRole>(BlockRole.values);
}

class ActBlockRow extends DataClass implements Insertable<ActBlockRow> {
  final int id;
  final int actId;
  final BlockRole role;
  final String title;

  /// What this section has to achieve. Kept separate from notes because it is
  /// the thing the user rereads while ordering tricks.
  final String? intent;
  final int plannedSeconds;

  /// Zero-based order within the act.
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ActBlockRow({
    required this.id,
    required this.actId,
    required this.role,
    required this.title,
    this.intent,
    required this.plannedSeconds,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['act_id'] = Variable<int>(actId);
    {
      map['role'] = Variable<String>(
        $ActBlocksTable.$converterrole.toSql(role),
      );
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || intent != null) {
      map['intent'] = Variable<String>(intent);
    }
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActBlocksCompanion toCompanion(bool nullToAbsent) {
    return ActBlocksCompanion(
      id: Value(id),
      actId: Value(actId),
      role: Value(role),
      title: Value(title),
      intent: intent == null && nullToAbsent
          ? const Value.absent()
          : Value(intent),
      plannedSeconds: Value(plannedSeconds),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActBlockRow(
      id: serializer.fromJson<int>(json['id']),
      actId: serializer.fromJson<int>(json['actId']),
      role: $ActBlocksTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      title: serializer.fromJson<String>(json['title']),
      intent: serializer.fromJson<String?>(json['intent']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actId': serializer.toJson<int>(actId),
      'role': serializer.toJson<String>(
        $ActBlocksTable.$converterrole.toJson(role),
      ),
      'title': serializer.toJson<String>(title),
      'intent': serializer.toJson<String?>(intent),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActBlockRow copyWith({
    int? id,
    int? actId,
    BlockRole? role,
    String? title,
    Value<String?> intent = const Value.absent(),
    int? plannedSeconds,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ActBlockRow(
    id: id ?? this.id,
    actId: actId ?? this.actId,
    role: role ?? this.role,
    title: title ?? this.title,
    intent: intent.present ? intent.value : this.intent,
    plannedSeconds: plannedSeconds ?? this.plannedSeconds,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActBlockRow copyWithCompanion(ActBlocksCompanion data) {
    return ActBlockRow(
      id: data.id.present ? data.id.value : this.id,
      actId: data.actId.present ? data.actId.value : this.actId,
      role: data.role.present ? data.role.value : this.role,
      title: data.title.present ? data.title.value : this.title,
      intent: data.intent.present ? data.intent.value : this.intent,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActBlockRow(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('role: $role, ')
          ..write('title: $title, ')
          ..write('intent: $intent, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actId,
    role,
    title,
    intent,
    plannedSeconds,
    position,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActBlockRow &&
          other.id == this.id &&
          other.actId == this.actId &&
          other.role == this.role &&
          other.title == this.title &&
          other.intent == this.intent &&
          other.plannedSeconds == this.plannedSeconds &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActBlocksCompanion extends UpdateCompanion<ActBlockRow> {
  final Value<int> id;
  final Value<int> actId;
  final Value<BlockRole> role;
  final Value<String> title;
  final Value<String?> intent;
  final Value<int> plannedSeconds;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ActBlocksCompanion({
    this.id = const Value.absent(),
    this.actId = const Value.absent(),
    this.role = const Value.absent(),
    this.title = const Value.absent(),
    this.intent = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ActBlocksCompanion.insert({
    this.id = const Value.absent(),
    required int actId,
    required BlockRole role,
    required String title,
    this.intent = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : actId = Value(actId),
       role = Value(role),
       title = Value(title),
       position = Value(position),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActBlockRow> custom({
    Expression<int>? id,
    Expression<int>? actId,
    Expression<String>? role,
    Expression<String>? title,
    Expression<String>? intent,
    Expression<int>? plannedSeconds,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actId != null) 'act_id': actId,
      if (role != null) 'role': role,
      if (title != null) 'title': title,
      if (intent != null) 'intent': intent,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ActBlocksCompanion copyWith({
    Value<int>? id,
    Value<int>? actId,
    Value<BlockRole>? role,
    Value<String>? title,
    Value<String?>? intent,
    Value<int>? plannedSeconds,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ActBlocksCompanion(
      id: id ?? this.id,
      actId: actId ?? this.actId,
      role: role ?? this.role,
      title: title ?? this.title,
      intent: intent ?? this.intent,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actId.present) {
      map['act_id'] = Variable<int>(actId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $ActBlocksTable.$converterrole.toSql(role.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (intent.present) {
      map['intent'] = Variable<String>(intent.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActBlocksCompanion(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('role: $role, ')
          ..write('title: $title, ')
          ..write('intent: $intent, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RunOrderItemsTable extends RunOrderItems
    with TableInfo<$RunOrderItemsTable, RunOrderItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RunOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
    'block_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES act_blocks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trickIdMeta = const VerificationMeta(
    'trickId',
  );
  @override
  late final GeneratedColumn<int> trickId = GeneratedColumn<int>(
    'trick_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tricks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 90,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cueNoteMeta = const VerificationMeta(
    'cueNote',
  );
  @override
  late final GeneratedColumn<String> cueNote = GeneratedColumn<String>(
    'cue_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _secondsMeta = const VerificationMeta(
    'seconds',
  );
  @override
  late final GeneratedColumn<int> seconds = GeneratedColumn<int>(
    'seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isConfirmedMeta = const VerificationMeta(
    'isConfirmed',
  );
  @override
  late final GeneratedColumn<bool> isConfirmed = GeneratedColumn<bool>(
    'is_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    blockId,
    trickId,
    label,
    cueNote,
    seconds,
    position,
    isConfirmed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'run_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RunOrderItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('trick_id')) {
      context.handle(
        _trickIdMeta,
        trickId.isAcceptableOrUnknown(data['trick_id']!, _trickIdMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('cue_note')) {
      context.handle(
        _cueNoteMeta,
        cueNote.isAcceptableOrUnknown(data['cue_note']!, _cueNoteMeta),
      );
    }
    if (data.containsKey('seconds')) {
      context.handle(
        _secondsMeta,
        seconds.isAcceptableOrUnknown(data['seconds']!, _secondsMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('is_confirmed')) {
      context.handle(
        _isConfirmedMeta,
        isConfirmed.isAcceptableOrUnknown(
          data['is_confirmed']!,
          _isConfirmedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RunOrderItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RunOrderItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_id'],
      )!,
      trickId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trick_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      cueNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cue_note'],
      ),
      seconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seconds'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      isConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_confirmed'],
      )!,
    );
  }

  @override
  $RunOrderItemsTable createAlias(String alias) {
    return $RunOrderItemsTable(attachedDatabase, alias);
  }
}

class RunOrderItemRow extends DataClass implements Insertable<RunOrderItemRow> {
  final int id;
  final int blockId;

  /// Null when the entry is a one-off beat rather than a catalogued trick, and
  /// also when a referenced trick is later deleted.
  final int? trickId;

  /// Copied from the trick when linked. Keeping it here means the run order
  /// still reads correctly if the trick is renamed or removed.
  final String label;

  /// What the operator or partner needs to know at this beat.
  final String? cueNote;
  final int seconds;
  final int position;

  /// Set once the beat is choreographed and timed, not just planned.
  final bool isConfirmed;
  const RunOrderItemRow({
    required this.id,
    required this.blockId,
    this.trickId,
    required this.label,
    this.cueNote,
    required this.seconds,
    required this.position,
    required this.isConfirmed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    if (!nullToAbsent || trickId != null) {
      map['trick_id'] = Variable<int>(trickId);
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || cueNote != null) {
      map['cue_note'] = Variable<String>(cueNote);
    }
    map['seconds'] = Variable<int>(seconds);
    map['position'] = Variable<int>(position);
    map['is_confirmed'] = Variable<bool>(isConfirmed);
    return map;
  }

  RunOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return RunOrderItemsCompanion(
      id: Value(id),
      blockId: Value(blockId),
      trickId: trickId == null && nullToAbsent
          ? const Value.absent()
          : Value(trickId),
      label: Value(label),
      cueNote: cueNote == null && nullToAbsent
          ? const Value.absent()
          : Value(cueNote),
      seconds: Value(seconds),
      position: Value(position),
      isConfirmed: Value(isConfirmed),
    );
  }

  factory RunOrderItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RunOrderItemRow(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      trickId: serializer.fromJson<int?>(json['trickId']),
      label: serializer.fromJson<String>(json['label']),
      cueNote: serializer.fromJson<String?>(json['cueNote']),
      seconds: serializer.fromJson<int>(json['seconds']),
      position: serializer.fromJson<int>(json['position']),
      isConfirmed: serializer.fromJson<bool>(json['isConfirmed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'trickId': serializer.toJson<int?>(trickId),
      'label': serializer.toJson<String>(label),
      'cueNote': serializer.toJson<String?>(cueNote),
      'seconds': serializer.toJson<int>(seconds),
      'position': serializer.toJson<int>(position),
      'isConfirmed': serializer.toJson<bool>(isConfirmed),
    };
  }

  RunOrderItemRow copyWith({
    int? id,
    int? blockId,
    Value<int?> trickId = const Value.absent(),
    String? label,
    Value<String?> cueNote = const Value.absent(),
    int? seconds,
    int? position,
    bool? isConfirmed,
  }) => RunOrderItemRow(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    trickId: trickId.present ? trickId.value : this.trickId,
    label: label ?? this.label,
    cueNote: cueNote.present ? cueNote.value : this.cueNote,
    seconds: seconds ?? this.seconds,
    position: position ?? this.position,
    isConfirmed: isConfirmed ?? this.isConfirmed,
  );
  RunOrderItemRow copyWithCompanion(RunOrderItemsCompanion data) {
    return RunOrderItemRow(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      trickId: data.trickId.present ? data.trickId.value : this.trickId,
      label: data.label.present ? data.label.value : this.label,
      cueNote: data.cueNote.present ? data.cueNote.value : this.cueNote,
      seconds: data.seconds.present ? data.seconds.value : this.seconds,
      position: data.position.present ? data.position.value : this.position,
      isConfirmed: data.isConfirmed.present
          ? data.isConfirmed.value
          : this.isConfirmed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RunOrderItemRow(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('trickId: $trickId, ')
          ..write('label: $label, ')
          ..write('cueNote: $cueNote, ')
          ..write('seconds: $seconds, ')
          ..write('position: $position, ')
          ..write('isConfirmed: $isConfirmed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    blockId,
    trickId,
    label,
    cueNote,
    seconds,
    position,
    isConfirmed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RunOrderItemRow &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.trickId == this.trickId &&
          other.label == this.label &&
          other.cueNote == this.cueNote &&
          other.seconds == this.seconds &&
          other.position == this.position &&
          other.isConfirmed == this.isConfirmed);
}

class RunOrderItemsCompanion extends UpdateCompanion<RunOrderItemRow> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<int?> trickId;
  final Value<String> label;
  final Value<String?> cueNote;
  final Value<int> seconds;
  final Value<int> position;
  final Value<bool> isConfirmed;
  const RunOrderItemsCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.trickId = const Value.absent(),
    this.label = const Value.absent(),
    this.cueNote = const Value.absent(),
    this.seconds = const Value.absent(),
    this.position = const Value.absent(),
    this.isConfirmed = const Value.absent(),
  });
  RunOrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    this.trickId = const Value.absent(),
    required String label,
    this.cueNote = const Value.absent(),
    this.seconds = const Value.absent(),
    required int position,
    this.isConfirmed = const Value.absent(),
  }) : blockId = Value(blockId),
       label = Value(label),
       position = Value(position);
  static Insertable<RunOrderItemRow> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? trickId,
    Expression<String>? label,
    Expression<String>? cueNote,
    Expression<int>? seconds,
    Expression<int>? position,
    Expression<bool>? isConfirmed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (trickId != null) 'trick_id': trickId,
      if (label != null) 'label': label,
      if (cueNote != null) 'cue_note': cueNote,
      if (seconds != null) 'seconds': seconds,
      if (position != null) 'position': position,
      if (isConfirmed != null) 'is_confirmed': isConfirmed,
    });
  }

  RunOrderItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? blockId,
    Value<int?>? trickId,
    Value<String>? label,
    Value<String?>? cueNote,
    Value<int>? seconds,
    Value<int>? position,
    Value<bool>? isConfirmed,
  }) {
    return RunOrderItemsCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      trickId: trickId ?? this.trickId,
      label: label ?? this.label,
      cueNote: cueNote ?? this.cueNote,
      seconds: seconds ?? this.seconds,
      position: position ?? this.position,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (trickId.present) {
      map['trick_id'] = Variable<int>(trickId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (cueNote.present) {
      map['cue_note'] = Variable<String>(cueNote.value);
    }
    if (seconds.present) {
      map['seconds'] = Variable<int>(seconds.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (isConfirmed.present) {
      map['is_confirmed'] = Variable<bool>(isConfirmed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RunOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('trickId: $trickId, ')
          ..write('label: $label, ')
          ..write('cueNote: $cueNote, ')
          ..write('seconds: $seconds, ')
          ..write('position: $position, ')
          ..write('isConfirmed: $isConfirmed')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actIdMeta = const VerificationMeta('actId');
  @override
  late final GeneratedColumn<int> actId = GeneratedColumn<int>(
    'act_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES acts (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChecklistCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ChecklistCategory>($ChecklistItemsTable.$convertercategory);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actId,
    category,
    label,
    detail,
    isDone,
    doneAt,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act_id')) {
      context.handle(
        _actIdMeta,
        actId.isAcceptableOrUnknown(data['act_id']!, _actIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}act_id'],
      )!,
      category: $ChecklistItemsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChecklistCategory, String, String>
  $convertercategory = const EnumNameConverter<ChecklistCategory>(
    ChecklistCategory.values,
  );
}

class ChecklistItemRow extends DataClass
    implements Insertable<ChecklistItemRow> {
  final int id;
  final int actId;
  final ChecklistCategory category;
  final String label;
  final String? detail;
  final bool isDone;
  final DateTime? doneAt;
  final int position;
  const ChecklistItemRow({
    required this.id,
    required this.actId,
    required this.category,
    required this.label,
    this.detail,
    required this.isDone,
    this.doneAt,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['act_id'] = Variable<int>(actId);
    {
      map['category'] = Variable<String>(
        $ChecklistItemsTable.$convertercategory.toSql(category),
      );
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      actId: Value(actId),
      category: Value(category),
      label: Value(label),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
      isDone: Value(isDone),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      position: Value(position),
    );
  }

  factory ChecklistItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItemRow(
      id: serializer.fromJson<int>(json['id']),
      actId: serializer.fromJson<int>(json['actId']),
      category: $ChecklistItemsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      label: serializer.fromJson<String>(json['label']),
      detail: serializer.fromJson<String?>(json['detail']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actId': serializer.toJson<int>(actId),
      'category': serializer.toJson<String>(
        $ChecklistItemsTable.$convertercategory.toJson(category),
      ),
      'label': serializer.toJson<String>(label),
      'detail': serializer.toJson<String?>(detail),
      'isDone': serializer.toJson<bool>(isDone),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
      'position': serializer.toJson<int>(position),
    };
  }

  ChecklistItemRow copyWith({
    int? id,
    int? actId,
    ChecklistCategory? category,
    String? label,
    Value<String?> detail = const Value.absent(),
    bool? isDone,
    Value<DateTime?> doneAt = const Value.absent(),
    int? position,
  }) => ChecklistItemRow(
    id: id ?? this.id,
    actId: actId ?? this.actId,
    category: category ?? this.category,
    label: label ?? this.label,
    detail: detail.present ? detail.value : this.detail,
    isDone: isDone ?? this.isDone,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    position: position ?? this.position,
  );
  ChecklistItemRow copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItemRow(
      id: data.id.present ? data.id.value : this.id,
      actId: data.actId.present ? data.actId.value : this.actId,
      category: data.category.present ? data.category.value : this.category,
      label: data.label.present ? data.label.value : this.label,
      detail: data.detail.present ? data.detail.value : this.detail,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemRow(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('detail: $detail, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, actId, category, label, detail, isDone, doneAt, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItemRow &&
          other.id == this.id &&
          other.actId == this.actId &&
          other.category == this.category &&
          other.label == this.label &&
          other.detail == this.detail &&
          other.isDone == this.isDone &&
          other.doneAt == this.doneAt &&
          other.position == this.position);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItemRow> {
  final Value<int> id;
  final Value<int> actId;
  final Value<ChecklistCategory> category;
  final Value<String> label;
  final Value<String?> detail;
  final Value<bool> isDone;
  final Value<DateTime?> doneAt;
  final Value<int> position;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.actId = const Value.absent(),
    this.category = const Value.absent(),
    this.label = const Value.absent(),
    this.detail = const Value.absent(),
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.position = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    this.id = const Value.absent(),
    required int actId,
    required ChecklistCategory category,
    required String label,
    this.detail = const Value.absent(),
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
    required int position,
  }) : actId = Value(actId),
       category = Value(category),
       label = Value(label),
       position = Value(position);
  static Insertable<ChecklistItemRow> custom({
    Expression<int>? id,
    Expression<int>? actId,
    Expression<String>? category,
    Expression<String>? label,
    Expression<String>? detail,
    Expression<bool>? isDone,
    Expression<DateTime>? doneAt,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actId != null) 'act_id': actId,
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (detail != null) 'detail': detail,
      if (isDone != null) 'is_done': isDone,
      if (doneAt != null) 'done_at': doneAt,
      if (position != null) 'position': position,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? actId,
    Value<ChecklistCategory>? category,
    Value<String>? label,
    Value<String?>? detail,
    Value<bool>? isDone,
    Value<DateTime?>? doneAt,
    Value<int>? position,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      actId: actId ?? this.actId,
      category: category ?? this.category,
      label: label ?? this.label,
      detail: detail ?? this.detail,
      isDone: isDone ?? this.isDone,
      doneAt: doneAt ?? this.doneAt,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actId.present) {
      map['act_id'] = Variable<int>(actId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ChecklistItemsTable.$convertercategory.toSql(category.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('detail: $detail, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $StagePlotItemsTable extends StagePlotItems
    with TableInfo<$StagePlotItemsTable, StagePlotItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StagePlotItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actIdMeta = const VerificationMeta('actId');
  @override
  late final GeneratedColumn<int> actId = GeneratedColumn<int>(
    'act_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES acts (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StageEquipment, String>
  equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<StageEquipment>($StagePlotItemsTable.$converterequipment);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specMeta = const VerificationMeta('spec');
  @override
  late final GeneratedColumn<String> spec = GeneratedColumn<String>(
    'spec',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isConfirmedMeta = const VerificationMeta(
    'isConfirmed',
  );
  @override
  late final GeneratedColumn<bool> isConfirmed = GeneratedColumn<bool>(
    'is_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actId,
    equipment,
    label,
    spec,
    isConfirmed,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stage_plot_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StagePlotItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act_id')) {
      context.handle(
        _actIdMeta,
        actId.isAcceptableOrUnknown(data['act_id']!, _actIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('spec')) {
      context.handle(
        _specMeta,
        spec.isAcceptableOrUnknown(data['spec']!, _specMeta),
      );
    }
    if (data.containsKey('is_confirmed')) {
      context.handle(
        _isConfirmedMeta,
        isConfirmed.isAcceptableOrUnknown(
          data['is_confirmed']!,
          _isConfirmedMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StagePlotItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StagePlotItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}act_id'],
      )!,
      equipment: $StagePlotItemsTable.$converterequipment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      spec: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec'],
      ),
      isConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_confirmed'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StagePlotItemsTable createAlias(String alias) {
    return $StagePlotItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StageEquipment, String, String>
  $converterequipment = const EnumNameConverter<StageEquipment>(
    StageEquipment.values,
  );
}

class StagePlotItemRow extends DataClass
    implements Insertable<StagePlotItemRow> {
  final int id;
  final int actId;
  final StageEquipment equipment;
  final String label;

  /// Free-form specification: channel numbers, colour, position, model.
  final String? spec;

  /// Confirmed with the venue or the operator.
  final bool isConfirmed;
  final int position;
  const StagePlotItemRow({
    required this.id,
    required this.actId,
    required this.equipment,
    required this.label,
    this.spec,
    required this.isConfirmed,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['act_id'] = Variable<int>(actId);
    {
      map['equipment'] = Variable<String>(
        $StagePlotItemsTable.$converterequipment.toSql(equipment),
      );
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || spec != null) {
      map['spec'] = Variable<String>(spec);
    }
    map['is_confirmed'] = Variable<bool>(isConfirmed);
    map['position'] = Variable<int>(position);
    return map;
  }

  StagePlotItemsCompanion toCompanion(bool nullToAbsent) {
    return StagePlotItemsCompanion(
      id: Value(id),
      actId: Value(actId),
      equipment: Value(equipment),
      label: Value(label),
      spec: spec == null && nullToAbsent ? const Value.absent() : Value(spec),
      isConfirmed: Value(isConfirmed),
      position: Value(position),
    );
  }

  factory StagePlotItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StagePlotItemRow(
      id: serializer.fromJson<int>(json['id']),
      actId: serializer.fromJson<int>(json['actId']),
      equipment: $StagePlotItemsTable.$converterequipment.fromJson(
        serializer.fromJson<String>(json['equipment']),
      ),
      label: serializer.fromJson<String>(json['label']),
      spec: serializer.fromJson<String?>(json['spec']),
      isConfirmed: serializer.fromJson<bool>(json['isConfirmed']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actId': serializer.toJson<int>(actId),
      'equipment': serializer.toJson<String>(
        $StagePlotItemsTable.$converterequipment.toJson(equipment),
      ),
      'label': serializer.toJson<String>(label),
      'spec': serializer.toJson<String?>(spec),
      'isConfirmed': serializer.toJson<bool>(isConfirmed),
      'position': serializer.toJson<int>(position),
    };
  }

  StagePlotItemRow copyWith({
    int? id,
    int? actId,
    StageEquipment? equipment,
    String? label,
    Value<String?> spec = const Value.absent(),
    bool? isConfirmed,
    int? position,
  }) => StagePlotItemRow(
    id: id ?? this.id,
    actId: actId ?? this.actId,
    equipment: equipment ?? this.equipment,
    label: label ?? this.label,
    spec: spec.present ? spec.value : this.spec,
    isConfirmed: isConfirmed ?? this.isConfirmed,
    position: position ?? this.position,
  );
  StagePlotItemRow copyWithCompanion(StagePlotItemsCompanion data) {
    return StagePlotItemRow(
      id: data.id.present ? data.id.value : this.id,
      actId: data.actId.present ? data.actId.value : this.actId,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      label: data.label.present ? data.label.value : this.label,
      spec: data.spec.present ? data.spec.value : this.spec,
      isConfirmed: data.isConfirmed.present
          ? data.isConfirmed.value
          : this.isConfirmed,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StagePlotItemRow(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('equipment: $equipment, ')
          ..write('label: $label, ')
          ..write('spec: $spec, ')
          ..write('isConfirmed: $isConfirmed, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, actId, equipment, label, spec, isConfirmed, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StagePlotItemRow &&
          other.id == this.id &&
          other.actId == this.actId &&
          other.equipment == this.equipment &&
          other.label == this.label &&
          other.spec == this.spec &&
          other.isConfirmed == this.isConfirmed &&
          other.position == this.position);
}

class StagePlotItemsCompanion extends UpdateCompanion<StagePlotItemRow> {
  final Value<int> id;
  final Value<int> actId;
  final Value<StageEquipment> equipment;
  final Value<String> label;
  final Value<String?> spec;
  final Value<bool> isConfirmed;
  final Value<int> position;
  const StagePlotItemsCompanion({
    this.id = const Value.absent(),
    this.actId = const Value.absent(),
    this.equipment = const Value.absent(),
    this.label = const Value.absent(),
    this.spec = const Value.absent(),
    this.isConfirmed = const Value.absent(),
    this.position = const Value.absent(),
  });
  StagePlotItemsCompanion.insert({
    this.id = const Value.absent(),
    required int actId,
    required StageEquipment equipment,
    required String label,
    this.spec = const Value.absent(),
    this.isConfirmed = const Value.absent(),
    required int position,
  }) : actId = Value(actId),
       equipment = Value(equipment),
       label = Value(label),
       position = Value(position);
  static Insertable<StagePlotItemRow> custom({
    Expression<int>? id,
    Expression<int>? actId,
    Expression<String>? equipment,
    Expression<String>? label,
    Expression<String>? spec,
    Expression<bool>? isConfirmed,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actId != null) 'act_id': actId,
      if (equipment != null) 'equipment': equipment,
      if (label != null) 'label': label,
      if (spec != null) 'spec': spec,
      if (isConfirmed != null) 'is_confirmed': isConfirmed,
      if (position != null) 'position': position,
    });
  }

  StagePlotItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? actId,
    Value<StageEquipment>? equipment,
    Value<String>? label,
    Value<String?>? spec,
    Value<bool>? isConfirmed,
    Value<int>? position,
  }) {
    return StagePlotItemsCompanion(
      id: id ?? this.id,
      actId: actId ?? this.actId,
      equipment: equipment ?? this.equipment,
      label: label ?? this.label,
      spec: spec ?? this.spec,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actId.present) {
      map['act_id'] = Variable<int>(actId.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
        $StagePlotItemsTable.$converterequipment.toSql(equipment.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (spec.present) {
      map['spec'] = Variable<String>(spec.value);
    }
    if (isConfirmed.present) {
      map['is_confirmed'] = Variable<bool>(isConfirmed.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StagePlotItemsCompanion(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('equipment: $equipment, ')
          ..write('label: $label, ')
          ..write('spec: $spec, ')
          ..write('isConfirmed: $isConfirmed, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actIdMeta = const VerificationMeta('actId');
  @override
  late final GeneratedColumn<int> actId = GeneratedColumn<int>(
    'act_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES acts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PageRuling, String> ruling =
      GeneratedColumn<String>(
        'ruling',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(PageRuling.lined.name),
      ).withConverter<PageRuling>($NotesTable.$converterruling);
  @override
  late final GeneratedColumnWithTypeConverter<PaperStock, String> stock =
      GeneratedColumn<String>(
        'stock',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(PaperStock.aged.name),
      ).withConverter<PaperStock>($NotesTable.$converterstock);
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actId,
    title,
    body,
    ruling,
    stock,
    isPinned,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act_id')) {
      context.handle(
        _actIdMeta,
        actId.isAcceptableOrUnknown(data['act_id']!, _actIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}act_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      ruling: $NotesTable.$converterruling.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ruling'],
        )!,
      ),
      stock: $NotesTable.$converterstock.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}stock'],
        )!,
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PageRuling, String, String> $converterruling =
      const EnumNameConverter<PageRuling>(PageRuling.values);
  static JsonTypeConverter2<PaperStock, String, String> $converterstock =
      const EnumNameConverter<PaperStock>(PaperStock.values);
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final int id;
  final int? actId;
  final String title;
  final String body;
  final PageRuling ruling;
  final PaperStock stock;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoteRow({
    required this.id,
    this.actId,
    required this.title,
    required this.body,
    required this.ruling,
    required this.stock,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || actId != null) {
      map['act_id'] = Variable<int>(actId);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    {
      map['ruling'] = Variable<String>(
        $NotesTable.$converterruling.toSql(ruling),
      );
    }
    {
      map['stock'] = Variable<String>($NotesTable.$converterstock.toSql(stock));
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      actId: actId == null && nullToAbsent
          ? const Value.absent()
          : Value(actId),
      title: Value(title),
      body: Value(body),
      ruling: Value(ruling),
      stock: Value(stock),
      isPinned: Value(isPinned),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<int>(json['id']),
      actId: serializer.fromJson<int?>(json['actId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      ruling: $NotesTable.$converterruling.fromJson(
        serializer.fromJson<String>(json['ruling']),
      ),
      stock: $NotesTable.$converterstock.fromJson(
        serializer.fromJson<String>(json['stock']),
      ),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actId': serializer.toJson<int?>(actId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'ruling': serializer.toJson<String>(
        $NotesTable.$converterruling.toJson(ruling),
      ),
      'stock': serializer.toJson<String>(
        $NotesTable.$converterstock.toJson(stock),
      ),
      'isPinned': serializer.toJson<bool>(isPinned),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoteRow copyWith({
    int? id,
    Value<int?> actId = const Value.absent(),
    String? title,
    String? body,
    PageRuling? ruling,
    PaperStock? stock,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoteRow(
    id: id ?? this.id,
    actId: actId.present ? actId.value : this.actId,
    title: title ?? this.title,
    body: body ?? this.body,
    ruling: ruling ?? this.ruling,
    stock: stock ?? this.stock,
    isPinned: isPinned ?? this.isPinned,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      actId: data.actId.present ? data.actId.value : this.actId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      ruling: data.ruling.present ? data.ruling.value : this.ruling,
      stock: data.stock.present ? data.stock.value : this.stock,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('ruling: $ruling, ')
          ..write('stock: $stock, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actId,
    title,
    body,
    ruling,
    stock,
    isPinned,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.actId == this.actId &&
          other.title == this.title &&
          other.body == this.body &&
          other.ruling == this.ruling &&
          other.stock == this.stock &&
          other.isPinned == this.isPinned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<int> id;
  final Value<int?> actId;
  final Value<String> title;
  final Value<String> body;
  final Value<PageRuling> ruling;
  final Value<PaperStock> stock;
  final Value<bool> isPinned;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.actId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.ruling = const Value.absent(),
    this.stock = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    this.actId = const Value.absent(),
    required String title,
    this.body = const Value.absent(),
    this.ruling = const Value.absent(),
    this.stock = const Value.absent(),
    this.isPinned = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NoteRow> custom({
    Expression<int>? id,
    Expression<int>? actId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? ruling,
    Expression<String>? stock,
    Expression<bool>? isPinned,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actId != null) 'act_id': actId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (ruling != null) 'ruling': ruling,
      if (stock != null) 'stock': stock,
      if (isPinned != null) 'is_pinned': isPinned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int?>? actId,
    Value<String>? title,
    Value<String>? body,
    Value<PageRuling>? ruling,
    Value<PaperStock>? stock,
    Value<bool>? isPinned,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      actId: actId ?? this.actId,
      title: title ?? this.title,
      body: body ?? this.body,
      ruling: ruling ?? this.ruling,
      stock: stock ?? this.stock,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actId.present) {
      map['act_id'] = Variable<int>(actId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (ruling.present) {
      map['ruling'] = Variable<String>(
        $NotesTable.$converterruling.toSql(ruling.value),
      );
    }
    if (stock.present) {
      map['stock'] = Variable<String>(
        $NotesTable.$converterstock.toSql(stock.value),
      );
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('ruling: $ruling, ')
          ..write('stock: $stock, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RehearsalsTable extends Rehearsals
    with TableInfo<$RehearsalsTable, RehearsalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RehearsalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actIdMeta = const VerificationMeta('actId');
  @override
  late final GeneratedColumn<int> actId = GeneratedColumn<int>(
    'act_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES acts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _happenedAtMeta = const VerificationMeta(
    'happenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> happenedAt = GeneratedColumn<DateTime>(
    'happened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    check: () => ComparableExpr(minutes).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<int> confidence = GeneratedColumn<int>(
    'confidence',
    aliasedName,
    false,
    check: () => ComparableExpr(confidence).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actId,
    happenedAt,
    minutes,
    focus,
    confidence,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rehearsals';
  @override
  VerificationContext validateIntegrity(
    Insertable<RehearsalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act_id')) {
      context.handle(
        _actIdMeta,
        actId.isAcceptableOrUnknown(data['act_id']!, _actIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actIdMeta);
    }
    if (data.containsKey('happened_at')) {
      context.handle(
        _happenedAtMeta,
        happenedAt.isAcceptableOrUnknown(data['happened_at']!, _happenedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_happenedAtMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('focus')) {
      context.handle(
        _focusMeta,
        focus.isAcceptableOrUnknown(data['focus']!, _focusMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RehearsalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RehearsalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}act_id'],
      )!,
      happenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}happened_at'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RehearsalsTable createAlias(String alias) {
    return $RehearsalsTable(attachedDatabase, alias);
  }
}

class RehearsalRow extends DataClass implements Insertable<RehearsalRow> {
  final int id;
  final int actId;
  final DateTime happenedAt;
  final int minutes;

  /// What was actually worked in the session.
  final String focus;

  /// How the run felt, 1 to 5. Plotted over time in Progress.
  final int confidence;
  final String? notes;
  final DateTime createdAt;
  const RehearsalRow({
    required this.id,
    required this.actId,
    required this.happenedAt,
    required this.minutes,
    required this.focus,
    required this.confidence,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['act_id'] = Variable<int>(actId);
    map['happened_at'] = Variable<DateTime>(happenedAt);
    map['minutes'] = Variable<int>(minutes);
    map['focus'] = Variable<String>(focus);
    map['confidence'] = Variable<int>(confidence);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RehearsalsCompanion toCompanion(bool nullToAbsent) {
    return RehearsalsCompanion(
      id: Value(id),
      actId: Value(actId),
      happenedAt: Value(happenedAt),
      minutes: Value(minutes),
      focus: Value(focus),
      confidence: Value(confidence),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory RehearsalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RehearsalRow(
      id: serializer.fromJson<int>(json['id']),
      actId: serializer.fromJson<int>(json['actId']),
      happenedAt: serializer.fromJson<DateTime>(json['happenedAt']),
      minutes: serializer.fromJson<int>(json['minutes']),
      focus: serializer.fromJson<String>(json['focus']),
      confidence: serializer.fromJson<int>(json['confidence']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actId': serializer.toJson<int>(actId),
      'happenedAt': serializer.toJson<DateTime>(happenedAt),
      'minutes': serializer.toJson<int>(minutes),
      'focus': serializer.toJson<String>(focus),
      'confidence': serializer.toJson<int>(confidence),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RehearsalRow copyWith({
    int? id,
    int? actId,
    DateTime? happenedAt,
    int? minutes,
    String? focus,
    int? confidence,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => RehearsalRow(
    id: id ?? this.id,
    actId: actId ?? this.actId,
    happenedAt: happenedAt ?? this.happenedAt,
    minutes: minutes ?? this.minutes,
    focus: focus ?? this.focus,
    confidence: confidence ?? this.confidence,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  RehearsalRow copyWithCompanion(RehearsalsCompanion data) {
    return RehearsalRow(
      id: data.id.present ? data.id.value : this.id,
      actId: data.actId.present ? data.actId.value : this.actId,
      happenedAt: data.happenedAt.present
          ? data.happenedAt.value
          : this.happenedAt,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      focus: data.focus.present ? data.focus.value : this.focus,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RehearsalRow(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('happenedAt: $happenedAt, ')
          ..write('minutes: $minutes, ')
          ..write('focus: $focus, ')
          ..write('confidence: $confidence, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actId,
    happenedAt,
    minutes,
    focus,
    confidence,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RehearsalRow &&
          other.id == this.id &&
          other.actId == this.actId &&
          other.happenedAt == this.happenedAt &&
          other.minutes == this.minutes &&
          other.focus == this.focus &&
          other.confidence == this.confidence &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class RehearsalsCompanion extends UpdateCompanion<RehearsalRow> {
  final Value<int> id;
  final Value<int> actId;
  final Value<DateTime> happenedAt;
  final Value<int> minutes;
  final Value<String> focus;
  final Value<int> confidence;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const RehearsalsCompanion({
    this.id = const Value.absent(),
    this.actId = const Value.absent(),
    this.happenedAt = const Value.absent(),
    this.minutes = const Value.absent(),
    this.focus = const Value.absent(),
    this.confidence = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RehearsalsCompanion.insert({
    this.id = const Value.absent(),
    required int actId,
    required DateTime happenedAt,
    this.minutes = const Value.absent(),
    this.focus = const Value.absent(),
    this.confidence = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  }) : actId = Value(actId),
       happenedAt = Value(happenedAt),
       createdAt = Value(createdAt);
  static Insertable<RehearsalRow> custom({
    Expression<int>? id,
    Expression<int>? actId,
    Expression<DateTime>? happenedAt,
    Expression<int>? minutes,
    Expression<String>? focus,
    Expression<int>? confidence,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actId != null) 'act_id': actId,
      if (happenedAt != null) 'happened_at': happenedAt,
      if (minutes != null) 'minutes': minutes,
      if (focus != null) 'focus': focus,
      if (confidence != null) 'confidence': confidence,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RehearsalsCompanion copyWith({
    Value<int>? id,
    Value<int>? actId,
    Value<DateTime>? happenedAt,
    Value<int>? minutes,
    Value<String>? focus,
    Value<int>? confidence,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return RehearsalsCompanion(
      id: id ?? this.id,
      actId: actId ?? this.actId,
      happenedAt: happenedAt ?? this.happenedAt,
      minutes: minutes ?? this.minutes,
      focus: focus ?? this.focus,
      confidence: confidence ?? this.confidence,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actId.present) {
      map['act_id'] = Variable<int>(actId.value);
    }
    if (happenedAt.present) {
      map['happened_at'] = Variable<DateTime>(happenedAt.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<int>(confidence.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RehearsalsCompanion(')
          ..write('id: $id, ')
          ..write('actId: $actId, ')
          ..write('happenedAt: $happenedAt, ')
          ..write('minutes: $minutes, ')
          ..write('focus: $focus, ')
          ..write('confidence: $confidence, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PerformerProfilesTable extends PerformerProfiles
    with TableInfo<$PerformerProfilesTable, PerformerProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _stageNameMeta = const VerificationMeta(
    'stageName',
  );
  @override
  late final GeneratedColumn<String> stageName = GeneratedColumn<String>(
    'stage_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Discipline?, String> discipline =
      GeneratedColumn<String>(
        'discipline',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Discipline?>(
        $PerformerProfilesTable.$converterdisciplinen,
      );
  static const VerificationMeta _homeVenueMeta = const VerificationMeta(
    'homeVenue',
  );
  @override
  late final GeneratedColumn<String> homeVenue = GeneratedColumn<String>(
    'home_venue',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoFileNameMeta = const VerificationMeta(
    'photoFileName',
  );
  @override
  late final GeneratedColumn<String> photoFileName = GeneratedColumn<String>(
    'photo_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stageName,
    discipline,
    homeVenue,
    photoFileName,
    bio,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performer_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformerProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stage_name')) {
      context.handle(
        _stageNameMeta,
        stageName.isAcceptableOrUnknown(data['stage_name']!, _stageNameMeta),
      );
    }
    if (data.containsKey('home_venue')) {
      context.handle(
        _homeVenueMeta,
        homeVenue.isAcceptableOrUnknown(data['home_venue']!, _homeVenueMeta),
      );
    }
    if (data.containsKey('photo_file_name')) {
      context.handle(
        _photoFileNameMeta,
        photoFileName.isAcceptableOrUnknown(
          data['photo_file_name']!,
          _photoFileNameMeta,
        ),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerformerProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformerProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      stageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_name'],
      )!,
      discipline: $PerformerProfilesTable.$converterdisciplinen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}discipline'],
        ),
      ),
      homeVenue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_venue'],
      ),
      photoFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_file_name'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PerformerProfilesTable createAlias(String alias) {
    return $PerformerProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Discipline, String, String> $converterdiscipline =
      const EnumNameConverter<Discipline>(Discipline.values);
  static JsonTypeConverter2<Discipline?, String?, String?>
  $converterdisciplinen = JsonTypeConverter2.asNullable($converterdiscipline);
}

class PerformerProfileRow extends DataClass
    implements Insertable<PerformerProfileRow> {
  final int id;
  final String stageName;
  final Discipline? discipline;
  final String? homeVenue;

  /// File name of the performer photo inside the app's documents directory.
  /// Only a name is stored, never an absolute path, because the container path
  /// changes between installs and OS upgrades.
  final String? photoFileName;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PerformerProfileRow({
    required this.id,
    required this.stageName,
    this.discipline,
    this.homeVenue,
    this.photoFileName,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['stage_name'] = Variable<String>(stageName);
    if (!nullToAbsent || discipline != null) {
      map['discipline'] = Variable<String>(
        $PerformerProfilesTable.$converterdisciplinen.toSql(discipline),
      );
    }
    if (!nullToAbsent || homeVenue != null) {
      map['home_venue'] = Variable<String>(homeVenue);
    }
    if (!nullToAbsent || photoFileName != null) {
      map['photo_file_name'] = Variable<String>(photoFileName);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PerformerProfilesCompanion toCompanion(bool nullToAbsent) {
    return PerformerProfilesCompanion(
      id: Value(id),
      stageName: Value(stageName),
      discipline: discipline == null && nullToAbsent
          ? const Value.absent()
          : Value(discipline),
      homeVenue: homeVenue == null && nullToAbsent
          ? const Value.absent()
          : Value(homeVenue),
      photoFileName: photoFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(photoFileName),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PerformerProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformerProfileRow(
      id: serializer.fromJson<int>(json['id']),
      stageName: serializer.fromJson<String>(json['stageName']),
      discipline: $PerformerProfilesTable.$converterdisciplinen.fromJson(
        serializer.fromJson<String?>(json['discipline']),
      ),
      homeVenue: serializer.fromJson<String?>(json['homeVenue']),
      photoFileName: serializer.fromJson<String?>(json['photoFileName']),
      bio: serializer.fromJson<String?>(json['bio']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stageName': serializer.toJson<String>(stageName),
      'discipline': serializer.toJson<String?>(
        $PerformerProfilesTable.$converterdisciplinen.toJson(discipline),
      ),
      'homeVenue': serializer.toJson<String?>(homeVenue),
      'photoFileName': serializer.toJson<String?>(photoFileName),
      'bio': serializer.toJson<String?>(bio),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PerformerProfileRow copyWith({
    int? id,
    String? stageName,
    Value<Discipline?> discipline = const Value.absent(),
    Value<String?> homeVenue = const Value.absent(),
    Value<String?> photoFileName = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PerformerProfileRow(
    id: id ?? this.id,
    stageName: stageName ?? this.stageName,
    discipline: discipline.present ? discipline.value : this.discipline,
    homeVenue: homeVenue.present ? homeVenue.value : this.homeVenue,
    photoFileName: photoFileName.present
        ? photoFileName.value
        : this.photoFileName,
    bio: bio.present ? bio.value : this.bio,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PerformerProfileRow copyWithCompanion(PerformerProfilesCompanion data) {
    return PerformerProfileRow(
      id: data.id.present ? data.id.value : this.id,
      stageName: data.stageName.present ? data.stageName.value : this.stageName,
      discipline: data.discipline.present
          ? data.discipline.value
          : this.discipline,
      homeVenue: data.homeVenue.present ? data.homeVenue.value : this.homeVenue,
      photoFileName: data.photoFileName.present
          ? data.photoFileName.value
          : this.photoFileName,
      bio: data.bio.present ? data.bio.value : this.bio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformerProfileRow(')
          ..write('id: $id, ')
          ..write('stageName: $stageName, ')
          ..write('discipline: $discipline, ')
          ..write('homeVenue: $homeVenue, ')
          ..write('photoFileName: $photoFileName, ')
          ..write('bio: $bio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stageName,
    discipline,
    homeVenue,
    photoFileName,
    bio,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformerProfileRow &&
          other.id == this.id &&
          other.stageName == this.stageName &&
          other.discipline == this.discipline &&
          other.homeVenue == this.homeVenue &&
          other.photoFileName == this.photoFileName &&
          other.bio == this.bio &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PerformerProfilesCompanion extends UpdateCompanion<PerformerProfileRow> {
  final Value<int> id;
  final Value<String> stageName;
  final Value<Discipline?> discipline;
  final Value<String?> homeVenue;
  final Value<String?> photoFileName;
  final Value<String?> bio;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PerformerProfilesCompanion({
    this.id = const Value.absent(),
    this.stageName = const Value.absent(),
    this.discipline = const Value.absent(),
    this.homeVenue = const Value.absent(),
    this.photoFileName = const Value.absent(),
    this.bio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PerformerProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.stageName = const Value.absent(),
    this.discipline = const Value.absent(),
    this.homeVenue = const Value.absent(),
    this.photoFileName = const Value.absent(),
    this.bio = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PerformerProfileRow> custom({
    Expression<int>? id,
    Expression<String>? stageName,
    Expression<String>? discipline,
    Expression<String>? homeVenue,
    Expression<String>? photoFileName,
    Expression<String>? bio,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stageName != null) 'stage_name': stageName,
      if (discipline != null) 'discipline': discipline,
      if (homeVenue != null) 'home_venue': homeVenue,
      if (photoFileName != null) 'photo_file_name': photoFileName,
      if (bio != null) 'bio': bio,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PerformerProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? stageName,
    Value<Discipline?>? discipline,
    Value<String?>? homeVenue,
    Value<String?>? photoFileName,
    Value<String?>? bio,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PerformerProfilesCompanion(
      id: id ?? this.id,
      stageName: stageName ?? this.stageName,
      discipline: discipline ?? this.discipline,
      homeVenue: homeVenue ?? this.homeVenue,
      photoFileName: photoFileName ?? this.photoFileName,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stageName.present) {
      map['stage_name'] = Variable<String>(stageName.value);
    }
    if (discipline.present) {
      map['discipline'] = Variable<String>(
        $PerformerProfilesTable.$converterdisciplinen.toSql(discipline.value),
      );
    }
    if (homeVenue.present) {
      map['home_venue'] = Variable<String>(homeVenue.value);
    }
    if (photoFileName.present) {
      map['photo_file_name'] = Variable<String>(photoFileName.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('stageName: $stageName, ')
          ..write('discipline: $discipline, ')
          ..write('homeVenue: $homeVenue, ')
          ..write('photoFileName: $photoFileName, ')
          ..write('bio: $bio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppPreferencesTable extends AppPreferences
    with TableInfo<$AppPreferencesTable, AppPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hapticsEnabledMeta = const VerificationMeta(
    'hapticsEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
    'haptics_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderHourMeta = const VerificationMeta(
    'reminderHour',
  );
  @override
  late final GeneratedColumn<int> reminderHour = GeneratedColumn<int>(
    'reminder_hour',
    aliasedName,
    false,
    check: () => ComparableExpr(reminderHour).isBetweenValues(0, 23),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(18),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    false,
    check: () => ComparableExpr(reminderMinute).isBetweenValues(0, 59),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reminderWeekdayMaskMeta =
      const VerificationMeta('reminderWeekdayMask');
  @override
  late final GeneratedColumn<int> reminderWeekdayMask = GeneratedColumn<int>(
    'reminder_weekday_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0x7F),
  );
  static const VerificationMeta _dailyReminderEnabledMeta =
      const VerificationMeta('dailyReminderEnabled');
  @override
  late final GeneratedColumn<bool> dailyReminderEnabled = GeneratedColumn<bool>(
    'daily_reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("daily_reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dailyReminderHourMeta = const VerificationMeta(
    'dailyReminderHour',
  );
  @override
  late final GeneratedColumn<int> dailyReminderHour = GeneratedColumn<int>(
    'daily_reminder_hour',
    aliasedName,
    false,
    check: () => ComparableExpr(dailyReminderHour).isBetweenValues(0, 23),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _dailyReminderMinuteMeta =
      const VerificationMeta('dailyReminderMinute');
  @override
  late final GeneratedColumn<int> dailyReminderMinute = GeneratedColumn<int>(
    'daily_reminder_minute',
    aliasedName,
    false,
    check: () => ComparableExpr(dailyReminderMinute).isBetweenValues(0, 59),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _catalogRevisionMeta = const VerificationMeta(
    'catalogRevision',
  );
  @override
  late final GeneratedColumn<int> catalogRevision = GeneratedColumn<int>(
    'catalog_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _defaultTargetSecondsMeta =
      const VerificationMeta('defaultTargetSeconds');
  @override
  late final GeneratedColumn<int> defaultTargetSeconds = GeneratedColumn<int>(
    'default_target_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(240),
  );
  static const VerificationMeta _decayEnabledMeta = const VerificationMeta(
    'decayEnabled',
  );
  @override
  late final GeneratedColumn<bool> decayEnabled = GeneratedColumn<bool>(
    'decay_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("decay_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    soundEnabled,
    hapticsEnabled,
    reminderEnabled,
    reminderHour,
    reminderMinute,
    reminderWeekdayMask,
    dailyReminderEnabled,
    dailyReminderHour,
    dailyReminderMinute,
    onboardingCompleted,
    catalogRevision,
    defaultTargetSeconds,
    decayEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
        _hapticsEnabledMeta,
        hapticsEnabled.isAcceptableOrUnknown(
          data['haptics_enabled']!,
          _hapticsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_hour')) {
      context.handle(
        _reminderHourMeta,
        reminderHour.isAcceptableOrUnknown(
          data['reminder_hour']!,
          _reminderHourMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('reminder_weekday_mask')) {
      context.handle(
        _reminderWeekdayMaskMeta,
        reminderWeekdayMask.isAcceptableOrUnknown(
          data['reminder_weekday_mask']!,
          _reminderWeekdayMaskMeta,
        ),
      );
    }
    if (data.containsKey('daily_reminder_enabled')) {
      context.handle(
        _dailyReminderEnabledMeta,
        dailyReminderEnabled.isAcceptableOrUnknown(
          data['daily_reminder_enabled']!,
          _dailyReminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('daily_reminder_hour')) {
      context.handle(
        _dailyReminderHourMeta,
        dailyReminderHour.isAcceptableOrUnknown(
          data['daily_reminder_hour']!,
          _dailyReminderHourMeta,
        ),
      );
    }
    if (data.containsKey('daily_reminder_minute')) {
      context.handle(
        _dailyReminderMinuteMeta,
        dailyReminderMinute.isAcceptableOrUnknown(
          data['daily_reminder_minute']!,
          _dailyReminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('catalog_revision')) {
      context.handle(
        _catalogRevisionMeta,
        catalogRevision.isAcceptableOrUnknown(
          data['catalog_revision']!,
          _catalogRevisionMeta,
        ),
      );
    }
    if (data.containsKey('default_target_seconds')) {
      context.handle(
        _defaultTargetSecondsMeta,
        defaultTargetSeconds.isAcceptableOrUnknown(
          data['default_target_seconds']!,
          _defaultTargetSecondsMeta,
        ),
      );
    }
    if (data.containsKey('decay_enabled')) {
      context.handle(
        _decayEnabledMeta,
        decayEnabled.isAcceptableOrUnknown(
          data['decay_enabled']!,
          _decayEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppPreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreferenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      hapticsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics_enabled'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_hour'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      )!,
      reminderWeekdayMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_weekday_mask'],
      )!,
      dailyReminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}daily_reminder_enabled'],
      )!,
      dailyReminderHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_reminder_hour'],
      )!,
      dailyReminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_reminder_minute'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      catalogRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}catalog_revision'],
      )!,
      defaultTargetSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_target_seconds'],
      )!,
      decayEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}decay_enabled'],
      )!,
    );
  }

  @override
  $AppPreferencesTable createAlias(String alias) {
    return $AppPreferencesTable(attachedDatabase, alias);
  }
}

class AppPreferenceRow extends DataClass
    implements Insertable<AppPreferenceRow> {
  final int id;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  /// Bit per ISO weekday, bit 0 = Monday. Defaults to every day.
  final int reminderWeekdayMask;

  /// Daily nudge, independent of the weekly rehearsal reminder above.
  ///
  /// Kept as its own set of columns rather than reused because the two
  /// reminders answer different questions: the weekly one is a rehearsal
  /// schedule, the daily one is a simple showtime nudge with a rotating
  /// message. They can be on or off independently.
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool onboardingCompleted;

  /// Revision of the bundled trick catalogue already merged into `tricks`.
  final int catalogRevision;

  /// Pre-filled target running time when creating a new act, in seconds.
  final int defaultTargetSeconds;

  /// When on, the mastery-decay pass runs at launch: tricks not rehearsed for
  /// long enough drop one notch, so an act that has been left alone loses
  /// readiness without needing the user to relabel anything.
  final bool decayEnabled;
  const AppPreferenceRow({
    required this.id,
    required this.soundEnabled,
    required this.hapticsEnabled,
    required this.reminderEnabled,
    required this.reminderHour,
    required this.reminderMinute,
    required this.reminderWeekdayMask,
    required this.dailyReminderEnabled,
    required this.dailyReminderHour,
    required this.dailyReminderMinute,
    required this.onboardingCompleted,
    required this.catalogRevision,
    required this.defaultTargetSeconds,
    required this.decayEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_hour'] = Variable<int>(reminderHour);
    map['reminder_minute'] = Variable<int>(reminderMinute);
    map['reminder_weekday_mask'] = Variable<int>(reminderWeekdayMask);
    map['daily_reminder_enabled'] = Variable<bool>(dailyReminderEnabled);
    map['daily_reminder_hour'] = Variable<int>(dailyReminderHour);
    map['daily_reminder_minute'] = Variable<int>(dailyReminderMinute);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['catalog_revision'] = Variable<int>(catalogRevision);
    map['default_target_seconds'] = Variable<int>(defaultTargetSeconds);
    map['decay_enabled'] = Variable<bool>(decayEnabled);
    return map;
  }

  AppPreferencesCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesCompanion(
      id: Value(id),
      soundEnabled: Value(soundEnabled),
      hapticsEnabled: Value(hapticsEnabled),
      reminderEnabled: Value(reminderEnabled),
      reminderHour: Value(reminderHour),
      reminderMinute: Value(reminderMinute),
      reminderWeekdayMask: Value(reminderWeekdayMask),
      dailyReminderEnabled: Value(dailyReminderEnabled),
      dailyReminderHour: Value(dailyReminderHour),
      dailyReminderMinute: Value(dailyReminderMinute),
      onboardingCompleted: Value(onboardingCompleted),
      catalogRevision: Value(catalogRevision),
      defaultTargetSeconds: Value(defaultTargetSeconds),
      decayEnabled: Value(decayEnabled),
    );
  }

  factory AppPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreferenceRow(
      id: serializer.fromJson<int>(json['id']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderHour: serializer.fromJson<int>(json['reminderHour']),
      reminderMinute: serializer.fromJson<int>(json['reminderMinute']),
      reminderWeekdayMask: serializer.fromJson<int>(
        json['reminderWeekdayMask'],
      ),
      dailyReminderEnabled: serializer.fromJson<bool>(
        json['dailyReminderEnabled'],
      ),
      dailyReminderHour: serializer.fromJson<int>(json['dailyReminderHour']),
      dailyReminderMinute: serializer.fromJson<int>(
        json['dailyReminderMinute'],
      ),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      catalogRevision: serializer.fromJson<int>(json['catalogRevision']),
      defaultTargetSeconds: serializer.fromJson<int>(
        json['defaultTargetSeconds'],
      ),
      decayEnabled: serializer.fromJson<bool>(json['decayEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderHour': serializer.toJson<int>(reminderHour),
      'reminderMinute': serializer.toJson<int>(reminderMinute),
      'reminderWeekdayMask': serializer.toJson<int>(reminderWeekdayMask),
      'dailyReminderEnabled': serializer.toJson<bool>(dailyReminderEnabled),
      'dailyReminderHour': serializer.toJson<int>(dailyReminderHour),
      'dailyReminderMinute': serializer.toJson<int>(dailyReminderMinute),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'catalogRevision': serializer.toJson<int>(catalogRevision),
      'defaultTargetSeconds': serializer.toJson<int>(defaultTargetSeconds),
      'decayEnabled': serializer.toJson<bool>(decayEnabled),
    };
  }

  AppPreferenceRow copyWith({
    int? id,
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    int? reminderWeekdayMask,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? onboardingCompleted,
    int? catalogRevision,
    int? defaultTargetSeconds,
    bool? decayEnabled,
  }) => AppPreferenceRow(
    id: id ?? this.id,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderHour: reminderHour ?? this.reminderHour,
    reminderMinute: reminderMinute ?? this.reminderMinute,
    reminderWeekdayMask: reminderWeekdayMask ?? this.reminderWeekdayMask,
    dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
    dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
    dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    catalogRevision: catalogRevision ?? this.catalogRevision,
    defaultTargetSeconds: defaultTargetSeconds ?? this.defaultTargetSeconds,
    decayEnabled: decayEnabled ?? this.decayEnabled,
  );
  AppPreferenceRow copyWithCompanion(AppPreferencesCompanion data) {
    return AppPreferenceRow(
      id: data.id.present ? data.id.value : this.id,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderHour: data.reminderHour.present
          ? data.reminderHour.value
          : this.reminderHour,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
      reminderWeekdayMask: data.reminderWeekdayMask.present
          ? data.reminderWeekdayMask.value
          : this.reminderWeekdayMask,
      dailyReminderEnabled: data.dailyReminderEnabled.present
          ? data.dailyReminderEnabled.value
          : this.dailyReminderEnabled,
      dailyReminderHour: data.dailyReminderHour.present
          ? data.dailyReminderHour.value
          : this.dailyReminderHour,
      dailyReminderMinute: data.dailyReminderMinute.present
          ? data.dailyReminderMinute.value
          : this.dailyReminderMinute,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      catalogRevision: data.catalogRevision.present
          ? data.catalogRevision.value
          : this.catalogRevision,
      defaultTargetSeconds: data.defaultTargetSeconds.present
          ? data.defaultTargetSeconds.value
          : this.defaultTargetSeconds,
      decayEnabled: data.decayEnabled.present
          ? data.decayEnabled.value
          : this.decayEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferenceRow(')
          ..write('id: $id, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('reminderWeekdayMask: $reminderWeekdayMask, ')
          ..write('dailyReminderEnabled: $dailyReminderEnabled, ')
          ..write('dailyReminderHour: $dailyReminderHour, ')
          ..write('dailyReminderMinute: $dailyReminderMinute, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('catalogRevision: $catalogRevision, ')
          ..write('defaultTargetSeconds: $defaultTargetSeconds, ')
          ..write('decayEnabled: $decayEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    soundEnabled,
    hapticsEnabled,
    reminderEnabled,
    reminderHour,
    reminderMinute,
    reminderWeekdayMask,
    dailyReminderEnabled,
    dailyReminderHour,
    dailyReminderMinute,
    onboardingCompleted,
    catalogRevision,
    defaultTargetSeconds,
    decayEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreferenceRow &&
          other.id == this.id &&
          other.soundEnabled == this.soundEnabled &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderHour == this.reminderHour &&
          other.reminderMinute == this.reminderMinute &&
          other.reminderWeekdayMask == this.reminderWeekdayMask &&
          other.dailyReminderEnabled == this.dailyReminderEnabled &&
          other.dailyReminderHour == this.dailyReminderHour &&
          other.dailyReminderMinute == this.dailyReminderMinute &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.catalogRevision == this.catalogRevision &&
          other.defaultTargetSeconds == this.defaultTargetSeconds &&
          other.decayEnabled == this.decayEnabled);
}

class AppPreferencesCompanion extends UpdateCompanion<AppPreferenceRow> {
  final Value<int> id;
  final Value<bool> soundEnabled;
  final Value<bool> hapticsEnabled;
  final Value<bool> reminderEnabled;
  final Value<int> reminderHour;
  final Value<int> reminderMinute;
  final Value<int> reminderWeekdayMask;
  final Value<bool> dailyReminderEnabled;
  final Value<int> dailyReminderHour;
  final Value<int> dailyReminderMinute;
  final Value<bool> onboardingCompleted;
  final Value<int> catalogRevision;
  final Value<int> defaultTargetSeconds;
  final Value<bool> decayEnabled;
  const AppPreferencesCompanion({
    this.id = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.reminderWeekdayMask = const Value.absent(),
    this.dailyReminderEnabled = const Value.absent(),
    this.dailyReminderHour = const Value.absent(),
    this.dailyReminderMinute = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.catalogRevision = const Value.absent(),
    this.defaultTargetSeconds = const Value.absent(),
    this.decayEnabled = const Value.absent(),
  });
  AppPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.reminderWeekdayMask = const Value.absent(),
    this.dailyReminderEnabled = const Value.absent(),
    this.dailyReminderHour = const Value.absent(),
    this.dailyReminderMinute = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.catalogRevision = const Value.absent(),
    this.defaultTargetSeconds = const Value.absent(),
    this.decayEnabled = const Value.absent(),
  });
  static Insertable<AppPreferenceRow> custom({
    Expression<int>? id,
    Expression<bool>? soundEnabled,
    Expression<bool>? hapticsEnabled,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderHour,
    Expression<int>? reminderMinute,
    Expression<int>? reminderWeekdayMask,
    Expression<bool>? dailyReminderEnabled,
    Expression<int>? dailyReminderHour,
    Expression<int>? dailyReminderMinute,
    Expression<bool>? onboardingCompleted,
    Expression<int>? catalogRevision,
    Expression<int>? defaultTargetSeconds,
    Expression<bool>? decayEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderHour != null) 'reminder_hour': reminderHour,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
      if (reminderWeekdayMask != null)
        'reminder_weekday_mask': reminderWeekdayMask,
      if (dailyReminderEnabled != null)
        'daily_reminder_enabled': dailyReminderEnabled,
      if (dailyReminderHour != null) 'daily_reminder_hour': dailyReminderHour,
      if (dailyReminderMinute != null)
        'daily_reminder_minute': dailyReminderMinute,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (catalogRevision != null) 'catalog_revision': catalogRevision,
      if (defaultTargetSeconds != null)
        'default_target_seconds': defaultTargetSeconds,
      if (decayEnabled != null) 'decay_enabled': decayEnabled,
    });
  }

  AppPreferencesCompanion copyWith({
    Value<int>? id,
    Value<bool>? soundEnabled,
    Value<bool>? hapticsEnabled,
    Value<bool>? reminderEnabled,
    Value<int>? reminderHour,
    Value<int>? reminderMinute,
    Value<int>? reminderWeekdayMask,
    Value<bool>? dailyReminderEnabled,
    Value<int>? dailyReminderHour,
    Value<int>? dailyReminderMinute,
    Value<bool>? onboardingCompleted,
    Value<int>? catalogRevision,
    Value<int>? defaultTargetSeconds,
    Value<bool>? decayEnabled,
  }) {
    return AppPreferencesCompanion(
      id: id ?? this.id,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      reminderWeekdayMask: reminderWeekdayMask ?? this.reminderWeekdayMask,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      catalogRevision: catalogRevision ?? this.catalogRevision,
      defaultTargetSeconds: defaultTargetSeconds ?? this.defaultTargetSeconds,
      decayEnabled: decayEnabled ?? this.decayEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderHour.present) {
      map['reminder_hour'] = Variable<int>(reminderHour.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    if (reminderWeekdayMask.present) {
      map['reminder_weekday_mask'] = Variable<int>(reminderWeekdayMask.value);
    }
    if (dailyReminderEnabled.present) {
      map['daily_reminder_enabled'] = Variable<bool>(
        dailyReminderEnabled.value,
      );
    }
    if (dailyReminderHour.present) {
      map['daily_reminder_hour'] = Variable<int>(dailyReminderHour.value);
    }
    if (dailyReminderMinute.present) {
      map['daily_reminder_minute'] = Variable<int>(dailyReminderMinute.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (catalogRevision.present) {
      map['catalog_revision'] = Variable<int>(catalogRevision.value);
    }
    if (defaultTargetSeconds.present) {
      map['default_target_seconds'] = Variable<int>(defaultTargetSeconds.value);
    }
    if (decayEnabled.present) {
      map['decay_enabled'] = Variable<bool>(decayEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('reminderWeekdayMask: $reminderWeekdayMask, ')
          ..write('dailyReminderEnabled: $dailyReminderEnabled, ')
          ..write('dailyReminderHour: $dailyReminderHour, ')
          ..write('dailyReminderMinute: $dailyReminderMinute, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('catalogRevision: $catalogRevision, ')
          ..write('defaultTargetSeconds: $defaultTargetSeconds, ')
          ..write('decayEnabled: $decayEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TricksTable tricks = $TricksTable(this);
  late final $ActsTable acts = $ActsTable(this);
  late final $ActBlocksTable actBlocks = $ActBlocksTable(this);
  late final $RunOrderItemsTable runOrderItems = $RunOrderItemsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $StagePlotItemsTable stagePlotItems = $StagePlotItemsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $RehearsalsTable rehearsals = $RehearsalsTable(this);
  late final $PerformerProfilesTable performerProfiles =
      $PerformerProfilesTable(this);
  late final $AppPreferencesTable appPreferences = $AppPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tricks,
    acts,
    actBlocks,
    runOrderItems,
    checklistItems,
    stagePlotItems,
    notes,
    rehearsals,
    performerProfiles,
    appPreferences,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'acts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('act_blocks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'act_blocks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('run_order_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tricks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('run_order_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'acts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('checklist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'acts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stage_plot_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'acts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'acts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rehearsals', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TricksTableCreateCompanionBuilder =
    TricksCompanion Function({
      Value<int> id,
      Value<String?> slug,
      required String name,
      required Discipline discipline,
      Value<int> difficulty,
      Value<Mastery> mastery,
      Value<String> summary,
      Value<String?> setupNote,
      Value<String?> safetyNote,
      Value<int> typicalSeconds,
      Value<bool> isCatalog,
      Value<bool> isArchived,
      Value<int> timesRehearsed,
      Value<DateTime?> lastRehearsedAt,
      Value<DateTime?> masteryDecayedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$TricksTableUpdateCompanionBuilder =
    TricksCompanion Function({
      Value<int> id,
      Value<String?> slug,
      Value<String> name,
      Value<Discipline> discipline,
      Value<int> difficulty,
      Value<Mastery> mastery,
      Value<String> summary,
      Value<String?> setupNote,
      Value<String?> safetyNote,
      Value<int> typicalSeconds,
      Value<bool> isCatalog,
      Value<bool> isArchived,
      Value<int> timesRehearsed,
      Value<DateTime?> lastRehearsedAt,
      Value<DateTime?> masteryDecayedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TricksTableReferences
    extends BaseReferences<_$AppDatabase, $TricksTable, TrickRow> {
  $$TricksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RunOrderItemsTable, List<RunOrderItemRow>>
  _runOrderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runOrderItems,
    aliasName: 'tricks__id__run_order_items__trick_id',
  );

  $$RunOrderItemsTableProcessedTableManager get runOrderItemsRefs {
    final manager = $$RunOrderItemsTableTableManager(
      $_db,
      $_db.runOrderItems,
    ).filter((f) => f.trickId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_runOrderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TricksTableFilterComposer
    extends Composer<_$AppDatabase, $TricksTable> {
  $$TricksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Discipline, Discipline, String>
  get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Mastery, Mastery, String> get mastery =>
      $composableBuilder(
        column: $table.mastery,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setupNote => $composableBuilder(
    column: $table.setupNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get safetyNote => $composableBuilder(
    column: $table.safetyNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typicalSeconds => $composableBuilder(
    column: $table.typicalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCatalog => $composableBuilder(
    column: $table.isCatalog,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesRehearsed => $composableBuilder(
    column: $table.timesRehearsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRehearsedAt => $composableBuilder(
    column: $table.lastRehearsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get masteryDecayedAt => $composableBuilder(
    column: $table.masteryDecayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> runOrderItemsRefs(
    Expression<bool> Function($$RunOrderItemsTableFilterComposer f) f,
  ) {
    final $$RunOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runOrderItems,
      getReferencedColumn: (t) => t.trickId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.runOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TricksTableOrderingComposer
    extends Composer<_$AppDatabase, $TricksTable> {
  $$TricksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mastery => $composableBuilder(
    column: $table.mastery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setupNote => $composableBuilder(
    column: $table.setupNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get safetyNote => $composableBuilder(
    column: $table.safetyNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typicalSeconds => $composableBuilder(
    column: $table.typicalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCatalog => $composableBuilder(
    column: $table.isCatalog,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesRehearsed => $composableBuilder(
    column: $table.timesRehearsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRehearsedAt => $composableBuilder(
    column: $table.lastRehearsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get masteryDecayedAt => $composableBuilder(
    column: $table.masteryDecayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TricksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TricksTable> {
  $$TricksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Discipline, String> get discipline =>
      $composableBuilder(
        column: $table.discipline,
        builder: (column) => column,
      );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Mastery, String> get mastery =>
      $composableBuilder(column: $table.mastery, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get setupNote =>
      $composableBuilder(column: $table.setupNote, builder: (column) => column);

  GeneratedColumn<String> get safetyNote => $composableBuilder(
    column: $table.safetyNote,
    builder: (column) => column,
  );

  GeneratedColumn<int> get typicalSeconds => $composableBuilder(
    column: $table.typicalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCatalog =>
      $composableBuilder(column: $table.isCatalog, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesRehearsed => $composableBuilder(
    column: $table.timesRehearsed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRehearsedAt => $composableBuilder(
    column: $table.lastRehearsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get masteryDecayedAt => $composableBuilder(
    column: $table.masteryDecayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> runOrderItemsRefs<T extends Object>(
    Expression<T> Function($$RunOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$RunOrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runOrderItems,
      getReferencedColumn: (t) => t.trickId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunOrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.runOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TricksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TricksTable,
          TrickRow,
          $$TricksTableFilterComposer,
          $$TricksTableOrderingComposer,
          $$TricksTableAnnotationComposer,
          $$TricksTableCreateCompanionBuilder,
          $$TricksTableUpdateCompanionBuilder,
          (TrickRow, $$TricksTableReferences),
          TrickRow,
          PrefetchHooks Function({bool runOrderItemsRefs})
        > {
  $$TricksTableTableManager(_$AppDatabase db, $TricksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TricksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TricksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TricksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Discipline> discipline = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<Mastery> mastery = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String?> setupNote = const Value.absent(),
                Value<String?> safetyNote = const Value.absent(),
                Value<int> typicalSeconds = const Value.absent(),
                Value<bool> isCatalog = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> timesRehearsed = const Value.absent(),
                Value<DateTime?> lastRehearsedAt = const Value.absent(),
                Value<DateTime?> masteryDecayedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TricksCompanion(
                id: id,
                slug: slug,
                name: name,
                discipline: discipline,
                difficulty: difficulty,
                mastery: mastery,
                summary: summary,
                setupNote: setupNote,
                safetyNote: safetyNote,
                typicalSeconds: typicalSeconds,
                isCatalog: isCatalog,
                isArchived: isArchived,
                timesRehearsed: timesRehearsed,
                lastRehearsedAt: lastRehearsedAt,
                masteryDecayedAt: masteryDecayedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> slug = const Value.absent(),
                required String name,
                required Discipline discipline,
                Value<int> difficulty = const Value.absent(),
                Value<Mastery> mastery = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String?> setupNote = const Value.absent(),
                Value<String?> safetyNote = const Value.absent(),
                Value<int> typicalSeconds = const Value.absent(),
                Value<bool> isCatalog = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> timesRehearsed = const Value.absent(),
                Value<DateTime?> lastRehearsedAt = const Value.absent(),
                Value<DateTime?> masteryDecayedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TricksCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                discipline: discipline,
                difficulty: difficulty,
                mastery: mastery,
                summary: summary,
                setupNote: setupNote,
                safetyNote: safetyNote,
                typicalSeconds: typicalSeconds,
                isCatalog: isCatalog,
                isArchived: isArchived,
                timesRehearsed: timesRehearsed,
                lastRehearsedAt: lastRehearsedAt,
                masteryDecayedAt: masteryDecayedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TricksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({runOrderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (runOrderItemsRefs) db.runOrderItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (runOrderItemsRefs)
                    await $_getPrefetchedData<
                      TrickRow,
                      $TricksTable,
                      RunOrderItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$TricksTableReferences
                          ._runOrderItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TricksTableReferences(
                        db,
                        table,
                        p0,
                      ).runOrderItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.trickId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TricksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TricksTable,
      TrickRow,
      $$TricksTableFilterComposer,
      $$TricksTableOrderingComposer,
      $$TricksTableAnnotationComposer,
      $$TricksTableCreateCompanionBuilder,
      $$TricksTableUpdateCompanionBuilder,
      (TrickRow, $$TricksTableReferences),
      TrickRow,
      PrefetchHooks Function({bool runOrderItemsRefs})
    >;
typedef $$ActsTableCreateCompanionBuilder =
    ActsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> subtitle,
      Value<String?> venue,
      Value<ActStatus> status,
      Value<ActEmblem> emblem,
      Value<CueFrameStyle> cueFrame,
      Value<int> targetSeconds,
      Value<DateTime?> performanceDate,
      Value<String?> summary,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> lastOpenedAt,
    });
typedef $$ActsTableUpdateCompanionBuilder =
    ActsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> subtitle,
      Value<String?> venue,
      Value<ActStatus> status,
      Value<ActEmblem> emblem,
      Value<CueFrameStyle> cueFrame,
      Value<int> targetSeconds,
      Value<DateTime?> performanceDate,
      Value<String?> summary,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastOpenedAt,
    });

final class $$ActsTableReferences
    extends BaseReferences<_$AppDatabase, $ActsTable, ActRow> {
  $$ActsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ActBlocksTable, List<ActBlockRow>>
  _actBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.actBlocks,
    aliasName: 'acts__id__act_blocks__act_id',
  );

  $$ActBlocksTableProcessedTableManager get actBlocksRefs {
    final manager = $$ActBlocksTableTableManager(
      $_db,
      $_db.actBlocks,
    ).filter((f) => f.actId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_actBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItemRow>>
  _checklistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklistItems,
    aliasName: 'acts__id__checklist_items__act_id',
  );

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.actId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StagePlotItemsTable, List<StagePlotItemRow>>
  _stagePlotItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stagePlotItems,
    aliasName: 'acts__id__stage_plot_items__act_id',
  );

  $$StagePlotItemsTableProcessedTableManager get stagePlotItemsRefs {
    final manager = $$StagePlotItemsTableTableManager(
      $_db,
      $_db.stagePlotItems,
    ).filter((f) => f.actId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stagePlotItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'acts__id__notes__act_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.actId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RehearsalsTable, List<RehearsalRow>>
  _rehearsalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rehearsals,
    aliasName: 'acts__id__rehearsals__act_id',
  );

  $$RehearsalsTableProcessedTableManager get rehearsalsRefs {
    final manager = $$RehearsalsTableTableManager(
      $_db,
      $_db.rehearsals,
    ).filter((f) => f.actId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rehearsalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActsTableFilterComposer extends Composer<_$AppDatabase, $ActsTable> {
  $$ActsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActStatus, ActStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ActEmblem, ActEmblem, String> get emblem =>
      $composableBuilder(
        column: $table.emblem,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<CueFrameStyle, CueFrameStyle, String>
  get cueFrame => $composableBuilder(
    column: $table.cueFrame,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performanceDate => $composableBuilder(
    column: $table.performanceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> actBlocksRefs(
    Expression<bool> Function($$ActBlocksTableFilterComposer f) f,
  ) {
    final $$ActBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actBlocks,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActBlocksTableFilterComposer(
            $db: $db,
            $table: $db.actBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checklistItemsRefs(
    Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f,
  ) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stagePlotItemsRefs(
    Expression<bool> Function($$StagePlotItemsTableFilterComposer f) f,
  ) {
    final $$StagePlotItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stagePlotItems,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagePlotItemsTableFilterComposer(
            $db: $db,
            $table: $db.stagePlotItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rehearsalsRefs(
    Expression<bool> Function($$RehearsalsTableFilterComposer f) f,
  ) {
    final $$RehearsalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rehearsals,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RehearsalsTableFilterComposer(
            $db: $db,
            $table: $db.rehearsals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActsTableOrderingComposer extends Composer<_$AppDatabase, $ActsTable> {
  $$ActsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emblem => $composableBuilder(
    column: $table.emblem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueFrame => $composableBuilder(
    column: $table.cueFrame,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performanceDate => $composableBuilder(
    column: $table.performanceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActsTable> {
  $$ActsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get venue =>
      $composableBuilder(column: $table.venue, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActEmblem, String> get emblem =>
      $composableBuilder(column: $table.emblem, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CueFrameStyle, String> get cueFrame =>
      $composableBuilder(column: $table.cueFrame, builder: (column) => column);

  GeneratedColumn<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get performanceDate => $composableBuilder(
    column: $table.performanceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  Expression<T> actBlocksRefs<T extends Object>(
    Expression<T> Function($$ActBlocksTableAnnotationComposer a) f,
  ) {
    final $$ActBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actBlocks,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.actBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checklistItemsRefs<T extends Object>(
    Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stagePlotItemsRefs<T extends Object>(
    Expression<T> Function($$StagePlotItemsTableAnnotationComposer a) f,
  ) {
    final $$StagePlotItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stagePlotItems,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagePlotItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.stagePlotItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rehearsalsRefs<T extends Object>(
    Expression<T> Function($$RehearsalsTableAnnotationComposer a) f,
  ) {
    final $$RehearsalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rehearsals,
      getReferencedColumn: (t) => t.actId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RehearsalsTableAnnotationComposer(
            $db: $db,
            $table: $db.rehearsals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActsTable,
          ActRow,
          $$ActsTableFilterComposer,
          $$ActsTableOrderingComposer,
          $$ActsTableAnnotationComposer,
          $$ActsTableCreateCompanionBuilder,
          $$ActsTableUpdateCompanionBuilder,
          (ActRow, $$ActsTableReferences),
          ActRow,
          PrefetchHooks Function({
            bool actBlocksRefs,
            bool checklistItemsRefs,
            bool stagePlotItemsRefs,
            bool notesRefs,
            bool rehearsalsRefs,
          })
        > {
  $$ActsTableTableManager(_$AppDatabase db, $ActsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> venue = const Value.absent(),
                Value<ActStatus> status = const Value.absent(),
                Value<ActEmblem> emblem = const Value.absent(),
                Value<CueFrameStyle> cueFrame = const Value.absent(),
                Value<int> targetSeconds = const Value.absent(),
                Value<DateTime?> performanceDate = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => ActsCompanion(
                id: id,
                title: title,
                subtitle: subtitle,
                venue: venue,
                status: status,
                emblem: emblem,
                cueFrame: cueFrame,
                targetSeconds: targetSeconds,
                performanceDate: performanceDate,
                summary: summary,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String?> venue = const Value.absent(),
                Value<ActStatus> status = const Value.absent(),
                Value<ActEmblem> emblem = const Value.absent(),
                Value<CueFrameStyle> cueFrame = const Value.absent(),
                Value<int> targetSeconds = const Value.absent(),
                Value<DateTime?> performanceDate = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastOpenedAt = const Value.absent(),
              }) => ActsCompanion.insert(
                id: id,
                title: title,
                subtitle: subtitle,
                venue: venue,
                status: status,
                emblem: emblem,
                cueFrame: cueFrame,
                targetSeconds: targetSeconds,
                performanceDate: performanceDate,
                summary: summary,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastOpenedAt: lastOpenedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ActsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                actBlocksRefs = false,
                checklistItemsRefs = false,
                stagePlotItemsRefs = false,
                notesRefs = false,
                rehearsalsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (actBlocksRefs) db.actBlocks,
                    if (checklistItemsRefs) db.checklistItems,
                    if (stagePlotItemsRefs) db.stagePlotItems,
                    if (notesRefs) db.notes,
                    if (rehearsalsRefs) db.rehearsals,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (actBlocksRefs)
                        await $_getPrefetchedData<
                          ActRow,
                          $ActsTable,
                          ActBlockRow
                        >(
                          currentTable: table,
                          referencedTable: $$ActsTableReferences
                              ._actBlocksRefsTable(db),
                          managerFromTypedResult: (p0) => $$ActsTableReferences(
                            db,
                            table,
                            p0,
                          ).actBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (checklistItemsRefs)
                        await $_getPrefetchedData<
                          ActRow,
                          $ActsTable,
                          ChecklistItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ActsTableReferences
                              ._checklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) => $$ActsTableReferences(
                            db,
                            table,
                            p0,
                          ).checklistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stagePlotItemsRefs)
                        await $_getPrefetchedData<
                          ActRow,
                          $ActsTable,
                          StagePlotItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ActsTableReferences
                              ._stagePlotItemsRefsTable(db),
                          managerFromTypedResult: (p0) => $$ActsTableReferences(
                            db,
                            table,
                            p0,
                          ).stagePlotItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<ActRow, $ActsTable, NoteRow>(
                          currentTable: table,
                          referencedTable: $$ActsTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActsTableReferences(db, table, p0).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rehearsalsRefs)
                        await $_getPrefetchedData<
                          ActRow,
                          $ActsTable,
                          RehearsalRow
                        >(
                          currentTable: table,
                          referencedTable: $$ActsTableReferences
                              ._rehearsalsRefsTable(db),
                          managerFromTypedResult: (p0) => $$ActsTableReferences(
                            db,
                            table,
                            p0,
                          ).rehearsalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActsTable,
      ActRow,
      $$ActsTableFilterComposer,
      $$ActsTableOrderingComposer,
      $$ActsTableAnnotationComposer,
      $$ActsTableCreateCompanionBuilder,
      $$ActsTableUpdateCompanionBuilder,
      (ActRow, $$ActsTableReferences),
      ActRow,
      PrefetchHooks Function({
        bool actBlocksRefs,
        bool checklistItemsRefs,
        bool stagePlotItemsRefs,
        bool notesRefs,
        bool rehearsalsRefs,
      })
    >;
typedef $$ActBlocksTableCreateCompanionBuilder =
    ActBlocksCompanion Function({
      Value<int> id,
      required int actId,
      required BlockRole role,
      required String title,
      Value<String?> intent,
      Value<int> plannedSeconds,
      required int position,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ActBlocksTableUpdateCompanionBuilder =
    ActBlocksCompanion Function({
      Value<int> id,
      Value<int> actId,
      Value<BlockRole> role,
      Value<String> title,
      Value<String?> intent,
      Value<int> plannedSeconds,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ActBlocksTableReferences
    extends BaseReferences<_$AppDatabase, $ActBlocksTable, ActBlockRow> {
  $$ActBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActsTable _actIdTable(_$AppDatabase db) =>
      db.acts.createAlias('act_blocks__act_id__acts__id');

  $$ActsTableProcessedTableManager get actId {
    final $_column = $_itemColumn<int>('act_id')!;

    final manager = $$ActsTableTableManager(
      $_db,
      $_db.acts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RunOrderItemsTable, List<RunOrderItemRow>>
  _runOrderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runOrderItems,
    aliasName: 'act_blocks__id__run_order_items__block_id',
  );

  $$RunOrderItemsTableProcessedTableManager get runOrderItemsRefs {
    final manager = $$RunOrderItemsTableTableManager(
      $_db,
      $_db.runOrderItems,
    ).filter((f) => f.blockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_runOrderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $ActBlocksTable> {
  $$ActBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BlockRole, BlockRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intent => $composableBuilder(
    column: $table.intent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActsTableFilterComposer get actId {
    final $$ActsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableFilterComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> runOrderItemsRefs(
    Expression<bool> Function($$RunOrderItemsTableFilterComposer f) f,
  ) {
    final $$RunOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runOrderItems,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.runOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $ActBlocksTable> {
  $$ActBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intent => $composableBuilder(
    column: $table.intent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActsTableOrderingComposer get actId {
    final $$ActsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableOrderingComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActBlocksTable> {
  $$ActBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BlockRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get intent =>
      $composableBuilder(column: $table.intent, builder: (column) => column);

  GeneratedColumn<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ActsTableAnnotationComposer get actId {
    final $$ActsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableAnnotationComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> runOrderItemsRefs<T extends Object>(
    Expression<T> Function($$RunOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$RunOrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runOrderItems,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunOrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.runOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActBlocksTable,
          ActBlockRow,
          $$ActBlocksTableFilterComposer,
          $$ActBlocksTableOrderingComposer,
          $$ActBlocksTableAnnotationComposer,
          $$ActBlocksTableCreateCompanionBuilder,
          $$ActBlocksTableUpdateCompanionBuilder,
          (ActBlockRow, $$ActBlocksTableReferences),
          ActBlockRow,
          PrefetchHooks Function({bool actId, bool runOrderItemsRefs})
        > {
  $$ActBlocksTableTableManager(_$AppDatabase db, $ActBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> actId = const Value.absent(),
                Value<BlockRole> role = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> intent = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ActBlocksCompanion(
                id: id,
                actId: actId,
                role: role,
                title: title,
                intent: intent,
                plannedSeconds: plannedSeconds,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int actId,
                required BlockRole role,
                required String title,
                Value<String?> intent = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                required int position,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ActBlocksCompanion.insert(
                id: id,
                actId: actId,
                role: role,
                title: title,
                intent: intent,
                plannedSeconds: plannedSeconds,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actId = false, runOrderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (runOrderItemsRefs) db.runOrderItems,
              ],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actId,
                                referencedTable: $$ActBlocksTableReferences
                                    ._actIdTable(db),
                                referencedColumn: $$ActBlocksTableReferences
                                    ._actIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (runOrderItemsRefs)
                    await $_getPrefetchedData<
                      ActBlockRow,
                      $ActBlocksTable,
                      RunOrderItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$ActBlocksTableReferences
                          ._runOrderItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ActBlocksTableReferences(
                            db,
                            table,
                            p0,
                          ).runOrderItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.blockId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ActBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActBlocksTable,
      ActBlockRow,
      $$ActBlocksTableFilterComposer,
      $$ActBlocksTableOrderingComposer,
      $$ActBlocksTableAnnotationComposer,
      $$ActBlocksTableCreateCompanionBuilder,
      $$ActBlocksTableUpdateCompanionBuilder,
      (ActBlockRow, $$ActBlocksTableReferences),
      ActBlockRow,
      PrefetchHooks Function({bool actId, bool runOrderItemsRefs})
    >;
typedef $$RunOrderItemsTableCreateCompanionBuilder =
    RunOrderItemsCompanion Function({
      Value<int> id,
      required int blockId,
      Value<int?> trickId,
      required String label,
      Value<String?> cueNote,
      Value<int> seconds,
      required int position,
      Value<bool> isConfirmed,
    });
typedef $$RunOrderItemsTableUpdateCompanionBuilder =
    RunOrderItemsCompanion Function({
      Value<int> id,
      Value<int> blockId,
      Value<int?> trickId,
      Value<String> label,
      Value<String?> cueNote,
      Value<int> seconds,
      Value<int> position,
      Value<bool> isConfirmed,
    });

final class $$RunOrderItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RunOrderItemsTable, RunOrderItemRow> {
  $$RunOrderItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActBlocksTable _blockIdTable(_$AppDatabase db) =>
      db.actBlocks.createAlias('run_order_items__block_id__act_blocks__id');

  $$ActBlocksTableProcessedTableManager get blockId {
    final $_column = $_itemColumn<int>('block_id')!;

    final manager = $$ActBlocksTableTableManager(
      $_db,
      $_db.actBlocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TricksTable _trickIdTable(_$AppDatabase db) =>
      db.tricks.createAlias('run_order_items__trick_id__tricks__id');

  $$TricksTableProcessedTableManager? get trickId {
    final $_column = $_itemColumn<int>('trick_id');
    if ($_column == null) return null;
    final manager = $$TricksTableTableManager(
      $_db,
      $_db.tricks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trickIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RunOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RunOrderItemsTable> {
  $$RunOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cueNote => $composableBuilder(
    column: $table.cueNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seconds => $composableBuilder(
    column: $table.seconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  $$ActBlocksTableFilterComposer get blockId {
    final $$ActBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.actBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActBlocksTableFilterComposer(
            $db: $db,
            $table: $db.actBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TricksTableFilterComposer get trickId {
    final $$TricksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trickId,
      referencedTable: $db.tricks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TricksTableFilterComposer(
            $db: $db,
            $table: $db.tricks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RunOrderItemsTable> {
  $$RunOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueNote => $composableBuilder(
    column: $table.cueNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seconds => $composableBuilder(
    column: $table.seconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActBlocksTableOrderingComposer get blockId {
    final $$ActBlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.actBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActBlocksTableOrderingComposer(
            $db: $db,
            $table: $db.actBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TricksTableOrderingComposer get trickId {
    final $$TricksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trickId,
      referencedTable: $db.tricks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TricksTableOrderingComposer(
            $db: $db,
            $table: $db.tricks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RunOrderItemsTable> {
  $$RunOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get cueNote =>
      $composableBuilder(column: $table.cueNote, builder: (column) => column);

  GeneratedColumn<int> get seconds =>
      $composableBuilder(column: $table.seconds, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => column,
  );

  $$ActBlocksTableAnnotationComposer get blockId {
    final $$ActBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.actBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.actBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TricksTableAnnotationComposer get trickId {
    final $$TricksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trickId,
      referencedTable: $db.tricks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TricksTableAnnotationComposer(
            $db: $db,
            $table: $db.tricks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunOrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RunOrderItemsTable,
          RunOrderItemRow,
          $$RunOrderItemsTableFilterComposer,
          $$RunOrderItemsTableOrderingComposer,
          $$RunOrderItemsTableAnnotationComposer,
          $$RunOrderItemsTableCreateCompanionBuilder,
          $$RunOrderItemsTableUpdateCompanionBuilder,
          (RunOrderItemRow, $$RunOrderItemsTableReferences),
          RunOrderItemRow,
          PrefetchHooks Function({bool blockId, bool trickId})
        > {
  $$RunOrderItemsTableTableManager(_$AppDatabase db, $RunOrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RunOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RunOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RunOrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> blockId = const Value.absent(),
                Value<int?> trickId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> cueNote = const Value.absent(),
                Value<int> seconds = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
              }) => RunOrderItemsCompanion(
                id: id,
                blockId: blockId,
                trickId: trickId,
                label: label,
                cueNote: cueNote,
                seconds: seconds,
                position: position,
                isConfirmed: isConfirmed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int blockId,
                Value<int?> trickId = const Value.absent(),
                required String label,
                Value<String?> cueNote = const Value.absent(),
                Value<int> seconds = const Value.absent(),
                required int position,
                Value<bool> isConfirmed = const Value.absent(),
              }) => RunOrderItemsCompanion.insert(
                id: id,
                blockId: blockId,
                trickId: trickId,
                label: label,
                cueNote: cueNote,
                seconds: seconds,
                position: position,
                isConfirmed: isConfirmed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RunOrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({blockId = false, trickId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (blockId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.blockId,
                                referencedTable: $$RunOrderItemsTableReferences
                                    ._blockIdTable(db),
                                referencedColumn: $$RunOrderItemsTableReferences
                                    ._blockIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (trickId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trickId,
                                referencedTable: $$RunOrderItemsTableReferences
                                    ._trickIdTable(db),
                                referencedColumn: $$RunOrderItemsTableReferences
                                    ._trickIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RunOrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RunOrderItemsTable,
      RunOrderItemRow,
      $$RunOrderItemsTableFilterComposer,
      $$RunOrderItemsTableOrderingComposer,
      $$RunOrderItemsTableAnnotationComposer,
      $$RunOrderItemsTableCreateCompanionBuilder,
      $$RunOrderItemsTableUpdateCompanionBuilder,
      (RunOrderItemRow, $$RunOrderItemsTableReferences),
      RunOrderItemRow,
      PrefetchHooks Function({bool blockId, bool trickId})
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<int> id,
      required int actId,
      required ChecklistCategory category,
      required String label,
      Value<String?> detail,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
      required int position,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<int> id,
      Value<int> actId,
      Value<ChecklistCategory> category,
      Value<String> label,
      Value<String?> detail,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
      Value<int> position,
    });

final class $$ChecklistItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItemRow> {
  $$ChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActsTable _actIdTable(_$AppDatabase db) =>
      db.acts.createAlias('checklist_items__act_id__acts__id');

  $$ActsTableProcessedTableManager get actId {
    final $_column = $_itemColumn<int>('act_id')!;

    final manager = $$ActsTableTableManager(
      $_db,
      $_db.acts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ChecklistCategory, ChecklistCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ActsTableFilterComposer get actId {
    final $$ActsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableFilterComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActsTableOrderingComposer get actId {
    final $$ActsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableOrderingComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ChecklistCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ActsTableAnnotationComposer get actId {
    final $$ActsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableAnnotationComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItemRow,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (ChecklistItemRow, $$ChecklistItemsTableReferences),
          ChecklistItemRow,
          PrefetchHooks Function({bool actId})
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> actId = const Value.absent(),
                Value<ChecklistCategory> category = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                actId: actId,
                category: category,
                label: label,
                detail: detail,
                isDone: isDone,
                doneAt: doneAt,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int actId,
                required ChecklistCategory category,
                required String label,
                Value<String?> detail = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                required int position,
              }) => ChecklistItemsCompanion.insert(
                id: id,
                actId: actId,
                category: category,
                label: label,
                detail: detail,
                isDone: isDone,
                doneAt: doneAt,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actId,
                                referencedTable: $$ChecklistItemsTableReferences
                                    ._actIdTable(db),
                                referencedColumn:
                                    $$ChecklistItemsTableReferences
                                        ._actIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItemRow,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (ChecklistItemRow, $$ChecklistItemsTableReferences),
      ChecklistItemRow,
      PrefetchHooks Function({bool actId})
    >;
typedef $$StagePlotItemsTableCreateCompanionBuilder =
    StagePlotItemsCompanion Function({
      Value<int> id,
      required int actId,
      required StageEquipment equipment,
      required String label,
      Value<String?> spec,
      Value<bool> isConfirmed,
      required int position,
    });
typedef $$StagePlotItemsTableUpdateCompanionBuilder =
    StagePlotItemsCompanion Function({
      Value<int> id,
      Value<int> actId,
      Value<StageEquipment> equipment,
      Value<String> label,
      Value<String?> spec,
      Value<bool> isConfirmed,
      Value<int> position,
    });

final class $$StagePlotItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StagePlotItemsTable, StagePlotItemRow> {
  $$StagePlotItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActsTable _actIdTable(_$AppDatabase db) =>
      db.acts.createAlias('stage_plot_items__act_id__acts__id');

  $$ActsTableProcessedTableManager get actId {
    final $_column = $_itemColumn<int>('act_id')!;

    final manager = $$ActsTableTableManager(
      $_db,
      $_db.acts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StagePlotItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StagePlotItemsTable> {
  $$StagePlotItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StageEquipment, StageEquipment, String>
  get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spec => $composableBuilder(
    column: $table.spec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ActsTableFilterComposer get actId {
    final $$ActsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableFilterComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StagePlotItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StagePlotItemsTable> {
  $$StagePlotItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spec => $composableBuilder(
    column: $table.spec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActsTableOrderingComposer get actId {
    final $$ActsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableOrderingComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StagePlotItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StagePlotItemsTable> {
  $$StagePlotItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StageEquipment, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get spec =>
      $composableBuilder(column: $table.spec, builder: (column) => column);

  GeneratedColumn<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ActsTableAnnotationComposer get actId {
    final $$ActsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableAnnotationComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StagePlotItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StagePlotItemsTable,
          StagePlotItemRow,
          $$StagePlotItemsTableFilterComposer,
          $$StagePlotItemsTableOrderingComposer,
          $$StagePlotItemsTableAnnotationComposer,
          $$StagePlotItemsTableCreateCompanionBuilder,
          $$StagePlotItemsTableUpdateCompanionBuilder,
          (StagePlotItemRow, $$StagePlotItemsTableReferences),
          StagePlotItemRow,
          PrefetchHooks Function({bool actId})
        > {
  $$StagePlotItemsTableTableManager(
    _$AppDatabase db,
    $StagePlotItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StagePlotItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StagePlotItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StagePlotItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> actId = const Value.absent(),
                Value<StageEquipment> equipment = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> spec = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => StagePlotItemsCompanion(
                id: id,
                actId: actId,
                equipment: equipment,
                label: label,
                spec: spec,
                isConfirmed: isConfirmed,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int actId,
                required StageEquipment equipment,
                required String label,
                Value<String?> spec = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
                required int position,
              }) => StagePlotItemsCompanion.insert(
                id: id,
                actId: actId,
                equipment: equipment,
                label: label,
                spec: spec,
                isConfirmed: isConfirmed,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StagePlotItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actId,
                                referencedTable: $$StagePlotItemsTableReferences
                                    ._actIdTable(db),
                                referencedColumn:
                                    $$StagePlotItemsTableReferences
                                        ._actIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StagePlotItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StagePlotItemsTable,
      StagePlotItemRow,
      $$StagePlotItemsTableFilterComposer,
      $$StagePlotItemsTableOrderingComposer,
      $$StagePlotItemsTableAnnotationComposer,
      $$StagePlotItemsTableCreateCompanionBuilder,
      $$StagePlotItemsTableUpdateCompanionBuilder,
      (StagePlotItemRow, $$StagePlotItemsTableReferences),
      StagePlotItemRow,
      PrefetchHooks Function({bool actId})
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<int?> actId,
      required String title,
      Value<String> body,
      Value<PageRuling> ruling,
      Value<PaperStock> stock,
      Value<bool> isPinned,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<int?> actId,
      Value<String> title,
      Value<String> body,
      Value<PageRuling> ruling,
      Value<PaperStock> stock,
      Value<bool> isPinned,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, NoteRow> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActsTable _actIdTable(_$AppDatabase db) =>
      db.acts.createAlias('notes__act_id__acts__id');

  $$ActsTableProcessedTableManager? get actId {
    final $_column = $_itemColumn<int>('act_id');
    if ($_column == null) return null;
    final manager = $$ActsTableTableManager(
      $_db,
      $_db.acts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PageRuling, PageRuling, String> get ruling =>
      $composableBuilder(
        column: $table.ruling,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<PaperStock, PaperStock, String> get stock =>
      $composableBuilder(
        column: $table.stock,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActsTableFilterComposer get actId {
    final $$ActsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableFilterComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruling => $composableBuilder(
    column: $table.ruling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActsTableOrderingComposer get actId {
    final $$ActsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableOrderingComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PageRuling, String> get ruling =>
      $composableBuilder(column: $table.ruling, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaperStock, String> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ActsTableAnnotationComposer get actId {
    final $$ActsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableAnnotationComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          NoteRow,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (NoteRow, $$NotesTableReferences),
          NoteRow,
          PrefetchHooks Function({bool actId})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> actId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<PageRuling> ruling = const Value.absent(),
                Value<PaperStock> stock = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                actId: actId,
                title: title,
                body: body,
                ruling: ruling,
                stock: stock,
                isPinned: isPinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> actId = const Value.absent(),
                required String title,
                Value<String> body = const Value.absent(),
                Value<PageRuling> ruling = const Value.absent(),
                Value<PaperStock> stock = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => NotesCompanion.insert(
                id: id,
                actId: actId,
                title: title,
                body: body,
                ruling: ruling,
                stock: stock,
                isPinned: isPinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({actId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actId,
                                referencedTable: $$NotesTableReferences
                                    ._actIdTable(db),
                                referencedColumn: $$NotesTableReferences
                                    ._actIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      NoteRow,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (NoteRow, $$NotesTableReferences),
      NoteRow,
      PrefetchHooks Function({bool actId})
    >;
typedef $$RehearsalsTableCreateCompanionBuilder =
    RehearsalsCompanion Function({
      Value<int> id,
      required int actId,
      required DateTime happenedAt,
      Value<int> minutes,
      Value<String> focus,
      Value<int> confidence,
      Value<String?> notes,
      required DateTime createdAt,
    });
typedef $$RehearsalsTableUpdateCompanionBuilder =
    RehearsalsCompanion Function({
      Value<int> id,
      Value<int> actId,
      Value<DateTime> happenedAt,
      Value<int> minutes,
      Value<String> focus,
      Value<int> confidence,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$RehearsalsTableReferences
    extends BaseReferences<_$AppDatabase, $RehearsalsTable, RehearsalRow> {
  $$RehearsalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActsTable _actIdTable(_$AppDatabase db) =>
      db.acts.createAlias('rehearsals__act_id__acts__id');

  $$ActsTableProcessedTableManager get actId {
    final $_column = $_itemColumn<int>('act_id')!;

    final manager = $$ActsTableTableManager(
      $_db,
      $_db.acts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RehearsalsTableFilterComposer
    extends Composer<_$AppDatabase, $RehearsalsTable> {
  $$RehearsalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActsTableFilterComposer get actId {
    final $$ActsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableFilterComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RehearsalsTableOrderingComposer
    extends Composer<_$AppDatabase, $RehearsalsTable> {
  $$RehearsalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActsTableOrderingComposer get actId {
    final $$ActsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableOrderingComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RehearsalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RehearsalsTable> {
  $$RehearsalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get happenedAt => $composableBuilder(
    column: $table.happenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ActsTableAnnotationComposer get actId {
    final $$ActsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actId,
      referencedTable: $db.acts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActsTableAnnotationComposer(
            $db: $db,
            $table: $db.acts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RehearsalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RehearsalsTable,
          RehearsalRow,
          $$RehearsalsTableFilterComposer,
          $$RehearsalsTableOrderingComposer,
          $$RehearsalsTableAnnotationComposer,
          $$RehearsalsTableCreateCompanionBuilder,
          $$RehearsalsTableUpdateCompanionBuilder,
          (RehearsalRow, $$RehearsalsTableReferences),
          RehearsalRow,
          PrefetchHooks Function({bool actId})
        > {
  $$RehearsalsTableTableManager(_$AppDatabase db, $RehearsalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RehearsalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RehearsalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RehearsalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> actId = const Value.absent(),
                Value<DateTime> happenedAt = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<int> confidence = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RehearsalsCompanion(
                id: id,
                actId: actId,
                happenedAt: happenedAt,
                minutes: minutes,
                focus: focus,
                confidence: confidence,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int actId,
                required DateTime happenedAt,
                Value<int> minutes = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<int> confidence = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
              }) => RehearsalsCompanion.insert(
                id: id,
                actId: actId,
                happenedAt: happenedAt,
                minutes: minutes,
                focus: focus,
                confidence: confidence,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RehearsalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actId,
                                referencedTable: $$RehearsalsTableReferences
                                    ._actIdTable(db),
                                referencedColumn: $$RehearsalsTableReferences
                                    ._actIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RehearsalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RehearsalsTable,
      RehearsalRow,
      $$RehearsalsTableFilterComposer,
      $$RehearsalsTableOrderingComposer,
      $$RehearsalsTableAnnotationComposer,
      $$RehearsalsTableCreateCompanionBuilder,
      $$RehearsalsTableUpdateCompanionBuilder,
      (RehearsalRow, $$RehearsalsTableReferences),
      RehearsalRow,
      PrefetchHooks Function({bool actId})
    >;
typedef $$PerformerProfilesTableCreateCompanionBuilder =
    PerformerProfilesCompanion Function({
      Value<int> id,
      Value<String> stageName,
      Value<Discipline?> discipline,
      Value<String?> homeVenue,
      Value<String?> photoFileName,
      Value<String?> bio,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$PerformerProfilesTableUpdateCompanionBuilder =
    PerformerProfilesCompanion Function({
      Value<int> id,
      Value<String> stageName,
      Value<Discipline?> discipline,
      Value<String?> homeVenue,
      Value<String?> photoFileName,
      Value<String?> bio,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PerformerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PerformerProfilesTable> {
  $$PerformerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stageName => $composableBuilder(
    column: $table.stageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Discipline?, Discipline, String>
  get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get homeVenue => $composableBuilder(
    column: $table.homeVenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoFileName => $composableBuilder(
    column: $table.photoFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PerformerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformerProfilesTable> {
  $$PerformerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stageName => $composableBuilder(
    column: $table.stageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeVenue => $composableBuilder(
    column: $table.homeVenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoFileName => $composableBuilder(
    column: $table.photoFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PerformerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformerProfilesTable> {
  $$PerformerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stageName =>
      $composableBuilder(column: $table.stageName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Discipline?, String> get discipline =>
      $composableBuilder(
        column: $table.discipline,
        builder: (column) => column,
      );

  GeneratedColumn<String> get homeVenue =>
      $composableBuilder(column: $table.homeVenue, builder: (column) => column);

  GeneratedColumn<String> get photoFileName => $composableBuilder(
    column: $table.photoFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PerformerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformerProfilesTable,
          PerformerProfileRow,
          $$PerformerProfilesTableFilterComposer,
          $$PerformerProfilesTableOrderingComposer,
          $$PerformerProfilesTableAnnotationComposer,
          $$PerformerProfilesTableCreateCompanionBuilder,
          $$PerformerProfilesTableUpdateCompanionBuilder,
          (
            PerformerProfileRow,
            BaseReferences<
              _$AppDatabase,
              $PerformerProfilesTable,
              PerformerProfileRow
            >,
          ),
          PerformerProfileRow,
          PrefetchHooks Function()
        > {
  $$PerformerProfilesTableTableManager(
    _$AppDatabase db,
    $PerformerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerformerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerformerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerformerProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> stageName = const Value.absent(),
                Value<Discipline?> discipline = const Value.absent(),
                Value<String?> homeVenue = const Value.absent(),
                Value<String?> photoFileName = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PerformerProfilesCompanion(
                id: id,
                stageName: stageName,
                discipline: discipline,
                homeVenue: homeVenue,
                photoFileName: photoFileName,
                bio: bio,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> stageName = const Value.absent(),
                Value<Discipline?> discipline = const Value.absent(),
                Value<String?> homeVenue = const Value.absent(),
                Value<String?> photoFileName = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PerformerProfilesCompanion.insert(
                id: id,
                stageName: stageName,
                discipline: discipline,
                homeVenue: homeVenue,
                photoFileName: photoFileName,
                bio: bio,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PerformerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformerProfilesTable,
      PerformerProfileRow,
      $$PerformerProfilesTableFilterComposer,
      $$PerformerProfilesTableOrderingComposer,
      $$PerformerProfilesTableAnnotationComposer,
      $$PerformerProfilesTableCreateCompanionBuilder,
      $$PerformerProfilesTableUpdateCompanionBuilder,
      (
        PerformerProfileRow,
        BaseReferences<
          _$AppDatabase,
          $PerformerProfilesTable,
          PerformerProfileRow
        >,
      ),
      PerformerProfileRow,
      PrefetchHooks Function()
    >;
typedef $$AppPreferencesTableCreateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<int> id,
      Value<bool> soundEnabled,
      Value<bool> hapticsEnabled,
      Value<bool> reminderEnabled,
      Value<int> reminderHour,
      Value<int> reminderMinute,
      Value<int> reminderWeekdayMask,
      Value<bool> dailyReminderEnabled,
      Value<int> dailyReminderHour,
      Value<int> dailyReminderMinute,
      Value<bool> onboardingCompleted,
      Value<int> catalogRevision,
      Value<int> defaultTargetSeconds,
      Value<bool> decayEnabled,
    });
typedef $$AppPreferencesTableUpdateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<int> id,
      Value<bool> soundEnabled,
      Value<bool> hapticsEnabled,
      Value<bool> reminderEnabled,
      Value<int> reminderHour,
      Value<int> reminderMinute,
      Value<int> reminderWeekdayMask,
      Value<bool> dailyReminderEnabled,
      Value<int> dailyReminderHour,
      Value<int> dailyReminderMinute,
      Value<bool> onboardingCompleted,
      Value<int> catalogRevision,
      Value<int> defaultTargetSeconds,
      Value<bool> decayEnabled,
    });

class $$AppPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderWeekdayMask => $composableBuilder(
    column: $table.reminderWeekdayMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dailyReminderEnabled => $composableBuilder(
    column: $table.dailyReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyReminderHour => $composableBuilder(
    column: $table.dailyReminderHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyReminderMinute => $composableBuilder(
    column: $table.dailyReminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get catalogRevision => $composableBuilder(
    column: $table.catalogRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultTargetSeconds => $composableBuilder(
    column: $table.defaultTargetSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get decayEnabled => $composableBuilder(
    column: $table.decayEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderWeekdayMask => $composableBuilder(
    column: $table.reminderWeekdayMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dailyReminderEnabled => $composableBuilder(
    column: $table.dailyReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyReminderHour => $composableBuilder(
    column: $table.dailyReminderHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyReminderMinute => $composableBuilder(
    column: $table.dailyReminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get catalogRevision => $composableBuilder(
    column: $table.catalogRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultTargetSeconds => $composableBuilder(
    column: $table.defaultTargetSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get decayEnabled => $composableBuilder(
    column: $table.decayEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderWeekdayMask => $composableBuilder(
    column: $table.reminderWeekdayMask,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dailyReminderEnabled => $composableBuilder(
    column: $table.dailyReminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyReminderHour => $composableBuilder(
    column: $table.dailyReminderHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyReminderMinute => $composableBuilder(
    column: $table.dailyReminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get catalogRevision => $composableBuilder(
    column: $table.catalogRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultTargetSeconds => $composableBuilder(
    column: $table.defaultTargetSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get decayEnabled => $composableBuilder(
    column: $table.decayEnabled,
    builder: (column) => column,
  );
}

class $$AppPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPreferencesTable,
          AppPreferenceRow,
          $$AppPreferencesTableFilterComposer,
          $$AppPreferencesTableOrderingComposer,
          $$AppPreferencesTableAnnotationComposer,
          $$AppPreferencesTableCreateCompanionBuilder,
          $$AppPreferencesTableUpdateCompanionBuilder,
          (
            AppPreferenceRow,
            BaseReferences<
              _$AppDatabase,
              $AppPreferencesTable,
              AppPreferenceRow
            >,
          ),
          AppPreferenceRow,
          PrefetchHooks Function()
        > {
  $$AppPreferencesTableTableManager(
    _$AppDatabase db,
    $AppPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
                Value<int> reminderWeekdayMask = const Value.absent(),
                Value<bool> dailyReminderEnabled = const Value.absent(),
                Value<int> dailyReminderHour = const Value.absent(),
                Value<int> dailyReminderMinute = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> catalogRevision = const Value.absent(),
                Value<int> defaultTargetSeconds = const Value.absent(),
                Value<bool> decayEnabled = const Value.absent(),
              }) => AppPreferencesCompanion(
                id: id,
                soundEnabled: soundEnabled,
                hapticsEnabled: hapticsEnabled,
                reminderEnabled: reminderEnabled,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
                reminderWeekdayMask: reminderWeekdayMask,
                dailyReminderEnabled: dailyReminderEnabled,
                dailyReminderHour: dailyReminderHour,
                dailyReminderMinute: dailyReminderMinute,
                onboardingCompleted: onboardingCompleted,
                catalogRevision: catalogRevision,
                defaultTargetSeconds: defaultTargetSeconds,
                decayEnabled: decayEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
                Value<int> reminderWeekdayMask = const Value.absent(),
                Value<bool> dailyReminderEnabled = const Value.absent(),
                Value<int> dailyReminderHour = const Value.absent(),
                Value<int> dailyReminderMinute = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> catalogRevision = const Value.absent(),
                Value<int> defaultTargetSeconds = const Value.absent(),
                Value<bool> decayEnabled = const Value.absent(),
              }) => AppPreferencesCompanion.insert(
                id: id,
                soundEnabled: soundEnabled,
                hapticsEnabled: hapticsEnabled,
                reminderEnabled: reminderEnabled,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
                reminderWeekdayMask: reminderWeekdayMask,
                dailyReminderEnabled: dailyReminderEnabled,
                dailyReminderHour: dailyReminderHour,
                dailyReminderMinute: dailyReminderMinute,
                onboardingCompleted: onboardingCompleted,
                catalogRevision: catalogRevision,
                defaultTargetSeconds: defaultTargetSeconds,
                decayEnabled: decayEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPreferencesTable,
      AppPreferenceRow,
      $$AppPreferencesTableFilterComposer,
      $$AppPreferencesTableOrderingComposer,
      $$AppPreferencesTableAnnotationComposer,
      $$AppPreferencesTableCreateCompanionBuilder,
      $$AppPreferencesTableUpdateCompanionBuilder,
      (
        AppPreferenceRow,
        BaseReferences<_$AppDatabase, $AppPreferencesTable, AppPreferenceRow>,
      ),
      AppPreferenceRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TricksTableTableManager get tricks =>
      $$TricksTableTableManager(_db, _db.tricks);
  $$ActsTableTableManager get acts => $$ActsTableTableManager(_db, _db.acts);
  $$ActBlocksTableTableManager get actBlocks =>
      $$ActBlocksTableTableManager(_db, _db.actBlocks);
  $$RunOrderItemsTableTableManager get runOrderItems =>
      $$RunOrderItemsTableTableManager(_db, _db.runOrderItems);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$StagePlotItemsTableTableManager get stagePlotItems =>
      $$StagePlotItemsTableTableManager(_db, _db.stagePlotItems);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$RehearsalsTableTableManager get rehearsals =>
      $$RehearsalsTableTableManager(_db, _db.rehearsals);
  $$PerformerProfilesTableTableManager get performerProfiles =>
      $$PerformerProfilesTableTableManager(_db, _db.performerProfiles);
  $$AppPreferencesTableTableManager get appPreferences =>
      $$AppPreferencesTableTableManager(_db, _db.appPreferences);
}
