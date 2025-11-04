import 'package:json_annotation/json_annotation.dart';
import 'kantor.dart';
import 'jabatan.dart';

part 'karyawan.g.dart';

@JsonSerializable()
class Karyawan {
  final int id;
  final String nama;
  final String email;
  final String? telefon;
  @JsonKey(name: 'kantor_id')
  final int? kantorId;
  @JsonKey(name: 'jabatan_id')
  final int jabatanId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Karyawan({
    required this.id,
    required this.nama,
    required this.email,
    this.telefon,
    this.kantorId,
    required this.jabatanId,
    this.userId,
    this.fotoUrl,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) => _$KaryawanFromJson(json);
  Map<String, dynamic> toJson() => _$KaryawanToJson(this);
}

@JsonSerializable()
class KaryawanWithKantor {
  final int id;
  final String nama;
  final double? gaji;
  @JsonKey(name: 'kantor_id')
  final int? kantorId;
  @JsonKey(name: 'kantor_nama')
  final String? kantorNama;
  @JsonKey(name: 'jabatan_id')
  final int? jabatanId;
  @JsonKey(name: 'jabatan_nama')
  final String? jabatanNama;
  @JsonKey(name: 'foto_path')
  final String? fotoPath;
  @JsonKey(name: 'foto_original_name')
  final String? fotoOriginalName;
  @JsonKey(name: 'foto_size')
  final int? fotoSize;
  @JsonKey(name: 'foto_mime_type')
  final String? fotoMimeType;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  KaryawanWithKantor({
    required this.id,
    required this.nama,
    this.gaji,
    this.kantorId,
    this.kantorNama,
    this.jabatanId,
    this.jabatanNama,
    this.fotoPath,
    this.fotoOriginalName,
    this.fotoSize,
    this.fotoMimeType,
    this.userId,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KaryawanWithKantor.fromJson(Map<String, dynamic> json) => _$KaryawanWithKantorFromJson(json);
  Map<String, dynamic> toJson() => _$KaryawanWithKantorToJson(this);
}

@JsonSerializable()
class CreateKaryawanRequest {
  final String nama;
  final String email;
  final String? telefon;
  @JsonKey(name: 'kantor_id')
  final int? kantorId;
  @JsonKey(name: 'jabatan_id')
  final int jabatanId;

  CreateKaryawanRequest({
    required this.nama,
    required this.email,
    this.telefon,
    this.kantorId,
    required this.jabatanId,
  });

  factory CreateKaryawanRequest.fromJson(Map<String, dynamic> json) => _$CreateKaryawanRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateKaryawanRequestToJson(this);
}

@JsonSerializable()
class UpdateKaryawanRequest {
  final String nama;
  final String email;
  final String? telefon;
  @JsonKey(name: 'kantor_id')
  final int? kantorId;
  @JsonKey(name: 'jabatan_id')
  final int jabatanId;

  UpdateKaryawanRequest({
    required this.nama,
    required this.email,
    this.telefon,
    this.kantorId,
    required this.jabatanId,
  });

  factory UpdateKaryawanRequest.fromJson(Map<String, dynamic> json) => _$UpdateKaryawanRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateKaryawanRequestToJson(this);
}