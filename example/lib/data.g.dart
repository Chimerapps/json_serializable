// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  dynamic _safeMapAccess(List<String> path) {
    var element = json;
    for (final pathElement in path) {
      element = element[pathElement] as Map<String, dynamic>;
      if (element == null) break;
    }
    return element;
  }

  $checkKeys(json, disallowNullValues: const ['description']);
  return Data(
    id: _safeMapAccess(['GlossDiv' 'GlossList' 'GlossEntry' 'ID']) as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  {
// ignore: non_constant_identifier_names
    final __jsonNullCheck__ = instance.id;
    if (__jsonNullCheck__ != null) {
      val
              .putIfAbsent('GlossDiv', () => <String, dynamic>{})
              .putIfAbsent('GlossList', () => <String, dynamic>{})
              .putIfAbsent('GlossEntry', () => <String, dynamic>{})['ID'] =
          __jsonNullCheck__;
    }
  }
  return val;
}