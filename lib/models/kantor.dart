import 'package:json_annotation/json_annotation.dart';

part 'kantor.g.dart';

@JsonSerializable()
class Kantor {
  final int id;
  final String nama;
  final String alamat;
  final String? telefon;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Kantor({
    required this.id,
    required this.nama,
    required this.alamat,
    this.telefon,
    this.latitude,
    this.longitude,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kantor.fromJson(Map<String, dynamic> json) => _$KantorFromJson(json);
  Map<String, dynamic> toJson() => _$KantorToJson(this);
}

@JsonSerializable()
class CreateKantorRequest {
  final String nama;
  final String alamat;
  final String? telefon;
  final double? latitude;
  final double? longitude;

  CreateKantorRequest({
    required this.nama,
    required this.alamat,
    this.telefon,
    this.latitude,
    this.longitude,
  });

  factory CreateKantorRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateKantorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateKantorRequestToJson(this);
}

@JsonSerializable()
class UpdateKantorRequest {
  final String nama;
  final String alamat;
  final String? telefon;
  final double? latitude;
  final double? longitude;

  UpdateKantorRequest({
    required this.nama,
    required this.alamat,
    this.telefon,
    this.latitude,
    this.longitude,
  });

  factory UpdateKantorRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateKantorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateKantorRequestToJson(this);
}
