import 'package:json_annotation/json_annotation.dart';

part 'jabatan.g.dart';

@JsonSerializable()
class Jabatan {
  final int id;
  @JsonKey(name: 'nama_jabatan')
  final String namaJabatan;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Jabatan({
    required this.id,
    required this.namaJabatan,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Jabatan.fromJson(Map<String, dynamic> json) => _$JabatanFromJson(json);
  Map<String, dynamic> toJson() => _$JabatanToJson(this);
}

@JsonSerializable()
class CreateJabatanRequest {
  @JsonKey(name: 'nama_jabatan')
  final String namaJabatan;

  CreateJabatanRequest({
    required this.namaJabatan,
  });

  factory CreateJabatanRequest.fromJson(Map<String, dynamic> json) => _$CreateJabatanRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateJabatanRequestToJson(this);
}

@JsonSerializable()
class UpdateJabatanRequest {
  @JsonKey(name: 'nama_jabatan')
  final String namaJabatan;

  UpdateJabatanRequest({
    required this.namaJabatan,
  });

  factory UpdateJabatanRequest.fromJson(Map<String, dynamic> json) => _$UpdateJabatanRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateJabatanRequestToJson(this);
}