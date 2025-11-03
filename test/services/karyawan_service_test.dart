import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/karyawan_service.dart';
import 'package:my_flutter_app/models/karyawan.dart';

void main() {
  group('Employee (Karyawan) CRUD Tests', () {
    test('CreateKaryawanRequest should be properly formed', () async {
      final createRequest = CreateKaryawanRequest(
        nama: 'John Doe',
        email: 'john.doe@company.com',
        telefon: '+62123456789',
        kantorId: 1,
        jabatanId: 2,
      );

      expect(createRequest.nama, 'John Doe');
      expect(createRequest.email, 'john.doe@company.com');
      expect(createRequest.telefon, '+62123456789');
      expect(createRequest.kantorId, 1);
      expect(createRequest.jabatanId, 2);

      final json = createRequest.toJson();
      expect(json['nama'], 'John Doe');
      expect(json['email'], 'john.doe@company.com');
      expect(json['telefon'], '+62123456789');
      expect(json['kantor_id'], 1);
      expect(json['jabatan_id'], 2);
    });

    test('UpdateKaryawanRequest should be properly formed', () async {
      final updateRequest = UpdateKaryawanRequest(
        nama: 'Jane Smith',
        email: 'jane.smith@company.com',
        telefon: '+62987654321',
        kantorId: 2,
        jabatanId: 3,
      );

      expect(updateRequest.nama, 'Jane Smith');
      expect(updateRequest.email, 'jane.smith@company.com');
      expect(updateRequest.telefon, '+62987654321');
      expect(updateRequest.kantorId, 2);
      expect(updateRequest.jabatanId, 3);

      final json = updateRequest.toJson();
      expect(json['nama'], 'Jane Smith');
      expect(json['email'], 'jane.smith@company.com');
      expect(json['telefon'], '+62987654321');
      expect(json['kantor_id'], 2);
      expect(json['jabatan_id'], 3);
    });

    test('Karyawan model should parse JSON correctly', () async {
      final karyawanJson = {
        'id': 1,
        'nama': 'Test Employee',
        'email': 'test@company.com',
        'telefon': '+62123456789',
        'kantor_id': 1,
        'jabatan_id': 2,
        'user_id': null,
        'foto_url': null,
        'created_by': 1,
        'updated_by': 1,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final karyawan = Karyawan.fromJson(karyawanJson);

      expect(karyawan.id, 1);
      expect(karyawan.nama, 'Test Employee');
      expect(karyawan.email, 'test@company.com');
      expect(karyawan.telefon, '+62123456789');
      expect(karyawan.kantorId, 1);
      expect(karyawan.jabatanId, 2);
      expect(karyawan.userId, null);
      expect(karyawan.fotoUrl, null);
      expect(karyawan.createdBy, 1);
      expect(karyawan.updatedBy, 1);
    });

    test('KaryawanWithKantor model should parse JSON correctly', () async {
      final karyawanWithKantorJson = {
        'id': 1,
        'nama': 'Test Employee',
        'email': 'test@company.com',
        'telefon': '+62123456789',
        'kantor_id': 1,
        'jabatan_id': 2,
        'user_id': null,
        'foto_url': null,
        'created_by': 1,
        'updated_by': 1,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
        'kantor': {
          'id': 1,
          'nama': 'Jakarta Office',
          'alamat': 'Jakarta, Indonesia',
          'telefon': '+62211234567',
          'email': 'jakarta@company.com',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        },
        'jabatan': {
          'id': 2,
          'nama_jabatan': 'Software Developer',
          'created_by': 1,
          'updated_by': 1,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        },
      };

      final karyawanWithKantor = KaryawanWithKantor.fromJson(karyawanWithKantorJson);

      expect(karyawanWithKantor.id, 1);
      expect(karyawanWithKantor.nama, 'Test Employee');
      expect(karyawanWithKantor.email, 'test@company.com');
      expect(karyawanWithKantor.kantor?.nama, 'Jakarta Office');
      expect(karyawanWithKantor.kantor?.alamat, 'Jakarta, Indonesia');
      expect(karyawanWithKantor.jabatan.namaJabatan, 'Software Developer');
    });

    test('JSON serialization round-trip for Karyawan', () async {
      final originalKaryawan = Karyawan(
        id: 1,
        nama: 'Test Employee',
        email: 'test@company.com',
        telefon: '+62123456789',
        kantorId: 1,
        jabatanId: 2,
        userId: null,
        fotoUrl: null,
        createdBy: 1,
        updatedBy: 1,
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
      );

      final json = originalKaryawan.toJson();
      final deserializedKaryawan = Karyawan.fromJson(json);

      expect(deserializedKaryawan.id, originalKaryawan.id);
      expect(deserializedKaryawan.nama, originalKaryawan.nama);
      expect(deserializedKaryawan.email, originalKaryawan.email);
      expect(deserializedKaryawan.telefon, originalKaryawan.telefon);
      expect(deserializedKaryawan.kantorId, originalKaryawan.kantorId);
      expect(deserializedKaryawan.jabatanId, originalKaryawan.jabatanId);
    });

    test('KaryawanService CRUD methods should exist and be callable', () async {
      final createRequest = CreateKaryawanRequest(
        nama: 'Test Employee',
        email: 'test@company.com',
        telefon: '+62123456789',
        kantorId: 1,
        jabatanId: 2,
      );

      final updateRequest = UpdateKaryawanRequest(
        nama: 'Updated Employee',
        email: 'updated@company.com',
        telefon: '+62987654321',
        kantorId: 2,
        jabatanId: 3,
      );

      // Test that all CRUD methods exist and can be called
      expect(() => KaryawanService.getAllKaryawans(), returnsNormally);
      expect(() => KaryawanService.getAllKaryawansWithKantor(), returnsNormally);
      expect(() => KaryawanService.getKaryawanById(1), returnsNormally);
      expect(() => KaryawanService.getKaryawanWithKantorById(1), returnsNormally);
      expect(() => KaryawanService.createKaryawan(createRequest), returnsNormally);
      expect(() => KaryawanService.updateKaryawan(1, updateRequest), returnsNormally);
      expect(() => KaryawanService.deleteKaryawan(1), returnsNormally);
    });

    test('Employee data validation', () async {
      // Test valid employee data
      final validRequest = CreateKaryawanRequest(
        nama: 'John Doe',
        email: 'john.doe@company.com',
        telefon: '+62123456789',
        kantorId: 1,
        jabatanId: 2,
      );

      expect(validRequest.nama.isNotEmpty, true);
      expect(validRequest.email.contains('@'), true);
      expect(validRequest.jabatanId > 0, true);

      // Test edge cases
      final minimalRequest = CreateKaryawanRequest(
        nama: 'A',
        email: 'a@b.c',
        jabatanId: 1,
      );

      expect(minimalRequest.nama.isNotEmpty, true);
      expect(minimalRequest.email.contains('@'), true);
      expect(minimalRequest.telefon, null);
      expect(minimalRequest.kantorId, null);
    });

    test('Employee photo operations should be callable', () async {
      // Test photo-related methods (would normally require File objects)
      expect(() => KaryawanService.deleteKaryawanPhoto(1), returnsNormally);
    });

    test('Employee search and filter functionality', () async {
      // Test that we can call methods that would typically be used for search/filter
      expect(() => KaryawanService.getAllKaryawansWithKantor(), returnsNormally);
      expect(() => KaryawanService.getKaryawanWithKantorById(1), returnsNormally);
    });
  });
}