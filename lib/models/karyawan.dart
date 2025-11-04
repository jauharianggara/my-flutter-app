import 'package:json_annotation/json_annotation.dart';

part 'karyawan.g.dart';

@JsonSerializable()
class Karyawan {
  final int id;
  final String nama;
  final String? email; // Make email nullable since it may not be in response
  final String? telefon;
  final double? gaji; // Add gaji field from API response
  @JsonKey(name: 'kantor_id')
  final int? kantorId;
  @JsonKey(name: 'jabatan_id')
  final int jabatanId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'foto_path') // Change from foto_url to foto_path
  final String? fotoPath;
  @JsonKey(name: 'foto_original_name')
  final String? fotoOriginalName;
  @JsonKey(name: 'foto_size')
  final int? fotoSize;
  @JsonKey(name: 'foto_mime_type')
  final String? fotoMimeType;
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
    this.email, // Make email optional
    this.telefon,
    this.gaji,
    this.kantorId,
    required this.jabatanId,
    this.userId,
    this.fotoPath,
    this.fotoOriginalName,
    this.fotoSize,
    this.fotoMimeType,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) =>
      _$KaryawanFromJson(json);
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

  factory KaryawanWithKantor.fromJson(Map<String, dynamic> json) =>
      _$KaryawanWithKantorFromJson(json);
  Map<String, dynamic> toJson() => _$KaryawanWithKantorToJson(this);
}

@JsonSerializable()
class CreateKaryawanRequest {
  final String nama;
  final String email;
  final String? telefon;
  final String? gaji;
  @JsonKey(name: 'kantor_id')
  final String kantorId; // Change to String and make required
  @JsonKey(name: 'jabatan_id')
  final String jabatanId; // Change to String

  CreateKaryawanRequest({
    required this.nama,
    required this.email,
    this.telefon,
    this.gaji, // Change gaji to String
    required this.kantorId, // Make required and String
    required this.jabatanId, // Change to String
  });

  factory CreateKaryawanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateKaryawanRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateKaryawanRequestToJson(this);
}

@JsonSerializable()
class UpdateKaryawanRequest {
  final String nama;
  final String? email; // Make email nullable
  final String? telefon;
  final String? gaji; // Change gaji to String
  @JsonKey(name: 'kantor_id')
  final String kantorId; // Change to String
  @JsonKey(name: 'jabatan_id')
  final String jabatanId; // Change to String

  UpdateKaryawanRequest({
    required this.nama,
    this.email, // Make email optional
    this.telefon,
    this.gaji, // Add gaji parameter as String
    required this.kantorId, // Change to String
    required this.jabatanId, // Change to String
  });

  factory UpdateKaryawanRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateKaryawanRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateKaryawanRequestToJson(this);
}
