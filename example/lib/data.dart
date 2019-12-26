import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable(includeIfNull: false)
class Data {
  @JsonKey(name:'description', disallowNullValue: true)
  final String description;
  @JsonKey(path: 'GlossDiv/GlossList/GlossEntry', name: 'ID', nullable: true)
  final String id;

  Data({this.id, this.description});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}