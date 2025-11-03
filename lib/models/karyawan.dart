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
class KaryawanWithKantor extends Karyawan {
  final Kantor? kantor;
  final Jabatan jabatan;

  KaryawanWithKantor({
    required super.id,
    required super.nama,
    required super.email,
    super.telefon,
    super.kantorId,
    required super.jabatanId,
    super.userId,
    super.fotoUrl,
    super.createdBy,
    super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    this.kantor,
    required this.jabatan,
  });

  factory KaryawanWithKantor.fromJson(Map<String, dynamic> json) => _$KaryawanWithKantorFromJson(json);
  @override
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