// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karyawan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Karyawan _$KaryawanFromJson(Map<String, dynamic> json) => Karyawan(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      email: json['email'] as String?,
      telefon: json['telefon'] as String?,
      gaji: (json['gaji'] as num?)?.toDouble(),
      kantorId: (json['kantor_id'] as num?)?.toInt(),
      jabatanId: (json['jabatan_id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      fotoPath: json['foto_path'] as String?,
      fotoOriginalName: json['foto_original_name'] as String?,
      fotoSize: (json['foto_size'] as num?)?.toInt(),
      fotoMimeType: json['foto_mime_type'] as String?,
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
      'gaji': instance.gaji,
      'kantor_id': instance.kantorId,
      'jabatan_id': instance.jabatanId,
      'user_id': instance.userId,
      'foto_path': instance.fotoPath,
      'foto_original_name': instance.fotoOriginalName,
      'foto_size': instance.fotoSize,
      'foto_mime_type': instance.fotoMimeType,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

KaryawanWithKantor _$KaryawanWithKantorFromJson(Map<String, dynamic> json) =>
    KaryawanWithKantor(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      gaji: (json['gaji'] as num?)?.toDouble(),
      kantorId: (json['kantor_id'] as num?)?.toInt(),
      kantorNama: json['kantor_nama'] as String?,
      jabatanId: (json['jabatan_id'] as num?)?.toInt(),
      jabatanNama: json['jabatan_nama'] as String?,
      fotoPath: json['foto_path'] as String?,
      fotoOriginalName: json['foto_original_name'] as String?,
      fotoSize: (json['foto_size'] as num?)?.toInt(),
      fotoMimeType: json['foto_mime_type'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$KaryawanWithKantorToJson(KaryawanWithKantor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'gaji': instance.gaji,
      'kantor_id': instance.kantorId,
      'kantor_nama': instance.kantorNama,
      'jabatan_id': instance.jabatanId,
      'jabatan_nama': instance.jabatanNama,
      'foto_path': instance.fotoPath,
      'foto_original_name': instance.fotoOriginalName,
      'foto_size': instance.fotoSize,
      'foto_mime_type': instance.fotoMimeType,
      'user_id': instance.userId,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
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
      email: json['email'] as String?,
      telefon: json['telefon'] as String?,
      gaji: json['gaji'] as String?,
      kantorId: json['kantor_id'] as String,
      jabatanId: json['jabatan_id'] as String,
    );

Map<String, dynamic> _$UpdateKaryawanRequestToJson(
        UpdateKaryawanRequest instance) =>
    <String, dynamic>{
      'nama': instance.nama,
      'email': instance.email,
      'telefon': instance.telefon,
      'gaji': instance.gaji,
      'kantor_id': instance.kantorId,
      'jabatan_id': instance.jabatanId,
    };
