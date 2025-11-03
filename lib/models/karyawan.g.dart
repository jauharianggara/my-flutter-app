// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karyawan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Karyawan _$KaryawanFromJson(Map<String, dynamic> json) => Karyawan(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String?,
      kantorId: (json['kantor_id'] as num?)?.toInt(),
      jabatanId: (json['jabatan_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      fotoUrl: json['foto_url'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$KaryawanToJson(Karyawan instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'email': instance.email,
      'telefon': instance.telefon,
      'kantor_id': instance.kantorId,
      'jabatan_id': instance.jabatanId,
      'user_id': instance.userId,
      'foto_url': instance.fotoUrl,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

KaryawanWithKantor _$KaryawanWithKantorFromJson(Map<String, dynamic> json) =>
    KaryawanWithKantor(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String?,
      kantorId: (json['kantor_id'] as num?)?.toInt(),
      jabatanId: (json['jabatan_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      fotoUrl: json['foto_url'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      kantor: json['kantor'] == null
          ? null
          : Kantor.fromJson(json['kantor'] as Map<String, dynamic>),
      jabatan: Jabatan.fromJson(json['jabatan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KaryawanWithKantorToJson(KaryawanWithKantor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'email': instance.email,
      'telefon': instance.telefon,
      'kantor_id': instance.kantorId,
      'jabatan_id': instance.jabatanId,
      'user_id': instance.userId,
      'foto_url': instance.fotoUrl,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'kantor': instance.kantor,
      'jabatan': instance.jabatan,
    };

CreateKaryawanRequest _$CreateKaryawanRequestFromJson(
        Map<String, dynamic> json) =>
    CreateKaryawanRequest(
      nama: json['nama'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String?,
      kantorId: (json['kantor_id'] as num?)?.toInt(),
      jabatanId: (json['jabatan_id'] as num).toInt(),
    );

Map<String, dynamic> _$CreateKaryawanRequestToJson(
        CreateKaryawanRequest instance) =>
    <String, dynamic>{
      'nama': instance.nama,
      'email': instance.email,
      'telefon': instance.telefon,
      'kantor_id': instance.kantorId,
      'jabatan_id': instance.jabatanId,
    };

UpdateKaryawanRequest _$UpdateKaryawanRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateKaryawanRequest(
      nama: json['nama'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String?,
      kantorId: (json['kantor_id'] as num?)?.toInt(),
      jabatanId: (json['jabatan_id'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateKaryawanRequestToJson(
        UpdateKaryawanRequest instance) =>
    <String, dynamic>{
      'nama': instance.nama,
      'email': instance.email,
      'telefon': instance.telefon,
      'kantor_id': instance.kantorId,
      'jabatan_id': instance.jabatanId,
    };
