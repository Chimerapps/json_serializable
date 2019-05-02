// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:yaml_decode/yaml_decode.dart';

part 'example.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  nullable: false,
)
class Configuration {
  @JsonKey(required: true)
  final String name;
  @JsonKey(required: true)
  final int count;

  Configuration({this.name, this.count}) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty.');
    }
  }

  factory Configuration.fromJson(Map json) => _$ConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);

  @override
  String toString() => 'Configuration: ${toJson()}';
}

void main(List<String> arguments) {
  final fileContents = File(arguments.single).readAsStringSync();

  final config = checkedYamlDecode(
      fileContents, (m) => Configuration.fromJson(m),
      sourceUrl: arguments.single);
  print(config);
}
