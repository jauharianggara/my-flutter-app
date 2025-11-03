// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jabatan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jabatan _$JabatanFromJson(Map<String, dynamic> json) => Jabatan(
      id: (json['id'] as num).toInt(),
      namaJabatan: json['nama_jabatan'] as String,
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$JabatanToJson(Jabatan instance) => <String, dynamic>{
      'id': instance.id,
      'nama_jabatan': instance.namaJabatan,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CreateJabatanRequest _$CreateJabatanRequestFromJson(
        Map<String, dynamic> json) =>
    CreateJabatanRequest(
      namaJabatan: json['nama_jabatan'] as String,
    );

Map<String, dynamic> _$CreateJabatanRequestToJson(
        CreateJabatanRequest instance) =>
    <String, dynamic>{
      'nama_jabatan': instance.namaJabatan,
    };

UpdateJabatanRequest _$UpdateJabatanRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateJabatanRequest(
      namaJabatan: json['nama_jabatan'] as String,
    );

Map<String, dynamic> _$UpdateJabatanRequestToJson(
        UpdateJabatanRequest instance) =>
    <String, dynamic>{
      'nama_jabatan': instance.namaJabatan,
    };
