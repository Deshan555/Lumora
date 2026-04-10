// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CorrectionHistoryTable extends CorrectionHistory
    with TableInfo<$CorrectionHistoryTable, CorrectionHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorrectionHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalTextMeta =
      const VerificationMeta('originalText');
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
      'original_text', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _correctedTextMeta =
      const VerificationMeta('correctedText');
  @override
  late final GeneratedColumn<String> correctedText = GeneratedColumn<String>(
      'corrected_text', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _styleMeta = const VerificationMeta('style');
  @override
  late final GeneratedColumn<String> style = GeneratedColumn<String>(
      'style', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Formal'));
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isImageMeta =
      const VerificationMeta('isImage');
  @override
  late final GeneratedColumn<bool> isImage = GeneratedColumn<bool>(
      'is_image', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_image" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalText,
        correctedText,
        explanation,
        style,
        modelName,
        isImage,
        imageUrl,
        timestamp
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'correction_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<CorrectionHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_text')) {
      context.handle(
          _originalTextMeta,
          originalText.isAcceptableOrUnknown(
              data['original_text']!, _originalTextMeta));
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('corrected_text')) {
      context.handle(
          _correctedTextMeta,
          correctedText.isAcceptableOrUnknown(
              data['corrected_text']!, _correctedTextMeta));
    } else if (isInserting) {
      context.missing(_correctedTextMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('style')) {
      context.handle(
          _styleMeta, style.isAcceptableOrUnknown(data['style']!, _styleMeta));
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    }
    if (data.containsKey('is_image')) {
      context.handle(_isImageMeta,
          isImage.isAcceptableOrUnknown(data['is_image']!, _isImageMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CorrectionHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorrectionHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_text'])!,
      correctedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}corrected_text'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      style: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}style'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name']),
      isImage: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_image'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $CorrectionHistoryTable createAlias(String alias) {
    return $CorrectionHistoryTable(attachedDatabase, alias);
  }
}

class CorrectionHistoryData extends DataClass
    implements Insertable<CorrectionHistoryData> {
  final int id;
  final String originalText;
  final String correctedText;
  final String explanation;
  final String style;
  final String? modelName;
  final bool isImage;
  final String? imageUrl;
  final DateTime timestamp;
  const CorrectionHistoryData(
      {required this.id,
      required this.originalText,
      required this.correctedText,
      required this.explanation,
      required this.style,
      this.modelName,
      required this.isImage,
      this.imageUrl,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_text'] = Variable<String>(originalText);
    map['corrected_text'] = Variable<String>(correctedText);
    map['explanation'] = Variable<String>(explanation);
    map['style'] = Variable<String>(style);
    if (!nullToAbsent || modelName != null) {
      map['model_name'] = Variable<String>(modelName);
    }
    map['is_image'] = Variable<bool>(isImage);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  CorrectionHistoryCompanion toCompanion(bool nullToAbsent) {
    return CorrectionHistoryCompanion(
      id: Value(id),
      originalText: Value(originalText),
      correctedText: Value(correctedText),
      explanation: Value(explanation),
      style: Value(style),
      modelName: modelName == null && nullToAbsent
          ? const Value.absent()
          : Value(modelName),
      isImage: Value(isImage),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      timestamp: Value(timestamp),
    );
  }

  factory CorrectionHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorrectionHistoryData(
      id: serializer.fromJson<int>(json['id']),
      originalText: serializer.fromJson<String>(json['originalText']),
      correctedText: serializer.fromJson<String>(json['correctedText']),
      explanation: serializer.fromJson<String>(json['explanation']),
      style: serializer.fromJson<String>(json['style']),
      modelName: serializer.fromJson<String?>(json['modelName']),
      isImage: serializer.fromJson<bool>(json['isImage']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalText': serializer.toJson<String>(originalText),
      'correctedText': serializer.toJson<String>(correctedText),
      'explanation': serializer.toJson<String>(explanation),
      'style': serializer.toJson<String>(style),
      'modelName': serializer.toJson<String?>(modelName),
      'isImage': serializer.toJson<bool>(isImage),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  CorrectionHistoryData copyWith(
          {int? id,
          String? originalText,
          String? correctedText,
          String? explanation,
          String? style,
          Value<String?> modelName = const Value.absent(),
          bool? isImage,
          Value<String?> imageUrl = const Value.absent(),
          DateTime? timestamp}) =>
      CorrectionHistoryData(
        id: id ?? this.id,
        originalText: originalText ?? this.originalText,
        correctedText: correctedText ?? this.correctedText,
        explanation: explanation ?? this.explanation,
        style: style ?? this.style,
        modelName: modelName.present ? modelName.value : this.modelName,
        isImage: isImage ?? this.isImage,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        timestamp: timestamp ?? this.timestamp,
      );
  CorrectionHistoryData copyWithCompanion(CorrectionHistoryCompanion data) {
    return CorrectionHistoryData(
      id: data.id.present ? data.id.value : this.id,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      correctedText: data.correctedText.present
          ? data.correctedText.value
          : this.correctedText,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      style: data.style.present ? data.style.value : this.style,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      isImage: data.isImage.present ? data.isImage.value : this.isImage,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorrectionHistoryData(')
          ..write('id: $id, ')
          ..write('originalText: $originalText, ')
          ..write('correctedText: $correctedText, ')
          ..write('explanation: $explanation, ')
          ..write('style: $style, ')
          ..write('modelName: $modelName, ')
          ..write('isImage: $isImage, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, originalText, correctedText, explanation,
      style, modelName, isImage, imageUrl, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorrectionHistoryData &&
          other.id == this.id &&
          other.originalText == this.originalText &&
          other.correctedText == this.correctedText &&
          other.explanation == this.explanation &&
          other.style == this.style &&
          other.modelName == this.modelName &&
          other.isImage == this.isImage &&
          other.imageUrl == this.imageUrl &&
          other.timestamp == this.timestamp);
}

class CorrectionHistoryCompanion
    extends UpdateCompanion<CorrectionHistoryData> {
  final Value<int> id;
  final Value<String> originalText;
  final Value<String> correctedText;
  final Value<String> explanation;
  final Value<String> style;
  final Value<String?> modelName;
  final Value<bool> isImage;
  final Value<String?> imageUrl;
  final Value<DateTime> timestamp;
  const CorrectionHistoryCompanion({
    this.id = const Value.absent(),
    this.originalText = const Value.absent(),
    this.correctedText = const Value.absent(),
    this.explanation = const Value.absent(),
    this.style = const Value.absent(),
    this.modelName = const Value.absent(),
    this.isImage = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  CorrectionHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String originalText,
    required String correctedText,
    required String explanation,
    this.style = const Value.absent(),
    this.modelName = const Value.absent(),
    this.isImage = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.timestamp = const Value.absent(),
  })  : originalText = Value(originalText),
        correctedText = Value(correctedText),
        explanation = Value(explanation);
  static Insertable<CorrectionHistoryData> custom({
    Expression<int>? id,
    Expression<String>? originalText,
    Expression<String>? correctedText,
    Expression<String>? explanation,
    Expression<String>? style,
    Expression<String>? modelName,
    Expression<bool>? isImage,
    Expression<String>? imageUrl,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalText != null) 'original_text': originalText,
      if (correctedText != null) 'corrected_text': correctedText,
      if (explanation != null) 'explanation': explanation,
      if (style != null) 'style': style,
      if (modelName != null) 'model_name': modelName,
      if (isImage != null) 'is_image': isImage,
      if (imageUrl != null) 'image_url': imageUrl,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  CorrectionHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalText,
      Value<String>? correctedText,
      Value<String>? explanation,
      Value<String>? style,
      Value<String?>? modelName,
      Value<bool>? isImage,
      Value<String?>? imageUrl,
      Value<DateTime>? timestamp}) {
    return CorrectionHistoryCompanion(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      correctedText: correctedText ?? this.correctedText,
      explanation: explanation ?? this.explanation,
      style: style ?? this.style,
      modelName: modelName ?? this.modelName,
      isImage: isImage ?? this.isImage,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (correctedText.present) {
      map['corrected_text'] = Variable<String>(correctedText.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (style.present) {
      map['style'] = Variable<String>(style.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (isImage.present) {
      map['is_image'] = Variable<bool>(isImage.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorrectionHistoryCompanion(')
          ..write('id: $id, ')
          ..write('originalText: $originalText, ')
          ..write('correctedText: $correctedText, ')
          ..write('explanation: $explanation, ')
          ..write('style: $style, ')
          ..write('modelName: $modelName, ')
          ..write('isImage: $isImage, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _selectedStyleMeta =
      const VerificationMeta('selectedStyle');
  @override
  late final GeneratedColumn<String> selectedStyle = GeneratedColumn<String>(
      'selected_style', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Formal'));
  static const VerificationMeta _activeModelIdMeta =
      const VerificationMeta('activeModelId');
  @override
  late final GeneratedColumn<String> activeModelId = GeneratedColumn<String>(
      'active_model_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _autoDownloadRecommendedMeta =
      const VerificationMeta('autoDownloadRecommended');
  @override
  late final GeneratedColumn<bool> autoDownloadRecommended =
      GeneratedColumn<bool>('auto_download_recommended', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("auto_download_recommended" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        selectedStyle,
        activeModelId,
        themeMode,
        autoDownloadRecommended,
        lastUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(Insertable<UserSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('selected_style')) {
      context.handle(
          _selectedStyleMeta,
          selectedStyle.isAcceptableOrUnknown(
              data['selected_style']!, _selectedStyleMeta));
    }
    if (data.containsKey('active_model_id')) {
      context.handle(
          _activeModelIdMeta,
          activeModelId.isAcceptableOrUnknown(
              data['active_model_id']!, _activeModelIdMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('auto_download_recommended')) {
      context.handle(
          _autoDownloadRecommendedMeta,
          autoDownloadRecommended.isAcceptableOrUnknown(
              data['auto_download_recommended']!,
              _autoDownloadRecommendedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      selectedStyle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selected_style'])!,
      activeModelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_model_id']),
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      autoDownloadRecommended: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}auto_download_recommended'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final String selectedStyle;
  final String? activeModelId;
  final String themeMode;
  final bool autoDownloadRecommended;
  final DateTime lastUpdated;
  const UserSetting(
      {required this.id,
      required this.selectedStyle,
      this.activeModelId,
      required this.themeMode,
      required this.autoDownloadRecommended,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['selected_style'] = Variable<String>(selectedStyle);
    if (!nullToAbsent || activeModelId != null) {
      map['active_model_id'] = Variable<String>(activeModelId);
    }
    map['theme_mode'] = Variable<String>(themeMode);
    map['auto_download_recommended'] = Variable<bool>(autoDownloadRecommended);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      selectedStyle: Value(selectedStyle),
      activeModelId: activeModelId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeModelId),
      themeMode: Value(themeMode),
      autoDownloadRecommended: Value(autoDownloadRecommended),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory UserSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      selectedStyle: serializer.fromJson<String>(json['selectedStyle']),
      activeModelId: serializer.fromJson<String?>(json['activeModelId']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      autoDownloadRecommended:
          serializer.fromJson<bool>(json['autoDownloadRecommended']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'selectedStyle': serializer.toJson<String>(selectedStyle),
      'activeModelId': serializer.toJson<String?>(activeModelId),
      'themeMode': serializer.toJson<String>(themeMode),
      'autoDownloadRecommended':
          serializer.toJson<bool>(autoDownloadRecommended),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  UserSetting copyWith(
          {int? id,
          String? selectedStyle,
          Value<String?> activeModelId = const Value.absent(),
          String? themeMode,
          bool? autoDownloadRecommended,
          DateTime? lastUpdated}) =>
      UserSetting(
        id: id ?? this.id,
        selectedStyle: selectedStyle ?? this.selectedStyle,
        activeModelId:
            activeModelId.present ? activeModelId.value : this.activeModelId,
        themeMode: themeMode ?? this.themeMode,
        autoDownloadRecommended:
            autoDownloadRecommended ?? this.autoDownloadRecommended,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      selectedStyle: data.selectedStyle.present
          ? data.selectedStyle.value
          : this.selectedStyle,
      activeModelId: data.activeModelId.present
          ? data.activeModelId.value
          : this.activeModelId,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      autoDownloadRecommended: data.autoDownloadRecommended.present
          ? data.autoDownloadRecommended.value
          : this.autoDownloadRecommended,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('selectedStyle: $selectedStyle, ')
          ..write('activeModelId: $activeModelId, ')
          ..write('themeMode: $themeMode, ')
          ..write('autoDownloadRecommended: $autoDownloadRecommended, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, selectedStyle, activeModelId, themeMode,
      autoDownloadRecommended, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.selectedStyle == this.selectedStyle &&
          other.activeModelId == this.activeModelId &&
          other.themeMode == this.themeMode &&
          other.autoDownloadRecommended == this.autoDownloadRecommended &&
          other.lastUpdated == this.lastUpdated);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<String> selectedStyle;
  final Value<String?> activeModelId;
  final Value<String> themeMode;
  final Value<bool> autoDownloadRecommended;
  final Value<DateTime> lastUpdated;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.selectedStyle = const Value.absent(),
    this.activeModelId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.autoDownloadRecommended = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.selectedStyle = const Value.absent(),
    this.activeModelId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.autoDownloadRecommended = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<String>? selectedStyle,
    Expression<String>? activeModelId,
    Expression<String>? themeMode,
    Expression<bool>? autoDownloadRecommended,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (selectedStyle != null) 'selected_style': selectedStyle,
      if (activeModelId != null) 'active_model_id': activeModelId,
      if (themeMode != null) 'theme_mode': themeMode,
      if (autoDownloadRecommended != null)
        'auto_download_recommended': autoDownloadRecommended,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  UserSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? selectedStyle,
      Value<String?>? activeModelId,
      Value<String>? themeMode,
      Value<bool>? autoDownloadRecommended,
      Value<DateTime>? lastUpdated}) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      activeModelId: activeModelId ?? this.activeModelId,
      themeMode: themeMode ?? this.themeMode,
      autoDownloadRecommended:
          autoDownloadRecommended ?? this.autoDownloadRecommended,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (selectedStyle.present) {
      map['selected_style'] = Variable<String>(selectedStyle.value);
    }
    if (activeModelId.present) {
      map['active_model_id'] = Variable<String>(activeModelId.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (autoDownloadRecommended.present) {
      map['auto_download_recommended'] =
          Variable<bool>(autoDownloadRecommended.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('selectedStyle: $selectedStyle, ')
          ..write('activeModelId: $activeModelId, ')
          ..write('themeMode: $themeMode, ')
          ..write('autoDownloadRecommended: $autoDownloadRecommended, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $CustomPersonalitiesTable extends CustomPersonalities
    with TableInfo<$CustomPersonalitiesTable, CustomPersonality> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomPersonalitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _occupationMeta =
      const VerificationMeta('occupation');
  @override
  late final GeneratedColumn<int> occupation = GeneratedColumn<int>(
      'occupation', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _customOccupationMeta =
      const VerificationMeta('customOccupation');
  @override
  late final GeneratedColumn<String> customOccupation = GeneratedColumn<String>(
      'custom_occupation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customNameMeta =
      const VerificationMeta('customName');
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
      'custom_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _traitsMeta = const VerificationMeta('traits');
  @override
  late final GeneratedColumn<String> traits = GeneratedColumn<String>(
      'traits', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customPromptAdditionMeta =
      const VerificationMeta('customPromptAddition');
  @override
  late final GeneratedColumn<String> customPromptAddition =
      GeneratedColumn<String>('custom_prompt_addition', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voiceLanguageMeta =
      const VerificationMeta('voiceLanguage');
  @override
  late final GeneratedColumn<String> voiceLanguage = GeneratedColumn<String>(
      'voice_language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voicePitchMeta =
      const VerificationMeta('voicePitch');
  @override
  late final GeneratedColumn<double> voicePitch = GeneratedColumn<double>(
      'voice_pitch', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _voiceSpeedMeta =
      const VerificationMeta('voiceSpeed');
  @override
  late final GeneratedColumn<double> voiceSpeed = GeneratedColumn<double>(
      'voice_speed', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avatarIconCodeMeta =
      const VerificationMeta('avatarIconCode');
  @override
  late final GeneratedColumn<int> avatarIconCode = GeneratedColumn<int>(
      'avatar_icon_code', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avatarIconFontFamilyMeta =
      const VerificationMeta('avatarIconFontFamily');
  @override
  late final GeneratedColumn<String> avatarIconFontFamily =
      GeneratedColumn<String>('avatar_icon_font_family', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarIconFontPackageMeta =
      const VerificationMeta('avatarIconFontPackage');
  @override
  late final GeneratedColumn<String> avatarIconFontPackage =
      GeneratedColumn<String>('avatar_icon_font_package', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        gender,
        occupation,
        customOccupation,
        customName,
        traits,
        customPromptAddition,
        voiceLanguage,
        voicePitch,
        voiceSpeed,
        avatarIconCode,
        avatarIconFontFamily,
        avatarIconFontPackage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_personalities';
  @override
  VerificationContext validateIntegrity(Insertable<CustomPersonality> instance,
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
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('occupation')) {
      context.handle(
          _occupationMeta,
          occupation.isAcceptableOrUnknown(
              data['occupation']!, _occupationMeta));
    } else if (isInserting) {
      context.missing(_occupationMeta);
    }
    if (data.containsKey('custom_occupation')) {
      context.handle(
          _customOccupationMeta,
          customOccupation.isAcceptableOrUnknown(
              data['custom_occupation']!, _customOccupationMeta));
    } else if (isInserting) {
      context.missing(_customOccupationMeta);
    }
    if (data.containsKey('custom_name')) {
      context.handle(
          _customNameMeta,
          customName.isAcceptableOrUnknown(
              data['custom_name']!, _customNameMeta));
    } else if (isInserting) {
      context.missing(_customNameMeta);
    }
    if (data.containsKey('traits')) {
      context.handle(_traitsMeta,
          traits.isAcceptableOrUnknown(data['traits']!, _traitsMeta));
    } else if (isInserting) {
      context.missing(_traitsMeta);
    }
    if (data.containsKey('custom_prompt_addition')) {
      context.handle(
          _customPromptAdditionMeta,
          customPromptAddition.isAcceptableOrUnknown(
              data['custom_prompt_addition']!, _customPromptAdditionMeta));
    } else if (isInserting) {
      context.missing(_customPromptAdditionMeta);
    }
    if (data.containsKey('voice_language')) {
      context.handle(
          _voiceLanguageMeta,
          voiceLanguage.isAcceptableOrUnknown(
              data['voice_language']!, _voiceLanguageMeta));
    }
    if (data.containsKey('voice_pitch')) {
      context.handle(
          _voicePitchMeta,
          voicePitch.isAcceptableOrUnknown(
              data['voice_pitch']!, _voicePitchMeta));
    } else if (isInserting) {
      context.missing(_voicePitchMeta);
    }
    if (data.containsKey('voice_speed')) {
      context.handle(
          _voiceSpeedMeta,
          voiceSpeed.isAcceptableOrUnknown(
              data['voice_speed']!, _voiceSpeedMeta));
    } else if (isInserting) {
      context.missing(_voiceSpeedMeta);
    }
    if (data.containsKey('avatar_icon_code')) {
      context.handle(
          _avatarIconCodeMeta,
          avatarIconCode.isAcceptableOrUnknown(
              data['avatar_icon_code']!, _avatarIconCodeMeta));
    } else if (isInserting) {
      context.missing(_avatarIconCodeMeta);
    }
    if (data.containsKey('avatar_icon_font_family')) {
      context.handle(
          _avatarIconFontFamilyMeta,
          avatarIconFontFamily.isAcceptableOrUnknown(
              data['avatar_icon_font_family']!, _avatarIconFontFamilyMeta));
    }
    if (data.containsKey('avatar_icon_font_package')) {
      context.handle(
          _avatarIconFontPackageMeta,
          avatarIconFontPackage.isAcceptableOrUnknown(
              data['avatar_icon_font_package']!, _avatarIconFontPackageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomPersonality map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomPersonality(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!,
      occupation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}occupation'])!,
      customOccupation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_occupation'])!,
      customName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_name'])!,
      traits: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}traits'])!,
      customPromptAddition: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}custom_prompt_addition'])!,
      voiceLanguage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voice_language']),
      voicePitch: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}voice_pitch'])!,
      voiceSpeed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}voice_speed'])!,
      avatarIconCode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avatar_icon_code'])!,
      avatarIconFontFamily: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}avatar_icon_font_family']),
      avatarIconFontPackage: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}avatar_icon_font_package']),
    );
  }

  @override
  $CustomPersonalitiesTable createAlias(String alias) {
    return $CustomPersonalitiesTable(attachedDatabase, alias);
  }
}

class CustomPersonality extends DataClass
    implements Insertable<CustomPersonality> {
  final String id;
  final String name;
  final int gender;
  final int occupation;
  final String customOccupation;
  final String customName;
  final String traits;
  final String customPromptAddition;
  final String? voiceLanguage;
  final double voicePitch;
  final double voiceSpeed;
  final int avatarIconCode;
  final String? avatarIconFontFamily;
  final String? avatarIconFontPackage;
  const CustomPersonality(
      {required this.id,
      required this.name,
      required this.gender,
      required this.occupation,
      required this.customOccupation,
      required this.customName,
      required this.traits,
      required this.customPromptAddition,
      this.voiceLanguage,
      required this.voicePitch,
      required this.voiceSpeed,
      required this.avatarIconCode,
      this.avatarIconFontFamily,
      this.avatarIconFontPackage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['gender'] = Variable<int>(gender);
    map['occupation'] = Variable<int>(occupation);
    map['custom_occupation'] = Variable<String>(customOccupation);
    map['custom_name'] = Variable<String>(customName);
    map['traits'] = Variable<String>(traits);
    map['custom_prompt_addition'] = Variable<String>(customPromptAddition);
    if (!nullToAbsent || voiceLanguage != null) {
      map['voice_language'] = Variable<String>(voiceLanguage);
    }
    map['voice_pitch'] = Variable<double>(voicePitch);
    map['voice_speed'] = Variable<double>(voiceSpeed);
    map['avatar_icon_code'] = Variable<int>(avatarIconCode);
    if (!nullToAbsent || avatarIconFontFamily != null) {
      map['avatar_icon_font_family'] = Variable<String>(avatarIconFontFamily);
    }
    if (!nullToAbsent || avatarIconFontPackage != null) {
      map['avatar_icon_font_package'] = Variable<String>(avatarIconFontPackage);
    }
    return map;
  }

  CustomPersonalitiesCompanion toCompanion(bool nullToAbsent) {
    return CustomPersonalitiesCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      occupation: Value(occupation),
      customOccupation: Value(customOccupation),
      customName: Value(customName),
      traits: Value(traits),
      customPromptAddition: Value(customPromptAddition),
      voiceLanguage: voiceLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceLanguage),
      voicePitch: Value(voicePitch),
      voiceSpeed: Value(voiceSpeed),
      avatarIconCode: Value(avatarIconCode),
      avatarIconFontFamily: avatarIconFontFamily == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarIconFontFamily),
      avatarIconFontPackage: avatarIconFontPackage == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarIconFontPackage),
    );
  }

  factory CustomPersonality.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomPersonality(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<int>(json['gender']),
      occupation: serializer.fromJson<int>(json['occupation']),
      customOccupation: serializer.fromJson<String>(json['customOccupation']),
      customName: serializer.fromJson<String>(json['customName']),
      traits: serializer.fromJson<String>(json['traits']),
      customPromptAddition:
          serializer.fromJson<String>(json['customPromptAddition']),
      voiceLanguage: serializer.fromJson<String?>(json['voiceLanguage']),
      voicePitch: serializer.fromJson<double>(json['voicePitch']),
      voiceSpeed: serializer.fromJson<double>(json['voiceSpeed']),
      avatarIconCode: serializer.fromJson<int>(json['avatarIconCode']),
      avatarIconFontFamily:
          serializer.fromJson<String?>(json['avatarIconFontFamily']),
      avatarIconFontPackage:
          serializer.fromJson<String?>(json['avatarIconFontPackage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<int>(gender),
      'occupation': serializer.toJson<int>(occupation),
      'customOccupation': serializer.toJson<String>(customOccupation),
      'customName': serializer.toJson<String>(customName),
      'traits': serializer.toJson<String>(traits),
      'customPromptAddition': serializer.toJson<String>(customPromptAddition),
      'voiceLanguage': serializer.toJson<String?>(voiceLanguage),
      'voicePitch': serializer.toJson<double>(voicePitch),
      'voiceSpeed': serializer.toJson<double>(voiceSpeed),
      'avatarIconCode': serializer.toJson<int>(avatarIconCode),
      'avatarIconFontFamily': serializer.toJson<String?>(avatarIconFontFamily),
      'avatarIconFontPackage':
          serializer.toJson<String?>(avatarIconFontPackage),
    };
  }

  CustomPersonality copyWith(
          {String? id,
          String? name,
          int? gender,
          int? occupation,
          String? customOccupation,
          String? customName,
          String? traits,
          String? customPromptAddition,
          Value<String?> voiceLanguage = const Value.absent(),
          double? voicePitch,
          double? voiceSpeed,
          int? avatarIconCode,
          Value<String?> avatarIconFontFamily = const Value.absent(),
          Value<String?> avatarIconFontPackage = const Value.absent()}) =>
      CustomPersonality(
        id: id ?? this.id,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        occupation: occupation ?? this.occupation,
        customOccupation: customOccupation ?? this.customOccupation,
        customName: customName ?? this.customName,
        traits: traits ?? this.traits,
        customPromptAddition: customPromptAddition ?? this.customPromptAddition,
        voiceLanguage:
            voiceLanguage.present ? voiceLanguage.value : this.voiceLanguage,
        voicePitch: voicePitch ?? this.voicePitch,
        voiceSpeed: voiceSpeed ?? this.voiceSpeed,
        avatarIconCode: avatarIconCode ?? this.avatarIconCode,
        avatarIconFontFamily: avatarIconFontFamily.present
            ? avatarIconFontFamily.value
            : this.avatarIconFontFamily,
        avatarIconFontPackage: avatarIconFontPackage.present
            ? avatarIconFontPackage.value
            : this.avatarIconFontPackage,
      );
  CustomPersonality copyWithCompanion(CustomPersonalitiesCompanion data) {
    return CustomPersonality(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      occupation:
          data.occupation.present ? data.occupation.value : this.occupation,
      customOccupation: data.customOccupation.present
          ? data.customOccupation.value
          : this.customOccupation,
      customName:
          data.customName.present ? data.customName.value : this.customName,
      traits: data.traits.present ? data.traits.value : this.traits,
      customPromptAddition: data.customPromptAddition.present
          ? data.customPromptAddition.value
          : this.customPromptAddition,
      voiceLanguage: data.voiceLanguage.present
          ? data.voiceLanguage.value
          : this.voiceLanguage,
      voicePitch:
          data.voicePitch.present ? data.voicePitch.value : this.voicePitch,
      voiceSpeed:
          data.voiceSpeed.present ? data.voiceSpeed.value : this.voiceSpeed,
      avatarIconCode: data.avatarIconCode.present
          ? data.avatarIconCode.value
          : this.avatarIconCode,
      avatarIconFontFamily: data.avatarIconFontFamily.present
          ? data.avatarIconFontFamily.value
          : this.avatarIconFontFamily,
      avatarIconFontPackage: data.avatarIconFontPackage.present
          ? data.avatarIconFontPackage.value
          : this.avatarIconFontPackage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomPersonality(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('occupation: $occupation, ')
          ..write('customOccupation: $customOccupation, ')
          ..write('customName: $customName, ')
          ..write('traits: $traits, ')
          ..write('customPromptAddition: $customPromptAddition, ')
          ..write('voiceLanguage: $voiceLanguage, ')
          ..write('voicePitch: $voicePitch, ')
          ..write('voiceSpeed: $voiceSpeed, ')
          ..write('avatarIconCode: $avatarIconCode, ')
          ..write('avatarIconFontFamily: $avatarIconFontFamily, ')
          ..write('avatarIconFontPackage: $avatarIconFontPackage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      gender,
      occupation,
      customOccupation,
      customName,
      traits,
      customPromptAddition,
      voiceLanguage,
      voicePitch,
      voiceSpeed,
      avatarIconCode,
      avatarIconFontFamily,
      avatarIconFontPackage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomPersonality &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.occupation == this.occupation &&
          other.customOccupation == this.customOccupation &&
          other.customName == this.customName &&
          other.traits == this.traits &&
          other.customPromptAddition == this.customPromptAddition &&
          other.voiceLanguage == this.voiceLanguage &&
          other.voicePitch == this.voicePitch &&
          other.voiceSpeed == this.voiceSpeed &&
          other.avatarIconCode == this.avatarIconCode &&
          other.avatarIconFontFamily == this.avatarIconFontFamily &&
          other.avatarIconFontPackage == this.avatarIconFontPackage);
}

class CustomPersonalitiesCompanion extends UpdateCompanion<CustomPersonality> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> gender;
  final Value<int> occupation;
  final Value<String> customOccupation;
  final Value<String> customName;
  final Value<String> traits;
  final Value<String> customPromptAddition;
  final Value<String?> voiceLanguage;
  final Value<double> voicePitch;
  final Value<double> voiceSpeed;
  final Value<int> avatarIconCode;
  final Value<String?> avatarIconFontFamily;
  final Value<String?> avatarIconFontPackage;
  final Value<int> rowid;
  const CustomPersonalitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.occupation = const Value.absent(),
    this.customOccupation = const Value.absent(),
    this.customName = const Value.absent(),
    this.traits = const Value.absent(),
    this.customPromptAddition = const Value.absent(),
    this.voiceLanguage = const Value.absent(),
    this.voicePitch = const Value.absent(),
    this.voiceSpeed = const Value.absent(),
    this.avatarIconCode = const Value.absent(),
    this.avatarIconFontFamily = const Value.absent(),
    this.avatarIconFontPackage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomPersonalitiesCompanion.insert({
    required String id,
    required String name,
    required int gender,
    required int occupation,
    required String customOccupation,
    required String customName,
    required String traits,
    required String customPromptAddition,
    this.voiceLanguage = const Value.absent(),
    required double voicePitch,
    required double voiceSpeed,
    required int avatarIconCode,
    this.avatarIconFontFamily = const Value.absent(),
    this.avatarIconFontPackage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        gender = Value(gender),
        occupation = Value(occupation),
        customOccupation = Value(customOccupation),
        customName = Value(customName),
        traits = Value(traits),
        customPromptAddition = Value(customPromptAddition),
        voicePitch = Value(voicePitch),
        voiceSpeed = Value(voiceSpeed),
        avatarIconCode = Value(avatarIconCode);
  static Insertable<CustomPersonality> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? gender,
    Expression<int>? occupation,
    Expression<String>? customOccupation,
    Expression<String>? customName,
    Expression<String>? traits,
    Expression<String>? customPromptAddition,
    Expression<String>? voiceLanguage,
    Expression<double>? voicePitch,
    Expression<double>? voiceSpeed,
    Expression<int>? avatarIconCode,
    Expression<String>? avatarIconFontFamily,
    Expression<String>? avatarIconFontPackage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (occupation != null) 'occupation': occupation,
      if (customOccupation != null) 'custom_occupation': customOccupation,
      if (customName != null) 'custom_name': customName,
      if (traits != null) 'traits': traits,
      if (customPromptAddition != null)
        'custom_prompt_addition': customPromptAddition,
      if (voiceLanguage != null) 'voice_language': voiceLanguage,
      if (voicePitch != null) 'voice_pitch': voicePitch,
      if (voiceSpeed != null) 'voice_speed': voiceSpeed,
      if (avatarIconCode != null) 'avatar_icon_code': avatarIconCode,
      if (avatarIconFontFamily != null)
        'avatar_icon_font_family': avatarIconFontFamily,
      if (avatarIconFontPackage != null)
        'avatar_icon_font_package': avatarIconFontPackage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomPersonalitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? gender,
      Value<int>? occupation,
      Value<String>? customOccupation,
      Value<String>? customName,
      Value<String>? traits,
      Value<String>? customPromptAddition,
      Value<String?>? voiceLanguage,
      Value<double>? voicePitch,
      Value<double>? voiceSpeed,
      Value<int>? avatarIconCode,
      Value<String?>? avatarIconFontFamily,
      Value<String?>? avatarIconFontPackage,
      Value<int>? rowid}) {
    return CustomPersonalitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      customOccupation: customOccupation ?? this.customOccupation,
      customName: customName ?? this.customName,
      traits: traits ?? this.traits,
      customPromptAddition: customPromptAddition ?? this.customPromptAddition,
      voiceLanguage: voiceLanguage ?? this.voiceLanguage,
      voicePitch: voicePitch ?? this.voicePitch,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      avatarIconCode: avatarIconCode ?? this.avatarIconCode,
      avatarIconFontFamily: avatarIconFontFamily ?? this.avatarIconFontFamily,
      avatarIconFontPackage:
          avatarIconFontPackage ?? this.avatarIconFontPackage,
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
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<int>(occupation.value);
    }
    if (customOccupation.present) {
      map['custom_occupation'] = Variable<String>(customOccupation.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (traits.present) {
      map['traits'] = Variable<String>(traits.value);
    }
    if (customPromptAddition.present) {
      map['custom_prompt_addition'] =
          Variable<String>(customPromptAddition.value);
    }
    if (voiceLanguage.present) {
      map['voice_language'] = Variable<String>(voiceLanguage.value);
    }
    if (voicePitch.present) {
      map['voice_pitch'] = Variable<double>(voicePitch.value);
    }
    if (voiceSpeed.present) {
      map['voice_speed'] = Variable<double>(voiceSpeed.value);
    }
    if (avatarIconCode.present) {
      map['avatar_icon_code'] = Variable<int>(avatarIconCode.value);
    }
    if (avatarIconFontFamily.present) {
      map['avatar_icon_font_family'] =
          Variable<String>(avatarIconFontFamily.value);
    }
    if (avatarIconFontPackage.present) {
      map['avatar_icon_font_package'] =
          Variable<String>(avatarIconFontPackage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomPersonalitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('occupation: $occupation, ')
          ..write('customOccupation: $customOccupation, ')
          ..write('customName: $customName, ')
          ..write('traits: $traits, ')
          ..write('customPromptAddition: $customPromptAddition, ')
          ..write('voiceLanguage: $voiceLanguage, ')
          ..write('voicePitch: $voicePitch, ')
          ..write('voiceSpeed: $voiceSpeed, ')
          ..write('avatarIconCode: $avatarIconCode, ')
          ..write('avatarIconFontFamily: $avatarIconFontFamily, ')
          ..write('avatarIconFontPackage: $avatarIconFontPackage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedDataTable extends SavedData
    with TableInfo<$SavedDataTable, SavedDatum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
      'prompt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, title, content, prompt, language, description, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_data';
  @override
  VerificationContext validateIntegrity(Insertable<SavedDatum> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(_promptMeta,
          prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedDatum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedDatum(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      prompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prompt']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $SavedDataTable createAlias(String alias) {
    return $SavedDataTable(attachedDatabase, alias);
  }
}

class SavedDatum extends DataClass implements Insertable<SavedDatum> {
  final int id;
  final String type;
  final String title;
  final String content;
  final String? prompt;
  final String? language;
  final String? description;
  final DateTime timestamp;
  const SavedDatum(
      {required this.id,
      required this.type,
      required this.title,
      required this.content,
      this.prompt,
      this.language,
      this.description,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || prompt != null) {
      map['prompt'] = Variable<String>(prompt);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  SavedDataCompanion toCompanion(bool nullToAbsent) {
    return SavedDataCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      content: Value(content),
      prompt:
          prompt == null && nullToAbsent ? const Value.absent() : Value(prompt),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      timestamp: Value(timestamp),
    );
  }

  factory SavedDatum.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedDatum(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      prompt: serializer.fromJson<String?>(json['prompt']),
      language: serializer.fromJson<String?>(json['language']),
      description: serializer.fromJson<String?>(json['description']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'prompt': serializer.toJson<String?>(prompt),
      'language': serializer.toJson<String?>(language),
      'description': serializer.toJson<String?>(description),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  SavedDatum copyWith(
          {int? id,
          String? type,
          String? title,
          String? content,
          Value<String?> prompt = const Value.absent(),
          Value<String?> language = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DateTime? timestamp}) =>
      SavedDatum(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        content: content ?? this.content,
        prompt: prompt.present ? prompt.value : this.prompt,
        language: language.present ? language.value : this.language,
        description: description.present ? description.value : this.description,
        timestamp: timestamp ?? this.timestamp,
      );
  SavedDatum copyWithCompanion(SavedDataCompanion data) {
    return SavedDatum(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      language: data.language.present ? data.language.value : this.language,
      description:
          data.description.present ? data.description.value : this.description,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedDatum(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('prompt: $prompt, ')
          ..write('language: $language, ')
          ..write('description: $description, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, type, title, content, prompt, language, description, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedDatum &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.content == this.content &&
          other.prompt == this.prompt &&
          other.language == this.language &&
          other.description == this.description &&
          other.timestamp == this.timestamp);
}

class SavedDataCompanion extends UpdateCompanion<SavedDatum> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> prompt;
  final Value<String?> language;
  final Value<String?> description;
  final Value<DateTime> timestamp;
  const SavedDataCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.prompt = const Value.absent(),
    this.language = const Value.absent(),
    this.description = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  SavedDataCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    required String content,
    this.prompt = const Value.absent(),
    this.language = const Value.absent(),
    this.description = const Value.absent(),
    this.timestamp = const Value.absent(),
  })  : type = Value(type),
        title = Value(title),
        content = Value(content);
  static Insertable<SavedDatum> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? prompt,
    Expression<String>? language,
    Expression<String>? description,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (prompt != null) 'prompt': prompt,
      if (language != null) 'language': language,
      if (description != null) 'description': description,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  SavedDataCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? title,
      Value<String>? content,
      Value<String?>? prompt,
      Value<String?>? language,
      Value<String?>? description,
      Value<DateTime>? timestamp}) {
    return SavedDataCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      prompt: prompt ?? this.prompt,
      language: language ?? this.language,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedDataCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('prompt: $prompt, ')
          ..write('language: $language, ')
          ..write('description: $description, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CorrectionHistoryTable correctionHistory =
      $CorrectionHistoryTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $CustomPersonalitiesTable customPersonalities =
      $CustomPersonalitiesTable(this);
  late final $SavedDataTable savedData = $SavedDataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [correctionHistory, userSettings, customPersonalities, savedData];
}

typedef $$CorrectionHistoryTableCreateCompanionBuilder
    = CorrectionHistoryCompanion Function({
  Value<int> id,
  required String originalText,
  required String correctedText,
  required String explanation,
  Value<String> style,
  Value<String?> modelName,
  Value<bool> isImage,
  Value<String?> imageUrl,
  Value<DateTime> timestamp,
});
typedef $$CorrectionHistoryTableUpdateCompanionBuilder
    = CorrectionHistoryCompanion Function({
  Value<int> id,
  Value<String> originalText,
  Value<String> correctedText,
  Value<String> explanation,
  Value<String> style,
  Value<String?> modelName,
  Value<bool> isImage,
  Value<String?> imageUrl,
  Value<DateTime> timestamp,
});

class $$CorrectionHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorrectionHistoryTable,
    CorrectionHistoryData,
    $$CorrectionHistoryTableFilterComposer,
    $$CorrectionHistoryTableOrderingComposer,
    $$CorrectionHistoryTableCreateCompanionBuilder,
    $$CorrectionHistoryTableUpdateCompanionBuilder> {
  $$CorrectionHistoryTableTableManager(
      _$AppDatabase db, $CorrectionHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CorrectionHistoryTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$CorrectionHistoryTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalText = const Value.absent(),
            Value<String> correctedText = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<String> style = const Value.absent(),
            Value<String?> modelName = const Value.absent(),
            Value<bool> isImage = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              CorrectionHistoryCompanion(
            id: id,
            originalText: originalText,
            correctedText: correctedText,
            explanation: explanation,
            style: style,
            modelName: modelName,
            isImage: isImage,
            imageUrl: imageUrl,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalText,
            required String correctedText,
            required String explanation,
            Value<String> style = const Value.absent(),
            Value<String?> modelName = const Value.absent(),
            Value<bool> isImage = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              CorrectionHistoryCompanion.insert(
            id: id,
            originalText: originalText,
            correctedText: correctedText,
            explanation: explanation,
            style: style,
            modelName: modelName,
            isImage: isImage,
            imageUrl: imageUrl,
            timestamp: timestamp,
          ),
        ));
}

class $$CorrectionHistoryTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CorrectionHistoryTable> {
  $$CorrectionHistoryTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get originalText => $state.composableBuilder(
      column: $state.table.originalText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get correctedText => $state.composableBuilder(
      column: $state.table.correctedText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get explanation => $state.composableBuilder(
      column: $state.table.explanation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get style => $state.composableBuilder(
      column: $state.table.style,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get modelName => $state.composableBuilder(
      column: $state.table.modelName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isImage => $state.composableBuilder(
      column: $state.table.isImage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get imageUrl => $state.composableBuilder(
      column: $state.table.imageUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CorrectionHistoryTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CorrectionHistoryTable> {
  $$CorrectionHistoryTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get originalText => $state.composableBuilder(
      column: $state.table.originalText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get correctedText => $state.composableBuilder(
      column: $state.table.correctedText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get explanation => $state.composableBuilder(
      column: $state.table.explanation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get style => $state.composableBuilder(
      column: $state.table.style,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get modelName => $state.composableBuilder(
      column: $state.table.modelName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isImage => $state.composableBuilder(
      column: $state.table.isImage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get imageUrl => $state.composableBuilder(
      column: $state.table.imageUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UserSettingsTableCreateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<int> id,
  Value<String> selectedStyle,
  Value<String?> activeModelId,
  Value<String> themeMode,
  Value<bool> autoDownloadRecommended,
  Value<DateTime> lastUpdated,
});
typedef $$UserSettingsTableUpdateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<int> id,
  Value<String> selectedStyle,
  Value<String?> activeModelId,
  Value<String> themeMode,
  Value<bool> autoDownloadRecommended,
  Value<DateTime> lastUpdated,
});

class $$UserSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder> {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UserSettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UserSettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> selectedStyle = const Value.absent(),
            Value<String?> activeModelId = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<bool> autoDownloadRecommended = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
          }) =>
              UserSettingsCompanion(
            id: id,
            selectedStyle: selectedStyle,
            activeModelId: activeModelId,
            themeMode: themeMode,
            autoDownloadRecommended: autoDownloadRecommended,
            lastUpdated: lastUpdated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> selectedStyle = const Value.absent(),
            Value<String?> activeModelId = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<bool> autoDownloadRecommended = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
          }) =>
              UserSettingsCompanion.insert(
            id: id,
            selectedStyle: selectedStyle,
            activeModelId: activeModelId,
            themeMode: themeMode,
            autoDownloadRecommended: autoDownloadRecommended,
            lastUpdated: lastUpdated,
          ),
        ));
}

class $$UserSettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get selectedStyle => $state.composableBuilder(
      column: $state.table.selectedStyle,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get activeModelId => $state.composableBuilder(
      column: $state.table.activeModelId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get autoDownloadRecommended => $state.composableBuilder(
      column: $state.table.autoDownloadRecommended,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$UserSettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get selectedStyle => $state.composableBuilder(
      column: $state.table.selectedStyle,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get activeModelId => $state.composableBuilder(
      column: $state.table.activeModelId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get autoDownloadRecommended => $state.composableBuilder(
      column: $state.table.autoDownloadRecommended,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CustomPersonalitiesTableCreateCompanionBuilder
    = CustomPersonalitiesCompanion Function({
  required String id,
  required String name,
  required int gender,
  required int occupation,
  required String customOccupation,
  required String customName,
  required String traits,
  required String customPromptAddition,
  Value<String?> voiceLanguage,
  required double voicePitch,
  required double voiceSpeed,
  required int avatarIconCode,
  Value<String?> avatarIconFontFamily,
  Value<String?> avatarIconFontPackage,
  Value<int> rowid,
});
typedef $$CustomPersonalitiesTableUpdateCompanionBuilder
    = CustomPersonalitiesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> gender,
  Value<int> occupation,
  Value<String> customOccupation,
  Value<String> customName,
  Value<String> traits,
  Value<String> customPromptAddition,
  Value<String?> voiceLanguage,
  Value<double> voicePitch,
  Value<double> voiceSpeed,
  Value<int> avatarIconCode,
  Value<String?> avatarIconFontFamily,
  Value<String?> avatarIconFontPackage,
  Value<int> rowid,
});

class $$CustomPersonalitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomPersonalitiesTable,
    CustomPersonality,
    $$CustomPersonalitiesTableFilterComposer,
    $$CustomPersonalitiesTableOrderingComposer,
    $$CustomPersonalitiesTableCreateCompanionBuilder,
    $$CustomPersonalitiesTableUpdateCompanionBuilder> {
  $$CustomPersonalitiesTableTableManager(
      _$AppDatabase db, $CustomPersonalitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$CustomPersonalitiesTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$CustomPersonalitiesTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<int> occupation = const Value.absent(),
            Value<String> customOccupation = const Value.absent(),
            Value<String> customName = const Value.absent(),
            Value<String> traits = const Value.absent(),
            Value<String> customPromptAddition = const Value.absent(),
            Value<String?> voiceLanguage = const Value.absent(),
            Value<double> voicePitch = const Value.absent(),
            Value<double> voiceSpeed = const Value.absent(),
            Value<int> avatarIconCode = const Value.absent(),
            Value<String?> avatarIconFontFamily = const Value.absent(),
            Value<String?> avatarIconFontPackage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomPersonalitiesCompanion(
            id: id,
            name: name,
            gender: gender,
            occupation: occupation,
            customOccupation: customOccupation,
            customName: customName,
            traits: traits,
            customPromptAddition: customPromptAddition,
            voiceLanguage: voiceLanguage,
            voicePitch: voicePitch,
            voiceSpeed: voiceSpeed,
            avatarIconCode: avatarIconCode,
            avatarIconFontFamily: avatarIconFontFamily,
            avatarIconFontPackage: avatarIconFontPackage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int gender,
            required int occupation,
            required String customOccupation,
            required String customName,
            required String traits,
            required String customPromptAddition,
            Value<String?> voiceLanguage = const Value.absent(),
            required double voicePitch,
            required double voiceSpeed,
            required int avatarIconCode,
            Value<String?> avatarIconFontFamily = const Value.absent(),
            Value<String?> avatarIconFontPackage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomPersonalitiesCompanion.insert(
            id: id,
            name: name,
            gender: gender,
            occupation: occupation,
            customOccupation: customOccupation,
            customName: customName,
            traits: traits,
            customPromptAddition: customPromptAddition,
            voiceLanguage: voiceLanguage,
            voicePitch: voicePitch,
            voiceSpeed: voiceSpeed,
            avatarIconCode: avatarIconCode,
            avatarIconFontFamily: avatarIconFontFamily,
            avatarIconFontPackage: avatarIconFontPackage,
            rowid: rowid,
          ),
        ));
}

class $$CustomPersonalitiesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomPersonalitiesTable> {
  $$CustomPersonalitiesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get occupation => $state.composableBuilder(
      column: $state.table.occupation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customOccupation => $state.composableBuilder(
      column: $state.table.customOccupation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customName => $state.composableBuilder(
      column: $state.table.customName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get traits => $state.composableBuilder(
      column: $state.table.traits,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customPromptAddition => $state.composableBuilder(
      column: $state.table.customPromptAddition,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get voiceLanguage => $state.composableBuilder(
      column: $state.table.voiceLanguage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get voicePitch => $state.composableBuilder(
      column: $state.table.voicePitch,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get voiceSpeed => $state.composableBuilder(
      column: $state.table.voiceSpeed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get avatarIconCode => $state.composableBuilder(
      column: $state.table.avatarIconCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarIconFontFamily => $state.composableBuilder(
      column: $state.table.avatarIconFontFamily,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatarIconFontPackage => $state.composableBuilder(
      column: $state.table.avatarIconFontPackage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CustomPersonalitiesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomPersonalitiesTable> {
  $$CustomPersonalitiesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get occupation => $state.composableBuilder(
      column: $state.table.occupation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customOccupation => $state.composableBuilder(
      column: $state.table.customOccupation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customName => $state.composableBuilder(
      column: $state.table.customName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get traits => $state.composableBuilder(
      column: $state.table.traits,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customPromptAddition => $state.composableBuilder(
      column: $state.table.customPromptAddition,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get voiceLanguage => $state.composableBuilder(
      column: $state.table.voiceLanguage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get voicePitch => $state.composableBuilder(
      column: $state.table.voicePitch,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get voiceSpeed => $state.composableBuilder(
      column: $state.table.voiceSpeed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get avatarIconCode => $state.composableBuilder(
      column: $state.table.avatarIconCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarIconFontFamily => $state.composableBuilder(
      column: $state.table.avatarIconFontFamily,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatarIconFontPackage => $state.composableBuilder(
      column: $state.table.avatarIconFontPackage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SavedDataTableCreateCompanionBuilder = SavedDataCompanion Function({
  Value<int> id,
  required String type,
  required String title,
  required String content,
  Value<String?> prompt,
  Value<String?> language,
  Value<String?> description,
  Value<DateTime> timestamp,
});
typedef $$SavedDataTableUpdateCompanionBuilder = SavedDataCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> title,
  Value<String> content,
  Value<String?> prompt,
  Value<String?> language,
  Value<String?> description,
  Value<DateTime> timestamp,
});

class $$SavedDataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedDataTable,
    SavedDatum,
    $$SavedDataTableFilterComposer,
    $$SavedDataTableOrderingComposer,
    $$SavedDataTableCreateCompanionBuilder,
    $$SavedDataTableUpdateCompanionBuilder> {
  $$SavedDataTableTableManager(_$AppDatabase db, $SavedDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SavedDataTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SavedDataTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> prompt = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              SavedDataCompanion(
            id: id,
            type: type,
            title: title,
            content: content,
            prompt: prompt,
            language: language,
            description: description,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String title,
            required String content,
            Value<String?> prompt = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              SavedDataCompanion.insert(
            id: id,
            type: type,
            title: title,
            content: content,
            prompt: prompt,
            language: language,
            description: description,
            timestamp: timestamp,
          ),
        ));
}

class $$SavedDataTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SavedDataTable> {
  $$SavedDataTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get prompt => $state.composableBuilder(
      column: $state.table.prompt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SavedDataTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SavedDataTable> {
  $$SavedDataTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get prompt => $state.composableBuilder(
      column: $state.table.prompt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CorrectionHistoryTableTableManager get correctionHistory =>
      $$CorrectionHistoryTableTableManager(_db, _db.correctionHistory);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$CustomPersonalitiesTableTableManager get customPersonalities =>
      $$CustomPersonalitiesTableTableManager(_db, _db.customPersonalities);
  $$SavedDataTableTableManager get savedData =>
      $$SavedDataTableTableManager(_db, _db.savedData);
}
