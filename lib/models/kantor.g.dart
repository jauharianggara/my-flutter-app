// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kantor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kantor _$KantorFromJson(Map<String, dynamic> json) => Kantor(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      telefon: json['telefon'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$KantorToJson(Kantor instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'alamat': instance.alamat,
      'telefon': instance.telefon,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CreateKantorRequest _$CreateKantorRequestFromJson(Map<String, dynamic> json) =>
    CreateKantorRequest(
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      telefon: json['telefon'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateKantorRequestToJson(
        CreateKantorRequest instance) =>
    <String, dynamic>{
      'nama': instance.nama,
      'alamat': instance.alamat,
      'telefon': instance.telefon,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

UpdateKantorRequest _$UpdateKantorRequestFromJson(Map<String, dynamic> json) =>
    UpdateKantorRequest(
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      telefon: json['telefon'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateKantorRequestToJson(
        UpdateKantorRequest instance) =>
    <String, dynamic>{
      'nama': instance.nama,
      'alamat': instance.alamat,
      'telefon': instance.telefon,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
